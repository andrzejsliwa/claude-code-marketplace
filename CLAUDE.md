# Personal Claude Code Plugin Marketplace

This repository is a Claude Code plugin marketplace that distributes the custom plugins to developers building with AI-powered tools.

## Repository Structure

```
claude-code-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog (lists available plugins)
├── .claude/
│   └── settings.local.json       # Local development settings
└── plugins/
    └── {plugin-name}/             # Example plugin structure
        ├── .claude-plugin/
        │   └── plugin.json        # Plugin metadata
        ├── agents/                # AI agents (optional)
        ├── commands/              # Slash commands (optional)
        ├── hooks/                 # Automated hooks (optional)
        ├── skills/                # Reusable skills (optional)
        └── README.md              # Plugin documentation (recommended)
```

**Current Plugins:**
```
plugins/github/                    # GitHub workflow plugin
├── .claude-plugin/plugin.json
└── commands/
    └── open-pr.md                # /open-pr command
```

## Philosophy: Compounding Engineering

**Each unit of engineering work should make subsequent units of work easier—not harder.**

When working on this repository, follow the compounding engineering process:

1. **Plan** → Understand the change needed and its impact
2. **Delegate** → Use AI tools to help with implementation
3. **Assess** → Verify changes work as expected
4. **Codify** → Update this CLAUDE.md with learnings

## Working with This Repository

### Adding a New Plugin

1. Create plugin directory: `plugins/new-plugin-name/`
2. Add plugin structure (include only what you need):
   ```
   plugins/new-plugin-name/
   ├── .claude-plugin/plugin.json    # Required
   ├── agents/                       # Optional: AI agents
   ├── commands/                     # Optional: slash commands
   ├── hooks/                        # Optional: automation hooks
   ├── skills/                       # Optional: reusable skills
   └── README.md                     # Recommended
   ```
3. Update `.claude-plugin/marketplace.json` to include the new plugin
4. Run validation: `./scripts/validate.sh`
5. Test locally before committing

### Updating an Existing Plugin

When agents, commands, hooks, or skills are added/removed:

1. **Scan for actual files:**

   ```bash
   # Count components (replace {plugin_name} with your plugin)
   ls plugins/{plugin_name}/agents/*.md 2>/dev/null | wc -l
   ls plugins/{plugin_name}/commands/*.md 2>/dev/null | wc -l
   ls plugins/{plugin_name}/hooks/*.md 2>/dev/null | wc -l
   ls plugins/{plugin_name}/skills/*.md 2>/dev/null | wc -l
   ```

2. **Update plugin.json** at `plugins/{plugin_name}/.claude-plugin/plugin.json`:

   - Update `components.agents` count (if agents exist)
   - Update `components.commands` count (if commands exist)
   - Update `components.hooks` count (if hooks exist)
   - Update `components.skills` count (if skills exist)
   - Update `agents` object to categorize and describe agents
   - Update `commands` object to categorize commands

3. **Update plugin README** at `plugins/{plugin_name}/README.md`:

   - Update component counts in the intro
   - Update the component lists to match what exists
   - Add usage examples for new features

4. **Update marketplace.json** at `.claude-plugin/marketplace.json`:
   - Usually doesn't need changes unless changing plugin description/tags

5. **Run validation** to ensure everything is correct:
   ```bash
   ./scripts/validate.sh
   ```

### Marketplace.json Structure

The marketplace.json follows the official Claude Code spec:

```json
{
  "name": "marketplace-identifier",
  "owner": {
    "name": "Owner Name",
    "url": "https://github.com/owner"
  },
  "metadata": {
    "description": "Marketplace description",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": { ... },
      "homepage": "https://...",
      "tags": ["tag1", "tag2"],
      "source": "./plugins/plugin-name"
    }
  ]
}
```

**Only include fields that are in the official spec.** Do not add custom fields like:

- `downloads`, `stars`, `rating` (display-only)
- `categories`, `featured_plugins`, `trending` (not in spec)
- `type`, `verified`, `featured` (not in spec)

### Plugin.json Structure

Each plugin has its own plugin.json with detailed metadata.

**Minimal example (current github plugin):**
```json
{
  "name": "github",
  "version": "1.0.0",
  "description": "AI-powered github tools",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "license": "MIT",
  "keywords": ["ai-powered", "git", "github"],
  "components": {
    "commands": 1
  },
  "commands": {
    "workflow": ["open-pr"]
  }
}
```

**Full example (with all component types):**
```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "components": {
    "agents": 5,
    "commands": 3,
    "hooks": 2,
    "skills": 4
  },
  "agents": {
    "development": [
      {
        "name": "agent-name",
        "description": "Agent description",
        "use_cases": ["use-case-1", "use-case-2"]
      }
    ]
  },
  "commands": {
    "workflow": ["command1", "command2"]
  },
  "hooks": {
    "automation": ["hook1", "hook2"]
  },
  "skills": {
    "utilities": ["skill1", "skill2"]
  }
}
```

