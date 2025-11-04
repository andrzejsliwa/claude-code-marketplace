# Test Suite Documentation

Comprehensive testing framework for the Claude Code Marketplace to ensure structural integrity, JSON validity, and component count accuracy.

## Overview

The test suite consists of multiple layers of validation:

1. **Quick Validation** (`scripts/validate.sh`) - Fast validation for pre-commit checks
2. **Marketplace Tests** (`test_marketplace.sh`) - Deep marketplace.json structure validation
3. **Plugin Tests** (`test_plugins.sh`) - Plugin structure and component count validation
4. **Full Test Suite** (`run_all_tests.sh`) - Runs all test suites

## Quick Start

```bash
# Run quick validation (recommended before commits)
./scripts/validate.sh

# Run full test suite
./tests/run_all_tests.sh

# Run specific test suite
./tests/test_marketplace.sh
./tests/test_plugins.sh
```

## Test Scripts

### 1. Validation Script (`scripts/validate.sh`)

**Purpose:** Fast validation of JSON files and component counts

**What it checks:**
- ✓ JSON syntax validity
- ✓ Required fields in marketplace.json
- ✓ Required fields in plugin.json files
- ✓ Component counts match actual files
- ✓ Plugin directory structure
- ✓ README.md presence (warning if missing)

**Usage:**
```bash
./scripts/validate.sh
```

**Exit codes:**
- `0` - All validations passed
- `1` - One or more validations failed

**Example output:**
```
======================================
Claude Code Marketplace Validation
======================================

Validating marketplace.json...
✓ marketplace.json is valid JSON
✓ marketplace.json has 'name' field
✓ marketplace.json has 'owner' field
✓ marketplace.json has 'plugins' field

Validating plugins...

--- Plugin: github ---
✓ plugin.json is valid JSON
✓ Commands count matches: 1 files = 1 in JSON
✓ Plugin has README.md
✓ Plugin has 'components' object

======================================
Validation Summary
======================================
Errors:   0
Warnings: 0

Validation PASSED
```

### 2. Marketplace Tests (`tests/test_marketplace.sh`)

**Purpose:** Comprehensive testing of marketplace.json structure

**What it tests:**
- ✓ File existence
- ✓ JSON validity
- ✓ Required fields (name, owner, plugins)
- ✓ Owner metadata (name, url)
- ✓ Plugins array structure
- ✓ Each plugin entry structure
- ✓ Source directory existence
- ✓ Plugin.json existence in source

**Test count:** ~16 tests

**Usage:**
```bash
./tests/test_marketplace.sh
```

### 3. Plugin Tests (`tests/test_plugins.sh`)

**Purpose:** Comprehensive testing of plugin structure and components

**What it tests:**
- ✓ Plugin directory structure
- ✓ plugin.json existence and validity
- ✓ Required metadata fields
- ✓ Author information
- ✓ Keywords array
- ✓ Component counts (agents, commands, hooks, skills)
- ✓ Components object existence
- ✓ Command file validity (non-empty markdown)

**Test count:** ~12 tests per plugin

**Usage:**
```bash
./tests/test_plugins.sh
```

### 4. Full Test Suite (`tests/run_all_tests.sh`)

**Purpose:** Run all test suites in sequence

**What it does:**
1. Runs marketplace structure tests
2. Runs plugin structure tests
3. Reports final results
4. Provides actionable feedback

**Usage:**
```bash
./tests/run_all_tests.sh
```

**Example output:**
```
======================================
Running All Test Suites
======================================

[1/2] Running marketplace structure tests...
...
ALL TESTS PASSED

[2/2] Running plugin structure tests...
...
ALL TESTS PASSED

======================================
Final Test Results
======================================
ALL TEST SUITES PASSED ✓

Your marketplace is ready for:
  - Local testing
  - Git commit
  - Distribution
```

## Prerequisites

All test scripts require:

- **bash** - Shell environment
- **jq** - JSON processor (install: `apt-get install jq` or `brew install jq`)

