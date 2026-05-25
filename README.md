# Agentic Programming Project Template

This repository is a stack-agnostic starting point for personal software projects that use Codex instructions, local skills, and OpenSpec-driven change planning.

## Included Foundation

- `AGENTS.md`: project-initialization and agent-operating template.
- `.codex/skills/personal-project-structure/`: rules for choosing where project artifacts belong.
- `README.template.md`: starter README for a derived project.
- `.env.example`: sanitized configuration placeholder.
- `.gitignore`: baseline exclusions for secrets, local artifacts, dependencies, and build output, including disposable `tmp/`.

The template intentionally does not select a programming language, application framework, package manager, database, or deployment target.

## Starting a New Project

1. Create the new repository from this template.
2. Use `/init` to establish repository instructions and project context.
3. Complete every double-braced field in `AGENTS.md`, or explicitly replace non-applicable fields with `Not applicable`.
4. Replace this template-oriented `README.md` with content based on `README.template.md`, filled for the new project.
5. Update `.env.example` with required sanitized configuration variables.
6. Initialize OpenSpec for the derived project:

   ```bash
   openspec init
   ```

7. Record project-specific skills and authoritative external documentation sources in `AGENTS.md`.
8. Create implementation folders only after project structure and technical decisions are documented.
9. Complete the `/init` completion checklist in `AGENTS.md` before substantive implementation work.

## Working Rules

- Use `$personal-project-structure` before creating, moving, or reviewing project artifacts.
- Store change planning, requirements, designs, proposals, and tasks in `openspec/`.
- Store durable developer documentation in `docs/dev/` and third-party reference notes in `docs/external/`.
- Store authoritative internal schemas, APIs, message formats, topics, events, and examples in `contracts/`.
- Store disposable local downloads, debug dumps, generated previews, and scratch exports in ignored `tmp/`; never keep required project state there.
- Do not commit secrets or replace sanitized examples with live credentials.

## Template Maintenance

This repository should contain reusable guidance rather than stack- or client-specific architecture. When adding general conventions, keep `AGENTS.md`, `README.template.md`, and the `personal-project-structure` skill consistent.