**Important:** Only include component types that exist in your plugin. Don't add empty sections.

## Testing Changes

### Test Locally

1. Install the marketplace locally:

   ```bash
   claude /plugin marketplace add ~/claude-code-marketplace
   # Or use absolute path:
   claude /plugin marketplace add /home/username/claude-code-marketplace
   ```

2. Install the plugin:

   ```bash
   claude /plugin install github
   ```

3. Test components:
   ```bash
   # Test commands
   claude /open-pr

   # Test agents (if you have any)
   # claude agent agent-name "test prompt"

   # Hooks run automatically on events
   ```

4. Verify plugin installation:
   ```bash
   claude /plugin list
   ```

### Validate JSON and Structure

Before committing, ensure JSON files are valid and counts are accurate:

```bash
# Validate JSON syntax
cat .claude-plugin/marketplace.json | jq .
cat plugins/{plugin_name}/.claude-plugin/plugin.json | jq .

# Run full validation suite
./scripts/validate.sh

# Manual verification of component counts
ls plugins/github/agents/*.md 2>/dev/null | wc -l     # Should match components.agents
ls plugins/github/commands/*.md 2>/dev/null | wc -l   # Should match components.commands
ls plugins/github/hooks/*.md 2>/dev/null | wc -l      # Should match components.hooks
ls plugins/github/skills/*.md 2>/dev/null | wc -l     # Should match components.skills
```

## Common Tasks

### Adding a New Agent

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/agents`
2. Create `plugins/{plugin_name}/agents/new-agent.md`
3. Update plugin.json:
   - Increment `components.agents` count
   - Add to `agents` categorization object
4. Update README.md agent list
5. Run validation: `./scripts/validate.sh`
6. Test with `claude agent new-agent "test prompt"`

### Adding a New Command

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/commands`
2. Create `plugins/{plugin_name}/commands/new-command.md`
3. Update plugin.json:
   - Increment `components.commands` count
   - Add to `commands` categorization object
4. Update README.md command list
5. Run validation: `./scripts/validate.sh`
6. Test with `claude /new-command`

### Adding a New Hook

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/hooks`
2. Create `plugins/{plugin_name}/hooks/new-hook.md`
3. Update plugin.json:
   - Increment `components.hooks` count
   - Add to `hooks` categorization object
4. Update README.md hook list
5. Run validation: `./scripts/validate.sh`
6. Test by triggering the hook event

### Adding a New Skill

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/skills`
2. Create `plugins/{plugin_name}/skills/new-skill.md`
3. Update plugin.json:
   - Increment `components.skills` count
   - Add to `skills` categorization object
4. Update README.md skill list
5. Run validation: `./scripts/validate.sh`
6. Test with the skill invocation method

### Updating Tags/Keywords

Keep tags focused and relevant:

- Use: `ai-powered`, `git`, `github` (for github plugin)
- Avoid: Too many tags or overly generic tags
- Avoid: Framework-specific tags unless the plugin is framework-specific
- Keep marketplace and plugin keywords aligned

## Commit Conventions

Follow these patterns for commit messages:

- `Add [agent/command name]` - Adding new functionality
- `Remove [agent/command name]` - Removing functionality
- `Update [file] to [what changed]` - Updating existing files
- `Fix [issue]` - Bug fixes
- `Simplify [component] to [improvement]` - Refactoring

Include the Claude Code footer:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Resources to search for when needing more information

- [Claude Code Plugin Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [Plugin Marketplace Documentation](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Plugin Reference](https://docs.claude.com/en/docs/claude-code/plugins-reference)

## Key Learnings

_This section captures important learnings as we work on this repository._

### 2025-10-09: Simplified marketplace.json to match official spec

The initial marketplace.json included many custom fields (downloads, stars, rating, categories, trending) that aren't part of the Claude Code specification. We simplified to only include:

- Required: `name`, `owner`, `plugins`
- Optional: `metadata` (with description and version)
- Plugin entries: `name`, `description`, `version`, `author`, `homepage`, `tags`, `source`

**Learning:** Stick to the official spec. Custom fields may confuse users or break compatibility with future versions.

### 2025-11-04: Documentation must reflect reality AND possibilities

Updated CLAUDE.md to show the full directory structure (agents, commands, hooks, skills) while accurately documenting the current github plugin state. Key improvements:

- Show complete possible plugin structure (agents, commands, hooks, skills)
- Clearly label what's "current" vs "example"
- Added validation steps to catch discrepancies
- Created comprehensive test suite for structure validation
- Only include component types that actually exist in plugin.json

**Learning:** Documentation should educate users about what's possible while staying grounded in what's actual. Show the full capability but don't claim features that don't exist. Use validation scripts to prevent drift.
