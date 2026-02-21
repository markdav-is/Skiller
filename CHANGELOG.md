# Changelog

All notable changes to Skiller are documented in this file.

## [5.0.0] - 2025-02-20

### Added
- `VSCODE.md` — VS Code-specific guidance
- `VISUAL-STUDIO.md` — Visual Studio-specific guidance
- `CHANGELOG.md`

### Removed
- Claude Code hook scripts (`scripts/skiller-activator.sh`, `scripts/claudeception-activator.sh`)
- `scripts/` directory
- `WARP.md`
- `examples/` directory (inline example in SKILL.md covers the same ground)
- `resources/research-references.md` (unused, contained stale Claudeception branding)
- Claude Code paths (`.claude/skills/`, `~/.claude/skills/`, `~/.codex/skills/`)
- `allowed-tools` frontmatter from SKILL.md (Claude-specific)
- Claude Code installation section from README

### Changed
- Rebranded all remaining Claudeception/Claude Code references to Skiller/GitHub Copilot
- README now leads with VS Code Extension as the recommended installation method
- Project structure updated to reflect current file layout

## [4.0.0] - 2025-02-20

### Added
- GitHub Copilot custom agent (`.github/agents/skiller.agent.md`)
- GitHub Copilot prompt file (`.github/prompts/skiller.prompt.md`)
- Repository instructions (`.github/copilot-instructions.md`)
- `COPILOT.md` guidance file
- Cross-agent skill path (`.github/skills/`)
- Web research step in extraction process

### Changed
- Rebranded from Claudeception to Skiller
- Skill format updated with `date` field
- README rewritten for multi-agent installation

## [3.0.0] - 2024-12-01

### Added
- Activation hooks for Claude Code
- Step 1: Check for existing skills before creating
- Skill versioning guidelines

## [2.0.0] - 2024-11-01

### Added
- Retrospective mode
- Self-reflection prompts
- Quality gates checklist
- Example skills (Next.js, Prisma, TypeScript circular deps)

## [1.0.0] - 2024-10-01

- Initial release as Claudeception
- Core skill extraction logic
- Skill template
