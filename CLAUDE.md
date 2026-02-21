# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

Skiller is an **agent skill** for continuous learning — it enables AI coding agents to autonomously extract and preserve learned knowledge into reusable skills. It is not an application codebase but rather a skill definition with documentation.

Skiller works with any agent that supports the Agent Skills standard, including Claude Code, GitHub Copilot, Cursor, and others.

## Key Files

- `SKILL.md` — The main skill definition (YAML frontmatter + instructions). This is what agents load.
- `resources/skill-template.md` — Template for creating new skills

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
- **Project-level (recommended)**: `.claude/skills/[skill-name]/SKILL.md`
- **User-level**: `~/.claude/skills/[skill-name]/SKILL.md`

## How Skills Load in Claude Code

Claude Code uses progressive loading:
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

The approach is based on academic work on skill libraries for AI agents — Voyager (skill libraries), CASCADE (meta-skills), SEAgent (experiential learning), and Reflexion (self-reflection).
