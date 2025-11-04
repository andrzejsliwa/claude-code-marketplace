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

1. **Add component files** to the appropriate directories:
   - Commands: `plugins/{plugin_name}/commands/`
   - Agents: `plugins/{plugin_name}/agents/`
   - Hooks: `plugins/{plugin_name}/hooks/` (or hooks.json)
   - Skills: `plugins/{plugin_name}/skills/`

2. **Update plugin.json** (only if needed):
   - If using **default directories**, no changes needed - components are auto-discovered
   - If using **custom paths**, update the path fields (`commands`, `agents`, `hooks`)

3. **Update plugin README** at `plugins/{plugin_name}/README.md`:
   - List all available commands, agents, hooks, and skills
   - Add usage examples for new features
   - Update version if making significant changes

4. **Update marketplace.json** (rarely needed):
   - Only update if changing plugin description, version, or tags

5. **Test the changes:**
   ```bash
   # Reinstall plugin locally
   claude /plugin uninstall {plugin_name}
   claude /plugin install {plugin_name}

   # Test commands
   claude /your-command
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
  "keywords": ["ai-powered", "git", "github"]
}
```

**With custom component paths:**
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
  "commands": ["./custom/commands/cmd1.md", "./custom/commands/cmd2.md"],
  "agents": "./custom/agents/",
  "hooks": "./custom/hooks.json"
}
```

**Important Notes:**
- When using default directory structure (`commands/`, `agents/`, `hooks/`, `skills/` at plugin root), omit the path fields
- Custom paths must be relative and start with `./`
- Custom paths **supplement** default directories, they don't replace them
- `commands` and `agents` accept string or array of file/directory paths
- `hooks` points to a hooks.json file or can be inlined as an object
- Skills are discovered automatically from the `skills/` directory (no field needed)

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

# List available components
ls plugins/github/agents/*.md 2>/dev/null || echo "No agents"
ls plugins/github/commands/*.md 2>/dev/null || echo "No commands"
ls plugins/github/hooks/*.md 2>/dev/null || echo "No hooks"
ls plugins/github/skills/*.md 2>/dev/null || echo "No skills"
```

## Common Tasks

### Adding a New Agent

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/agents`
2. Create `plugins/{plugin_name}/agents/new-agent.md`
3. Update README.md to list the new agent
4. Test locally:
   ```bash
   claude /plugin uninstall {plugin_name}
   claude /plugin install {plugin_name}
   claude agent new-agent "test prompt"
   ```

### Adding a New Command

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/commands`
2. Create `plugins/{plugin_name}/commands/new-command.md`
3. Update README.md to list the new command
4. Test locally:
   ```bash
   claude /plugin uninstall {plugin_name}
   claude /plugin install {plugin_name}
   claude /new-command
   ```

### Adding a New Hook

1. Create `plugins/{plugin_name}/hooks.json` or add to existing hooks config
2. Define hook configuration (see [hooks documentation](https://docs.claude.com/en/docs/claude-code/plugins-reference))
3. Update README.md to document the new hook
4. Test by triggering the hook event:
   ```bash
   claude /plugin uninstall {plugin_name}
   claude /plugin install {plugin_name}
   # Trigger the event that activates the hook
   ```

### Adding a New Skill

1. Create directory if it doesn't exist: `mkdir -p plugins/{plugin_name}/skills`
2. Create `plugins/{plugin_name}/skills/new-skill.md`
3. Update README.md to list the new skill
4. Test locally:
   ```bash
   claude /plugin uninstall {plugin_name}
   claude /plugin install {plugin_name}
   # Invoke the skill according to its documentation
   ```

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

### 2025-11-04: Fixed plugin.json to match official Claude Code specification

The plugin.json structure contained custom fields (`components` object and categorized `commands`/`agents`/`hooks` objects) that aren't part of the official Claude Code specification, preventing plugins from loading. Fixed by:

- Removed `components` object - Not recognized by Claude Code
- Removed categorization objects like `{"commands": {"workflow": [...]}}`  - Commands/agents should be file paths, not objects
- When using default directory structure (`commands/`, `agents/`, etc.), omit path fields entirely - components are auto-discovered
- Custom paths must be relative strings/arrays (e.g., `"commands": ["./custom/cmd.md"]`)

**Learning:** Always validate against the official specification, not assumptions. The `components` field was a custom tracking mechanism that had no meaning to Claude Code. When in doubt, consult the official docs at https://docs.claude.com/en/docs/claude-code/plugins-reference and test locally with `claude /plugin install`.
