# Skiller

Every time you use an AI coding agent, it starts from zero. You spend an hour debugging some obscure error, the agent figures it out, session ends. Next time you hit the same issue? Another hour.

Skiller fixes that. When your agent discovers something non-obvious (a debugging technique, a workaround, some project-specific pattern), it saves that knowledge as a new skill. Next time a similar problem comes up, the skill gets loaded automatically.

Works with **Claude Code**, **GitHub Copilot**, **Cursor**, and other agents that support the [Agent Skills standard](https://code.visualstudio.com/docs/copilot/customization/agent-skills).

> Fork of [Claudeception](https://github.com/blader/Claudeception), extended for cross-agent compatibility.

## Installation

### GitHub Copilot

Copilot supports Skiller through three integration points: agent skills (automatic), a custom agent (`@skiller`), and a prompt file (`/skiller`).

#### Step 1: Clone into your project

```bash
git clone https://github.com/markdav-is/Skiller.git /tmp/skiller-install

# Copy the Copilot integration files
mkdir -p .github/skills/skiller .github/agents .github/prompts
cp /tmp/skiller-install/SKILL.md .github/skills/skiller/SKILL.md
cp /tmp/skiller-install/.github/agents/skiller.agent.md .github/agents/
cp /tmp/skiller-install/.github/prompts/skiller.prompt.md .github/prompts/

# Optional: copy repo-level instructions
cp /tmp/skiller-install/.github/copilot-instructions.md .github/copilot-instructions.md

rm -rf /tmp/skiller-install
```

Or clone the entire repo as a skill directory:

```bash
git clone https://github.com/markdav-is/Skiller.git .github/skills/skiller
```

#### Step 2: Use it

- **Automatic**: Copilot's agent mode loads the skill when context matches (after debugging, error resolution, etc.)
- **Custom agent**: Type `@skiller` in Copilot Chat to invoke the Skiller agent
- **Prompt command**: Type `/skiller` in Copilot Chat to trigger a session retrospective
- **Manual**: Say "save this as a skill" or "what did we learn?" in any chat

### Claude Code

#### Step 1: Clone the skill

**User-level (recommended)**

```bash
git clone https://github.com/markdav-is/Skiller.git ~/.claude/skills/skiller
```

**Project-level**

```bash
git clone https://github.com/markdav-is/Skiller.git .claude/skills/skiller
```

#### Step 2: Set up the activation hook (recommended)

The skill can activate via semantic matching, but a hook ensures it evaluates every session for extractable knowledge.

##### User-level setup (recommended)

1. Create the hooks directory and copy the script:

```bash
mkdir -p ~/.claude/hooks
cp ~/.claude/skills/skiller/scripts/skiller-activator.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/skiller-activator.sh
```

2. Add the hook to your global Claude settings (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/skiller-activator.sh"
          }
        ]
      }
    ]
  }
}
```

##### Project-level setup

1. Create the hooks directory inside your project and copy the script:

```bash
mkdir -p .claude/hooks
cp .claude/skills/skiller/scripts/skiller-activator.sh .claude/hooks/
chmod +x .claude/hooks/skiller-activator.sh
```

2. Add the hook to your project settings (`.claude/settings.json` in the repo):

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/skiller-activator.sh"
          }
        ]
      }
    ]
  }
}
```

If you already have a `settings.json`, merge the `hooks` configuration into it.

The hook injects a reminder on every prompt that tells the agent to evaluate whether the current task produced extractable knowledge.

### Cursor / Other Agents

Agents that support the Agent Skills standard can use Skiller by cloning it into the standard skills directory:

```bash
git clone https://github.com/markdav-is/Skiller.git .github/skills/skiller
```

The `.github/skills/` path is recognized by Claude Code, GitHub Copilot, Cursor, OpenCode, and others.

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

**Claude Code:**
```
/skiller
```

**GitHub Copilot:**
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
| `.claude/skills/` | Project | Claude Code, Copilot (legacy) |
| `~/.claude/skills/` | User | Claude Code |
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

## Examples

See `examples/` for sample skills:

- `nextjs-server-side-error-debugging/`: errors that don't show in browser console
- `prisma-connection-pool-exhaustion/`: the "too many connections" serverless problem
- `typescript-circular-dependency/`: detecting and fixing import cycles

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
scripts/
  skiller-activator.sh                # Claude Code activation hook
  claudeception-activator.sh          # Legacy activation hook
resources/
  skill-template.md                   # Template for new skills
  research-references.md              # Academic research
examples/                             # Sample extracted skills
COPILOT.md                            # Copilot-specific guidance
WARP.md                               # WARP.dev guidance
```

## Contributing

Contributions welcome. Fork, make changes, submit a PR.

## License

MIT
