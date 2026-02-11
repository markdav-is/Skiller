#!/bin/bash

# Skiller Auto-Activation Hook
# This hook ensures the skiller skill evaluates every interaction
# for extractable knowledge worth preserving.
#
# Works with Claude Code's hook system.
# For GitHub Copilot, use the custom agent (.github/agents/skiller.agent.md)
# or the prompt file (.github/prompts/skiller.prompt.md) instead.
#
# Installation (Claude Code):
#   1. Copy this script to ~/.claude/hooks/
#   2. Make it executable: chmod +x ~/.claude/hooks/skiller-activator.sh
#   3. Add to ~/.claude/settings.json (see README for details)

cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MANDATORY SKILL EVALUATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CRITICAL: After completing this user request, you MUST evaluate whether
it produced extractable knowledge using the skiller skill.

EVALUATION PROTOCOL (NON-NEGOTIABLE):

1. COMPLETE the user's request first
2. EVALUATE: Ask yourself:
   - Did this require non-obvious investigation or debugging?
   - Was the solution something that would help in future similar situations?
   - Did I discover something not immediately obvious from documentation?

3. IF YES to any question above:
   ACTIVATE: Use Skill(skiller) NOW to extract the knowledge

4. IF NO to all questions:
   SKIP: No skill extraction needed

This is NOT optional. Failing to evaluate means valuable knowledge is lost.
The skiller skill will decide whether to actually create a new skill based
on its quality criteria.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
