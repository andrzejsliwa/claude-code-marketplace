#!/bin/bash

# Validation script for Claude Code Marketplace
# Ensures JSON files are valid and component counts match actual files

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "======================================"
echo "Claude Code Marketplace Validation"
echo "======================================"
echo ""

# Function to print error
error() {
    echo -e "${RED}ERROR:${NC} $1"
    ERRORS=$((ERRORS + 1))
}

# Function to print warning
warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

# Function to print success
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    error "jq is not installed. Please install jq to validate JSON files."
    exit 1
fi

# Validate marketplace.json
echo "Validating marketplace.json..."
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

if [ ! -f "$MARKETPLACE_JSON" ]; then
    error "marketplace.json not found at $MARKETPLACE_JSON"
else
    # Validate JSON syntax
    if jq empty "$MARKETPLACE_JSON" 2>/dev/null; then
        success "marketplace.json is valid JSON"
    else
        error "marketplace.json has invalid JSON syntax"
    fi

    # Check required fields
    if jq -e '.name' "$MARKETPLACE_JSON" > /dev/null 2>&1; then
        success "marketplace.json has 'name' field"
    else
        error "marketplace.json missing required 'name' field"
    fi

    if jq -e '.owner' "$MARKETPLACE_JSON" > /dev/null 2>&1; then
        success "marketplace.json has 'owner' field"
    else
        error "marketplace.json missing required 'owner' field"
    fi

    if jq -e '.plugins' "$MARKETPLACE_JSON" > /dev/null 2>&1; then
        success "marketplace.json has 'plugins' field"
    else
        error "marketplace.json missing required 'plugins' field"
    fi
fi

echo ""

# Validate each plugin
echo "Validating plugins..."
PLUGINS_DIR="plugins"

if [ ! -d "$PLUGINS_DIR" ]; then
    error "Plugins directory not found at $PLUGINS_DIR"
    exit 1
fi

for PLUGIN_DIR in "$PLUGINS_DIR"/*; do
    if [ ! -d "$PLUGIN_DIR" ]; then
        continue
    fi

    PLUGIN_NAME=$(basename "$PLUGIN_DIR")
    echo ""
    echo "--- Plugin: $PLUGIN_NAME ---"

    PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"

    if [ ! -f "$PLUGIN_JSON" ]; then
        error "Plugin $PLUGIN_NAME missing plugin.json at $PLUGIN_JSON"
        continue
    fi

    # Validate JSON syntax
    if jq empty "$PLUGIN_JSON" 2>/dev/null; then
        success "plugin.json is valid JSON"
    else
        error "plugin.json has invalid JSON syntax"
        continue
    fi

    # Check required fields
    if jq -e '.name' "$PLUGIN_JSON" > /dev/null 2>&1; then
        success "plugin.json has 'name' field"
    else
        error "plugin.json missing required 'name' field"
    fi

    if jq -e '.version' "$PLUGIN_JSON" > /dev/null 2>&1; then
        success "plugin.json has 'version' field"
    else
        error "plugin.json missing required 'version' field"
    fi

    if jq -e '.description' "$PLUGIN_JSON" > /dev/null 2>&1; then
        success "plugin.json has 'description' field"
    else
        error "plugin.json missing required 'description' field"
    fi

    # List available components (informational only)
    AGENTS_COUNT=$(ls "$PLUGIN_DIR/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
    COMMANDS_COUNT=$(ls "$PLUGIN_DIR/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')
    HOOKS_EXISTS=0
    SKILLS_COUNT=$(ls "$PLUGIN_DIR/skills"/*.md 2>/dev/null | wc -l | tr -d ' ')

    if [ -f "$PLUGIN_DIR/hooks.json" ] || [ -d "$PLUGIN_DIR/hooks" ]; then
        HOOKS_EXISTS=1
    fi

    # Display component summary
    if [ "$COMMANDS_COUNT" -gt 0 ]; then
        success "Found $COMMANDS_COUNT command(s)"
    fi
    if [ "$AGENTS_COUNT" -gt 0 ]; then
        success "Found $AGENTS_COUNT agent(s)"
    fi
    if [ "$HOOKS_EXISTS" -eq 1 ]; then
        success "Found hooks configuration"
    fi
    if [ "$SKILLS_COUNT" -gt 0 ]; then
        success "Found $SKILLS_COUNT skill(s)"
    fi

    # Check for README
    if [ -f "$PLUGIN_DIR/README.md" ]; then
        success "Plugin has README.md"
    else
        warning "Plugin missing README.md (recommended)"
    fi

    # Warn if components field exists (deprecated)
    if jq -e '.components' "$PLUGIN_JSON" > /dev/null 2>&1; then
        warning "Plugin has deprecated 'components' field (not part of official spec)"
    fi
done

echo ""
echo "======================================"
echo "Validation Summary"
echo "======================================"
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}Validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Validation PASSED${NC}"
    if [ "$WARNINGS" -gt 0 ]; then
        echo -e "${YELLOW}(with $WARNINGS warnings)${NC}"
    fi
    exit 0
fi
