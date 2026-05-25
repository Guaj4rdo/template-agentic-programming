# Agentic Programming Project Template

This repository is a stack-agnostic starting point for personal software projects that use Codex instructions, local skills, and OpenSpec-driven change planning.

## Included Foundation

- `AGENTS.md`: project-initialization and agent-operating template.
- `.codex/skills/personal-project-structure/`: rules for choosing where project artifacts belong.
- `README.template.md`: starter README for a derived project.
- `.env.example`: sanitized configuration placeholder.
- `.gitignore`: baseline exclusions for secrets, local artifacts, dependencies, and build output, including disposable `tmp/`.
- `scripts/init-project.sh`: dependency-free interactive bootstrap for a derived repository.

The template intentionally does not select a programming language, application framework, package manager, database, or deployment target.

## Starting a New Project

1. Create the new repository from this template.
2. Confirm that the new repository has its own remote and does not point back to this template:

   ```bash
   git remote -v
   ```

3. Run the initializer:

   ```bash
   ./scripts/init-project.sh
   ```

   The script creates the base folders, initializes OpenSpec for Codex, asks only for a mandatory initial project prompt plus the minimum project context needed to bootstrap the repository (`project name`, `general context`, `primary use cases`, and `technology stack`), and then calls Codex to complete `AGENTS.md`, `README.md`, and `.env.example`.

4. Review the generated files and complete the `/init` completion checklist in `AGENTS.md` before substantive implementation work.

The initializer refuses to run while `origin` still points at `template-agentic-programming`, preventing accidental initialization or overwrite of this template repository. It uses a lightweight colored terminal spinner implemented in Bash, with bracketed log levels and Nerd Font icons, and requires no visual or installer dependency. Interactive prompts use Bash readline editing, so arrow keys, in-line deletion, and cursor movement work while answering the bootstrap questions. When stdout is not an interactive terminal, it falls back to plain non-animated output.
Execution logs are written under ignored `tmp/init-project/`. The captured bootstrap context is also written into `openspec/project.md`, so OpenSpec keeps the same starting context that Codex used to complete `AGENTS.md` and `README.md`. If OpenSpec creates its workflow directories but reports an auxiliary Codex setup warning, the script keeps going and calls it out explicitly as a partial warning instead of a full failure.

Useful options:

```bash
./scripts/init-project.sh --no-codex
./scripts/init-project.sh --no-openspec
./scripts/init-project.sh --allow-no-remote
./scripts/init-project.sh --self-test --no-codex --no-openspec
```

To test the initializer from inside the template repository itself, use `--self-test`. It creates a temporary derived copy, assigns it a fake non-template `origin`, runs the initializer there without touching this repository's remote, and prints a small verification summary for folders, ignore rules, OpenSpec, and placeholder resolution.

## Working With OpenSpec

Use OpenSpec as the source of truth for non-trivial changes in a derived project:

- `openspec/project.md`: base project context. The initializer writes the captured bootstrap context here so later OpenSpec work starts from the same intent, use cases, and technology choices.
- `openspec/specs/`: stable capability and behavior specs that describe what the project currently supports.
- `openspec/changes/<change-name>/`: proposals, design notes, task lists, and spec deltas for a specific non-trivial change.
- `openspec/changes/archive/`: completed changes after they are incorporated into the stable specs.

Useful CLI commands from the local OpenSpec installation:

```bash
openspec list
openspec list --specs
openspec show <item-name>
openspec validate
openspec archive <change-name>
```

Practical workflow:

1. Initialize the project with `./scripts/init-project.sh`.
2. Keep `openspec/project.md` aligned with durable project context.
3. Before a non-trivial feature, refactor, contract change, or infrastructure change, create or update an item under `openspec/changes/<change-name>/`.
4. Implement against that OpenSpec change, then validate and archive it when the project behavior becomes the new baseline.

## Working Rules

- Use `$personal-project-structure` before creating, moving, or reviewing project artifacts.
- Store change planning, requirements, designs, proposals, and tasks in `openspec/`.
- Store durable developer documentation in `docs/dev/` and third-party reference notes in `docs/external/`.
- Store authoritative internal schemas, APIs, message formats, topics, events, and examples in `contracts/`.
- Store disposable local downloads, debug dumps, generated previews, and scratch exports in ignored `tmp/`; never keep required project state there.
- Do not commit secrets or replace sanitized examples with live credentials.

## Template Maintenance

This repository should contain reusable guidance rather than stack- or client-specific architecture. When adding general conventions, keep `AGENTS.md`, `README.template.md`, and the `personal-project-structure` skill consistent.
