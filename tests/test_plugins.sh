#!/bin/bash

# Unit tests for plugin validation
# Tests plugin structure and component counts

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo "======================================"
echo "Plugin Structure Tests"
echo "======================================"
echo ""

# Test each plugin
for PLUGIN_DIR in plugins/*; do
    if [ ! -d "$PLUGIN_DIR" ]; then
        continue
    fi

    PLUGIN_NAME=$(basename "$PLUGIN_DIR")
    PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"

    echo "Testing plugin: $PLUGIN_NAME"
    echo ""

    # Basic structure tests
    run_test "  .claude-plugin directory exists" "test -d $PLUGIN_DIR/.claude-plugin"
    run_test "  plugin.json exists" "test -f $PLUGIN_JSON"
    run_test "  plugin.json is valid JSON" "jq empty $PLUGIN_JSON"

    # Required fields
    run_test "  has name field" "jq -e '.name' $PLUGIN_JSON"
    run_test "  has version field" "jq -e '.version' $PLUGIN_JSON"
    run_test "  has description field" "jq -e '.description' $PLUGIN_JSON"
    run_test "  has author field" "jq -e '.author' $PLUGIN_JSON"
    run_test "  has author.name" "jq -e '.author.name' $PLUGIN_JSON"
    run_test "  has keywords array" "jq -e '.keywords | type == \"array\"' $PLUGIN_JSON"

    # Component count validation
    echo ""
    echo "  Component count validation:"

    # Agents
    AGENTS_COUNT=$(ls "$PLUGIN_DIR/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
    AGENTS_JSON=$(jq -r '.components.agents // 0' "$PLUGIN_JSON")
    if [ "$AGENTS_COUNT" -gt 0 ] || [ "$AGENTS_JSON" -gt 0 ]; then
        run_test "    agents count: $AGENTS_COUNT files = $AGENTS_JSON JSON" "test $AGENTS_COUNT -eq $AGENTS_JSON"
    fi

    # Commands
    COMMANDS_COUNT=$(ls "$PLUGIN_DIR/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')
    COMMANDS_JSON=$(jq -r '.components.commands // 0' "$PLUGIN_JSON")
    if [ "$COMMANDS_COUNT" -gt 0 ] || [ "$COMMANDS_JSON" -gt 0 ]; then
        run_test "    commands count: $COMMANDS_COUNT files = $COMMANDS_JSON JSON" "test $COMMANDS_COUNT -eq $COMMANDS_JSON"
    fi

    # Hooks
    HOOKS_COUNT=$(ls "$PLUGIN_DIR/hooks"/*.md 2>/dev/null | wc -l | tr -d ' ')
    HOOKS_JSON=$(jq -r '.components.hooks // 0' "$PLUGIN_JSON")
    if [ "$HOOKS_COUNT" -gt 0 ] || [ "$HOOKS_JSON" -gt 0 ]; then
        run_test "    hooks count: $HOOKS_COUNT files = $HOOKS_JSON JSON" "test $HOOKS_COUNT -eq $HOOKS_JSON"
    fi

    # Skills
    SKILLS_COUNT=$(ls "$PLUGIN_DIR/skills"/*.md 2>/dev/null | wc -l | tr -d ' ')
    SKILLS_JSON=$(jq -r '.components.skills // 0' "$PLUGIN_JSON")
    if [ "$SKILLS_COUNT" -gt 0 ] || [ "$SKILLS_JSON" -gt 0 ]; then
        run_test "    skills count: $SKILLS_COUNT files = $SKILLS_JSON JSON" "test $SKILLS_COUNT -eq $SKILLS_JSON"
    fi

    # Test components object exists if there are any components
    TOTAL_COMPONENTS=$((AGENTS_COUNT + COMMANDS_COUNT + HOOKS_COUNT + SKILLS_COUNT))
    if [ "$TOTAL_COMPONENTS" -gt 0 ]; then
        run_test "  has components object" "jq -e '.components' $PLUGIN_JSON"
    fi

    # Test command files are valid markdown
    if [ "$COMMANDS_COUNT" -gt 0 ]; then
        echo ""
        echo "  Command file validation:"
        for CMD_FILE in "$PLUGIN_DIR/commands"/*.md; do
            CMD_NAME=$(basename "$CMD_FILE" .md)
            run_test "    $CMD_NAME.md is not empty" "test -s $CMD_FILE"
        done
    fi

    echo ""
done

echo "======================================"
echo "Test Summary"
echo "======================================"
echo "Tests run:    $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ "$TESTS_FAILED" -gt 0 ]; then
    echo -e "${RED}TESTS FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}ALL TESTS PASSED${NC}"
    exit 0
fi
