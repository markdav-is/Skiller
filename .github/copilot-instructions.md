# Skiller — Repository Instructions

This repository contains **Skiller**, a continuous learning system for AI coding agents.
Skiller extracts reusable knowledge from work sessions and saves it as agent skills.

## What This Repository Is

Skiller is not an application — it is a skill definition with documentation and examples.
The core file is `SKILL.md`, which defines the skill extraction behavior. Supporting files
include a skill template, example skills, and integration configurations for multiple agents.

## Key Concepts

- **Agent Skills**: Markdown files with YAML frontmatter (`SKILL.md`) that teach agents
  new capabilities. Skills are progressively loaded — only the name and description are
  loaded at startup, with full content loaded when relevant.

- **Skill Extraction**: The process of identifying non-obvious knowledge from a work session
  and saving it as a structured, reusable skill file.

- **Cross-Agent Compatibility**: Skills saved in `.github/skills/` work across Claude Code,
  GitHub Copilot, Cursor, and other agents supporting the Agent Skills standard.

## File Structure

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill definition — the core of Skiller |
| `.github/agents/skiller.agent.md` | Copilot custom agent for skill extraction |
| `.github/prompts/skiller.prompt.md` | Copilot prompt file for `/skiller` command |
| `resources/skill-template.md` | Template for new skills |
| `examples/` | Sample extracted skills |
| `scripts/skiller-activator.sh` | Activation hook for Claude Code |

## Skill Format

When modifying or creating skills, use this structure:

```yaml
---
name: kebab-case-name
description: |
  Precise description for semantic matching. Include:
  (1) exact use cases, (2) trigger conditions, (3) what it solves
author: Skiller
version: 1.0.0
date: YYYY-MM-DD
---
```

The `description` field is critical — it determines when the skill surfaces during semantic matching.

## Installation Paths

Skills should be saved to `.github/skills/[skill-name]/SKILL.md` for cross-agent compatibility.
Legacy paths (`.claude/skills/`) are also supported.
