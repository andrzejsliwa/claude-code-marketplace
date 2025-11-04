#!/bin/bash

# Unit tests for marketplace validation
# Tests specific aspects of the marketplace structure

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
echo "Marketplace Structure Tests"
echo "======================================"
echo ""

# Test marketplace.json structure
echo "Testing marketplace.json..."

run_test "marketplace.json exists" "test -f .claude-plugin/marketplace.json"
run_test "marketplace.json is valid JSON" "jq empty .claude-plugin/marketplace.json"
run_test "marketplace.json has name field" "jq -e '.name' .claude-plugin/marketplace.json"
run_test "marketplace.json has owner field" "jq -e '.owner' .claude-plugin/marketplace.json"
run_test "marketplace.json has owner.name" "jq -e '.owner.name' .claude-plugin/marketplace.json"
run_test "marketplace.json has owner.url" "jq -e '.owner.url' .claude-plugin/marketplace.json"
run_test "marketplace.json has plugins array" "jq -e '.plugins | type == \"array\"' .claude-plugin/marketplace.json"
run_test "marketplace.json plugins array not empty" "jq -e '.plugins | length > 0' .claude-plugin/marketplace.json"

echo ""
echo "Testing plugin entries in marketplace.json..."

# Test each plugin entry
PLUGIN_COUNT=$(jq '.plugins | length' .claude-plugin/marketplace.json)

for i in $(seq 0 $((PLUGIN_COUNT - 1))); do
    PLUGIN_NAME=$(jq -r ".plugins[$i].name" .claude-plugin/marketplace.json)
    echo ""
    echo "Plugin: $PLUGIN_NAME"

    run_test "  has name field" "jq -e '.plugins[$i].name' .claude-plugin/marketplace.json"
    run_test "  has description field" "jq -e '.plugins[$i].description' .claude-plugin/marketplace.json"
    run_test "  has version field" "jq -e '.plugins[$i].version' .claude-plugin/marketplace.json"
    run_test "  has source field" "jq -e '.plugins[$i].source' .claude-plugin/marketplace.json"
    run_test "  has author field" "jq -e '.plugins[$i].author' .claude-plugin/marketplace.json"
    run_test "  has tags array" "jq -e '.plugins[$i].tags | type == \"array\"' .claude-plugin/marketplace.json"

    # Test that source directory exists
    SOURCE_DIR=$(jq -r ".plugins[$i].source" .claude-plugin/marketplace.json)
    run_test "  source directory exists" "test -d $SOURCE_DIR"

    # Test that plugin.json exists in source
    run_test "  has plugin.json in source" "test -f $SOURCE_DIR/.claude-plugin/plugin.json"
done

echo ""
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
