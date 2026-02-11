---
description: 'Review the current session for extractable knowledge and save reusable skills'
agent: 'agent'
tools: ['search/codebase', 'read', 'editFiles', 'runInTerminal', 'search/web']
argument-hint: 'Optionally describe the knowledge to extract'
---

# Skiller — Session Retrospective

Review this session for extractable knowledge worth preserving as reusable skills.

## Instructions

1. **Review the session**: Analyze the conversation history for non-obvious discoveries,
   debugging insights, workarounds, error resolutions, and project-specific patterns.

2. **Identify candidates**: List potential skills with brief justifications. Focus on
   knowledge that required actual investigation — not documentation lookups.

3. **Check existing skills**: Search `.github/skills/` and `~/.copilot/skills/` for
   related skills. Update existing ones if appropriate rather than creating duplicates.

4. **Extract top candidates**: For each candidate (typically 1-3 per session), create
   a skill file at `.github/skills/[skill-name]/SKILL.md` using this format:

   ```markdown
   ---
   name: [descriptive-kebab-case-name]
   description: |
     [Precise description with exact use cases, trigger conditions,
     and what problem this solves]
   author: Skiller
   version: 1.0.0
   date: [YYYY-MM-DD]
   ---

   # [Skill Name]

   ## Problem
   ## Context / Trigger Conditions
   ## Solution
   ## Verification
   ## Example
   ## Notes
   ## References
   ```

5. **Summarize**: Report what skills were created or updated and why.

## Quality Criteria

Only extract knowledge that is **reusable** (helps future tasks), **non-trivial**
(requires discovery), **specific** (clear triggers), and **verified** (actually tested).
