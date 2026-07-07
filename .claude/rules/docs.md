---
paths:
  - "*.md"
  - "docs/**/*.md"
  - "AGENTS.md"
  - "CLAUDE.md"
---

# Documentation Rules

- Keep project instructions concise and operational.
- Put stable agent facts in `docs/agents/memory.md`.
- Avoid storing secrets, account-specific credentials, or local-only settings.
- Prefer ASCII diagrams and trees so Windows terminals and agents read them
  consistently.
- Update `README.md` when setup commands, architecture, or workflows change.
