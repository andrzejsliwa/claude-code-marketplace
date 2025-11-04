# GitHub Plugin

AI-powered GitHub workflow automation for Claude Code.

## Overview

The GitHub plugin streamlines common GitHub workflows by providing intelligent commands that handle branch management, commits, and pull request creation with smart defaults and interactive guidance.

## Components

- **Commands:** 1
- **Agents:** 0
- **Hooks:** 0
- **Skills:** 0

## Installation

### From Marketplace

```bash
# Add the marketplace
claude /plugin marketplace add ~/claude-code-marketplace

# Install the plugin
claude /plugin install github

# Verify installation
claude /plugin list
```

### Manual Installation

Copy the plugin directory to your Claude Code plugins folder:

```bash
cp -r plugins/github ~/.claude/plugins/
```

## Commands

### `/open-pr` - Open Pull Request

Intelligently creates a pull request with comprehensive workflow management.

**Usage:**
```bash
# Standard PR
/open-pr

# Draft PR
/open-pr draft
```

**Features:**

- **Smart Branch Detection:** Automatically detects if you're on main/master and helps create a feature branch
- **Change Analysis:** Reviews all staged and unstaged changes to understand the scope of work
- **Intelligent Commits:**
  - Detects multiple distinct tasks from conversation context
  - Offers single or multi-commit strategies
  - Separates Claude's changes from manual changes
- **PR Creation:**
  - Generates descriptive PR titles and summaries
  - Includes comprehensive test plans
  - Links related issues automatically
  - Supports draft PRs

**Workflow Steps:**

1. **Branch Check:** Ensures you're not committing directly to main/master
2. **Change Analysis:** Examines git status and diff to understand modifications
3. **Commit Strategy:** Asks whether to create single or multiple commits for complex changes
4. **Commit Creation:** Generates semantic commit messages following best practices
5. **PR Generation:** Creates pull request with detailed description and test plan

**Example:**

```bash
# After making changes to your codebase
claude /open-pr

# Claude will:
# 1. Check your current branch (create new if on main)
# 2. Analyze all changes made in the session
# 3. Ask about commit strategy if needed
# 4. Create commits with descriptive messages
# 5. Push to remote
# 6. Open PR with comprehensive description
```

## Configuration

No additional configuration required. The plugin uses standard git and GitHub CLI (`gh`) commands.

**Requirements:**
- Git installed and configured
- GitHub CLI (`gh`) authenticated
- Active git repository

## Use Cases

- **Feature Development:** Create PRs for new features with proper branching
- **Bug Fixes:** Quick PR creation for bug fixes with context-aware commits
- **Refactoring:** Manage refactoring changes with logical commit grouping
- **Documentation:** Create PRs for documentation updates

## Best Practices

1. **Use descriptive branch names:** Let Claude auto-generate from changes or provide clear custom names
2. **Review before pushing:** The command shows you what will be committed
3. **Separate concerns:** Use multi-commit strategy for complex changes touching multiple features
4. **Draft PRs:** Use `draft` parameter for work-in-progress changes

## Contributing

To add new commands to this plugin:

1. Create new command file in `commands/`
2. Update `plugin.json`:
   - Increment `components.commands`
   - Add command to `commands.workflow` array
3. Update this README
4. Test with `claude /your-command`

## License

MIT

## Author

Andrzej Sliwa
- GitHub: [@andrzejsliwa](https://github.com/andrzejsliwa)
- Email: andrzej.sliwa@gmail.com

## Version

1.0.0

## Links

- [Claude Code Plugin Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [GitHub CLI Documentation](https://cli.github.com/)
- [Marketplace Repository](https://github.com/andrzejsliwa/claude_code_marketplace)
