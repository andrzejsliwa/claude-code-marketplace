#!/bin/bash

# Master test runner
# Runs all test suites for the marketplace

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}======================================"
echo "Running All Test Suites"
echo -e "======================================${NC}"
echo ""

FAILED=0

# Run marketplace tests
echo -e "${BLUE}[1/2] Running marketplace structure tests...${NC}"
echo ""
if ./tests/test_marketplace.sh; then
    echo ""
else
    FAILED=1
fi

# Run plugin tests
echo -e "${BLUE}[2/2] Running plugin structure tests...${NC}"
echo ""
if ./tests/test_plugins.sh; then
    echo ""
else
    FAILED=1
fi

# Final summary
echo -e "${BLUE}======================================"
echo "Final Test Results"
echo -e "======================================${NC}"

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}ALL TEST SUITES PASSED ✓${NC}"
    echo ""
    echo "Your marketplace is ready for:"
    echo "  - Local testing"
    echo "  - Git commit"
    echo "  - Distribution"
    exit 0
else
    echo -e "${RED}SOME TESTS FAILED ✗${NC}"
    echo ""
    echo "Please fix the errors above before:"
    echo "  - Committing changes"
    echo "  - Distributing the marketplace"
    exit 1
fi
