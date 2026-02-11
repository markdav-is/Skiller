# COPILOT.md

This file provides guidance to GitHub Copilot when working with code in this repository.

## Project Overview

Skiller is an **agent skill** for continuous learning — it enables AI coding agents to autonomously extract and preserve learned knowledge into reusable skills. It is not an application codebase but rather a skill definition with documentation and examples.

Skiller works with any agent that supports the Agent Skills standard, including GitHub Copilot, Claude Code, Cursor, and others.

## Key Files

- `SKILL.md` — The main skill definition (YAML frontmatter + instructions). This is what agents load.
- `.github/agents/skiller.agent.md` — Custom Copilot agent for skill extraction
- `.github/prompts/skiller.prompt.md` — Prompt file for `/skiller` command in Copilot Chat
- `resources/skill-template.md` — Template for creating new skills
- `examples/` — Sample extracted skills demonstrating proper format

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

Skills should be saved to:
- **Project-level (recommended)**: `.github/skills/[skill-name]/SKILL.md`
- **Claude Code project**: `.claude/skills/[skill-name]/SKILL.md`
- **User-level (Claude Code)**: `~/.claude/skills/[skill-name]/SKILL.md`
- **User-level (Copilot)**: `~/.copilot/skills/[skill-name]/SKILL.md`

The `.github/skills/` path is the cross-agent standard and is recommended for maximum compatibility.

## GitHub Copilot Integration

### Agent Mode

Skiller integrates with Copilot's agent mode through:
1. **Custom Agent**: `.github/agents/skiller.agent.md` — Invoke via `@skiller` in Copilot Chat
2. **Prompt File**: `.github/prompts/skiller.prompt.md` — Invoke via `/skiller` command
3. **Agent Skills**: Skills in `.github/skills/` are automatically discovered by Copilot's progressive loading system

### How Skills Load in Copilot

Copilot uses three-level progressive loading:
1. **Discovery**: Name + description loaded at startup (~100 tokens per skill)
2. **Activation**: Full SKILL.md loaded when request matches description
3. **Execution**: Supporting files loaded only as needed

## Quality Criteria for Skills

When modifying or creating skills, ensure:
- **Reusable**: Helps with future tasks, not just one instance
- **Non-trivial**: Requires discovery, not just documentation lookup
- **Specific**: Clear trigger conditions (exact error messages, symptoms)
- **Verified**: Solution has actually been tested and works

## Research Foundation

The approach is based on academic work on skill libraries (Voyager, CASCADE, SEAgent, Reflexion). See `resources/research-references.md` for details.
