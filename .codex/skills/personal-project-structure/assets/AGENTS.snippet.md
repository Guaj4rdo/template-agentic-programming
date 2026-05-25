## Project Structure

This project follows `$personal-project-structure`.

Use `$personal-project-structure` before creating, moving, or reviewing file locations; adding documentation, contracts, sample data, scripts, or infrastructure; deciding whether work belongs in OpenSpec rather than `docs/`; or evaluating a new top-level directory.

Respect these folder ownership rules:

- `openspec/`: planning, requirements, specs, proposals, change designs, and tasks.
- `docs/dev/`: durable developer documentation only.
- `docs/external/`: external vendor, API, SDK, and platform references only.
- `contracts/`: official technical contracts, schemas, topics, events, payloads, and canonical examples.
- `src/`: application source code.
- `tests/`: automated tests and test-only fixtures.
- `scripts/`: repeatable executable commands.
- `infra/`: infrastructure and deployment definitions.
- `data/`: reusable samples, fixtures, and seeds.
- `tmp/`: ignored, disposable local outputs such as downloads, diagnostic dumps, previews, and scratch exports.

Before implementing a non-trivial change, check for an OpenSpec change under `openspec/changes/<change-name>/`. Update contracts and canonical examples when interface behavior changes.

Do not create `tools/agent/`, `docs/specs/`, `docs/proposals/`, or `docs/tasks/` to duplicate OpenSpec responsibilities.
Do not place durable or required project artifacts in `tmp/`; it must remain safe to delete.

## External Documentation Sources

In the project's `AGENTS.md`, register official external documentation used for APIs, SDKs, providers, protocols, or platform assumptions. Consult those sources before changing external behavior, store durable third-party notes in `docs/external/`, and keep authoritative internal interfaces in `contracts/`.
