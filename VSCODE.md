# VSCODE.md

This file provides guidance for using Skiller with GitHub Copilot in Visual Studio Code.

## Project Overview

Skiller is an **agent skill** for continuous learning — it enables AI coding agents to autonomously extract and preserve learned knowledge into reusable skills. It is not an application codebase but rather a skill definition with documentation and examples.

## Key Files

- `SKILL.md` — The main skill definition (YAML frontmatter + instructions). This is what agents load.
- `.github/agents/skiller.agent.md` — Custom Copilot agent for skill extraction
- `.github/prompts/skiller.prompt.md` — Prompt file for `/skiller` command in Copilot Chat
- `.github/copilot-instructions.md` — Repository-level custom instructions
- `resources/skill-template.md` — Template for creating new skills

## VS Code Integration

### Custom Agent (`@skiller`)

Copilot detects `.agent.md` files in `.github/agents/` automatically. Type `@skiller` in Copilot Chat to invoke the Skiller agent for skill extraction.

### Prompt File (`/skiller`)

Copilot detects `.prompt.md` files in `.github/prompts/` automatically. Type `/skiller` in Copilot Chat to trigger a session retrospective.

### Agent Skills (Automatic)

Skills in `.github/skills/` are discovered automatically by Copilot's progressive loading system. When your current context matches a skill's description, Copilot loads it.

### Custom Instructions

The `.github/copilot-instructions.md` file provides repository-level instructions that Copilot applies to all interactions in this workspace.

## How Skills Load in VS Code

Copilot uses three-level progressive loading:

1. **Discovery**: Name + description loaded at startup (~100 tokens per skill)
2. **Activation**: Full SKILL.md loaded when request matches description
3. **Execution**: Supporting files loaded only as needed

## Skill File Format

Skills use YAML frontmatter followed by markdown:

```yaml
---
name: kebab-case-name
description: |
  Must be precise for semantic matching. Include:
  (1) exact use cases, (2) trigger conditions like error messages,
  (3) what problem this solves
author: Skiller
version: 1.0.0
date: YYYY-MM-DD
---
```

The `description` field is critical — it determines when the skill surfaces during semantic matching.

## Installation Paths

- **Project-level (recommended)**: `.github/skills/[skill-name]/SKILL.md`
- **User-level**: `~/.copilot/skills/[skill-name]/SKILL.md`

The `.github/skills/` path is the cross-agent standard and is recommended for maximum compatibility.

## Quality Criteria for Skills

When modifying or creating skills, ensure:
- **Reusable**: Helps with future tasks, not just one instance
- **Non-trivial**: Requires discovery, not just documentation lookup
- **Specific**: Clear trigger conditions (exact error messages, symptoms)
- **Verified**: Solution has actually been tested and works

## References

- [Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