## Integration with Development Workflow

### Pre-commit Validation

Run quick validation before every commit:

```bash
# Add to your workflow
./scripts/validate.sh && git commit -m "your message"
```

### Pre-push Validation

Run full test suite before pushing:

```bash
# Add to your workflow
./tests/run_all_tests.sh && git push
```

### Git Hooks (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
./scripts/validate.sh
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/validate.yml`:

```yaml
name: Validate Marketplace

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install jq
        run: sudo apt-get install -y jq
      - name: Run validation
        run: ./scripts/validate.sh
      - name: Run full test suite
        run: ./tests/run_all_tests.sh
```

## Test Coverage

### Marketplace.json Tests

| Test | Description | Type |
|------|-------------|------|
| File exists | Validates file presence | Structural |
| Valid JSON | Validates JSON syntax | Syntax |
| Required fields | Validates name, owner, plugins | Semantic |
| Owner metadata | Validates owner.name, owner.url | Semantic |
| Plugins array | Validates plugins is array and not empty | Structural |
| Plugin entries | Validates each plugin has required fields | Semantic |
| Source paths | Validates source directories exist | Structural |

### Plugin.json Tests

| Test | Description | Type |
|------|-------------|------|
| Directory structure | Validates .claude-plugin directory | Structural |
| File exists | Validates plugin.json presence | Structural |
| Valid JSON | Validates JSON syntax | Syntax |
| Metadata fields | Validates name, version, description | Semantic |
| Author info | Validates author.name | Semantic |
| Keywords | Validates keywords array | Semantic |
| Component counts | Validates counts match actual files | Integrity |
| Components object | Validates presence when components exist | Structural |
| File content | Validates component files are not empty | Content |

## Troubleshooting

### Common Errors

**Error: jq is not installed**
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# Fedora
sudo dnf install jq
```

**Error: Component count mismatch**
```
Agents count mismatch: 2 files ≠ 3 in JSON
```

**Solution:**
1. Count actual files: `ls plugins/{plugin_name}/agents/*.md | wc -l`
2. Update plugin.json `components.agents` to match
3. Run validation again

**Error: marketplace.json invalid JSON**

**Solution:**
```bash
# Use jq to find the error
cat .claude-plugin/marketplace.json | jq .

# Common issues:
# - Missing comma
# - Trailing comma
# - Unquoted strings
# - Unclosed brackets
```

### Validation Failures

If validation fails:

1. **Read the error message** - It tells you exactly what's wrong
2. **Check the file** - Open the file mentioned in the error
3. **Fix the issue** - Address the specific problem
4. **Re-run validation** - Confirm the fix works

## Adding New Tests

### Adding a Test to Existing Suite

Edit the appropriate test file and add a new `run_test` call:

```bash
run_test "your test name" "your test command"
```

Example:
```bash
run_test "plugin has LICENSE file" "test -f $PLUGIN_DIR/LICENSE"
```

### Creating a New Test Suite

1. Create new test file in `tests/` directory
2. Use the template from existing test files
3. Add to `run_all_tests.sh`
4. Make executable: `chmod +x tests/your_test.sh`

## Best Practices

1. **Run validation frequently** - Catch errors early
2. **Run full suite before commits** - Ensure nothing breaks
3. **Add tests for new features** - Maintain coverage
4. **Keep tests fast** - Quick feedback is better
5. **Document test failures** - Help others troubleshoot

## Version History

- **v1.0.0** (2025-11-04) - Initial test suite
  - Quick validation script
  - Marketplace structure tests
  - Plugin structure tests
  - Component count validation
  - Full test suite runner

## Contributing

When adding new components or features:

1. Add corresponding validation logic
2. Add tests to appropriate test suite
3. Update this documentation
4. Verify all tests pass

## Support

For issues or questions:
- Check troubleshooting section above
- Review error messages carefully
- Ensure jq is installed
- Verify file permissions (scripts must be executable)

## License

MIT
