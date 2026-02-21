# Skiller

AI coding agents are good at solving problems—but bad at remembering them. You spend time debugging an obscure issue. The agent eventually figures it out. The session ends. When the same issue shows up later, the agent has no memory of the solution, and you start over from scratch. This leads to repeated explanations, duplicated effort, and wasted time.

## Solution

Skiller adds persistent memory to AI coding agents. When an agent uncovers something non-obvious—such as a debugging technique, workaround, or project-specific pattern—Skiller saves it as a reusable skill. That skill is automatically loaded the next time a similar situation appears. No re-explaining. No rediscovering the same fix.

How It Works
•	Detects valuable, hard-won knowledge during problem-solving
•	Stores that knowledge as a named skill
•	Automatically applies relevant skills in future sessions

Each solved problem makes the agent better prepared for the next one.

Why It Matters
•	Builds institutional memory over time
•	Reduces repeated debugging and context-setting
•	Helps teams share solutions implicitly, not manually

Think of it as a checklist that writes itself—so your future self (and your teammates) don’t have to relearn lessons you already paid for.

Works with **Claude Code**, **GitHub Copilot**, **Cursor**, and other agents that support the [Agent Skills standard](https://code.visualstudio.com/docs/copilot/customization/agent-skills).

> Fork of [Claudeception](https://github.com/blader/Claudeception), extended for cross-agent compatibility.

## Installation

### GitHub Copilot

Copilot supports Skiller through three integration points: agent skills (automatic), a custom agent (`@skiller`), and a prompt file (`/skiller`).

#### Step 1: Add Skiller to your project

**macOS / Linux:**
```bash
mkdir -p .github/skills/skiller .github/agents .github/prompts
curl -sL https://raw.githubusercontent.com/markdav-is/Skiller/main/SKILL.md -o .github/skills/skiller/SKILL.md
curl -sL https://raw.githubusercontent.com/markdav-is/Skiller/main/.github/agents/skiller.agent.md -o .github/agents/skiller.agent.md
curl -sL https://raw.githubusercontent.com/markdav-is/Skiller/main/.github/prompts/skiller.prompt.md -o .github/prompts/skiller.prompt.md
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path .github\skills\skiller, .github\agents, .github\prompts
Invoke-WebRequest https://raw.githubusercontent.com/markdav-is/Skiller/main/SKILL.md -OutFile .github\skills\skiller\SKILL.md
Invoke-WebRequest https://raw.githubusercontent.com/markdav-is/Skiller/main/.github/agents/skiller.agent.md -OutFile .github\agents\skiller.agent.md
Invoke-WebRequest https://raw.githubusercontent.com/markdav-is/Skiller/main/.github/prompts/skiller.prompt.md -OutFile .github\prompts\skiller.prompt.md
```

#### Step 2: Use it

- **Automatic**: Copilot's agent mode loads the skill when context matches (after debugging, error resolution, etc.)
- **Custom agent**: Type `@skiller` in Copilot Chat to invoke the Skiller agent
- **Prompt command**: Type `/skiller` in Copilot Chat to trigger a session retrospective
- **Manual**: Say "save this as a skill" or "what did we learn?" in any chat

### Cursor / Other Agents

Agents that support the Agent Skills standard can use Skiller by adding the skill file:

```bash
mkdir -p .github/skills/skiller
curl -sL https://raw.githubusercontent.com/markdav-is/Skiller/main/SKILL.md -o .github/skills/skiller/SKILL.md
```

The `.github/skills/` path is recognized by GitHub Copilot, Cursor, and other compatible agents.

## Usage

### Automatic Mode

The skill activates automatically when the agent:
- Just completed debugging and discovered a non-obvious solution
- Found a workaround through investigation or trial-and-error
- Resolved an error where the root cause wasn't immediately apparent
- Learned project-specific patterns or configurations through investigation
- Completed any task where the solution required meaningful discovery

### Explicit Mode

Trigger a learning retrospective:

```
/skiller
```
or
```
@skiller review this session
```

Or explicitly request skill extraction in any agent:

```
Save what we just learned as a skill
```

### What Gets Extracted

Not every task produces a skill. It only extracts knowledge that required actual discovery (not just reading docs), will help with future tasks, has clear trigger conditions, and has been verified to work.

## Where Skills Are Saved

Extracted skills go to `.github/skills/[skill-name]/SKILL.md` by default — the cross-agent standard path.

| Path | Scope | Agents |
|------|-------|--------|
| `.github/skills/` | Project | All (standard path) |
| `~/.copilot/skills/` | User | Copilot |

## How It Works

Modern AI coding agents have a native skills system. At startup, they load skill names and descriptions (about 100 tokens each). When you're working, the agent matches your current context against those descriptions and pulls in relevant skills.

But this retrieval system can be written to, not just read from. So when Skiller notices extractable knowledge, it writes a new skill with a description optimized for future retrieval.

The description matters a lot. "Helps with database problems" won't match anything useful. "Fix for PrismaClientKnownRequestError in serverless" will match when someone hits that error.

### Progressive Loading

Agents use three-level progressive loading to keep things efficient:

1. **Discovery**: Name + description only (~100 tokens per skill) — loaded at startup
2. **Activation**: Full SKILL.md instructions — loaded when context matches
3. **Execution**: Supporting files (scripts, templates) — loaded only as needed

This means you can have dozens of skills installed without overwhelming the context window.

More on the skills architecture from [Anthropic](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) and [VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills).

## Skill Format

Extracted skills are markdown files with YAML frontmatter:

```yaml
---
name: prisma-connection-pool-exhaustion
description: |
  Fix for PrismaClientKnownRequestError: Too many database connections
  in serverless environments (Vercel, AWS Lambda). Use when connection
  count errors appear after ~5 concurrent requests.
author: Skiller
version: 1.0.0
date: 2024-01-15
---

# Prisma Connection Pool Exhaustion

## Problem
[What this skill solves]

## Context / Trigger Conditions
[Exact error messages, symptoms, scenarios]

## Solution
[Step-by-step fix]

## Verification
[How to confirm it worked]
```

See `resources/skill-template.md` for the full template.

## Quality Gates

The skill is picky about what it extracts. If something is just a documentation lookup, or only useful for this one case, or hasn't actually been tested, it won't create a skill. Would this actually help someone who hits this problem in six months? If not, no skill.

## Research

The idea comes from academic work on skill libraries for AI agents.

[Voyager](https://arxiv.org/abs/2305.16291) (Wang et al., 2023) showed that game-playing agents can build up libraries of reusable skills over time, and that this helps them avoid re-learning things they already figured out. [CASCADE](https://arxiv.org/abs/2512.23880) (2024) introduced "meta-skills" (skills for acquiring skills), which is what this is. [SEAgent](https://arxiv.org/abs/2508.04700) (2025) showed agents can learn new software environments through trial and error, which inspired the retrospective feature. [Reflexion](https://arxiv.org/abs/2303.11366) (Shinn et al., 2023) showed that self-reflection helps.

Agents that persist what they learn do better than agents that start fresh.

## Project Structure

```
SKILL.md                              # Main skill definition (all agents)
.github/
  agents/skiller.agent.md             # Copilot custom agent
  prompts/skiller.prompt.md           # Copilot prompt file (/skiller)
  copilot-instructions.md             # Copilot repo instructions
resources/
  skill-template.md                   # Template for new skills
COPILOT.md
VSCODE.md                             # VS Code guidance
VISUAL-STUDIO.md                      # Visual Studio guidance
```

## Contributing

Contributions welcome. Fork, make changes, submit a PR.

## License

MIT
