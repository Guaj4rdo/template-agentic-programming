---
name: personal-project-structure
description: Decide where to create, move, or update files in personal software projects organized around OpenSpec, docs/dev, docs/external, contracts, src, tests, scripts, infra, data, and disposable tmp workspaces. Use when implementing a change, organizing project artifacts, reviewing misplaced files, adding documentation or contracts, managing temporary generated artifacts, or deciding whether work belongs in OpenSpec rather than docs.
metadata:
  version: "1.1.0"
---

# Personal Project Structure

Apply a consistent folder ownership model while making or reviewing changes in a personal project.

## Workflow

1. Inspect the repository structure and any existing `AGENTS.md`, OpenSpec instructions, or local conventions before creating or moving files.
2. Classify each artifact by its durable responsibility, not merely by its format or the task that produced it.
3. Place or update the artifact according to the routing table below.
4. For a non-trivial feature, refactor, behavior change, contract change, or infrastructure change, check for an OpenSpec change under `openspec/changes/<change-name>/` before implementation. Create or request one when absent and the project follows OpenSpec.
5. When an interface or integration format changes, update the relevant contract and its canonical examples with the implementation.
6. Do not introduce a top-level directory unless the user explicitly requests it or existing repository architecture requires it.
7. Before completion, check that planning content was not duplicated into documentation and that no secrets or environment-specific values were added.

## Routing Table

| Artifact or responsibility | Destination |
| --- | --- |
| Requirement, proposal, change design, implementation tasks, capability spec | `openspec/` |
| Developer setup, operation, debugging, conventions, onboarding | `docs/dev/` |
| External vendor, API, SDK, or platform research/reference | `docs/external/` |
| Official interface, schema, API contract, event, payload, topic, canonical message example | `contracts/` |
| Executable application or product code | `src/` |
| Automated tests and test-only fixtures/helpers | `tests/` |
| Repeatable developer, CI, maintenance, migration, or deployment commands | `scripts/` |
| Runtime environment, deployment, container, network, orchestration, or IaC definition | `infra/` |
| Reusable sample, seed, local-development, or anonymized fixture data | `data/` |
| Disposable generated output, diagnostic dump, scratch export, or transient local artifact | `tmp/` |

## Decision Rules

- Treat `openspec/` as the source of truth for planning, requirements, designs for changes, proposals, and implementation task lists.
- Keep `docs/` durable and explanatory. Do not place feature proposals, implementation tasks, or OpenSpec design material in it.
- Keep internal technical interfaces in `contracts/`, even when they relate to an external integration. Place vendor observations and external documentation in `docs/external/`.
- Put schemas in `contracts/`, sample or seed instances in `data/`, and test-exclusive fixtures in `tests/fixtures/`.
- Put executable automation in `scripts/`; put the infrastructure definition it invokes or deploys in `infra/`.
- Put disposable generated output, downloads, debug captures, ad hoc exports, and transient scratch files in `tmp/`; keep `tmp/` ignored by Git and safe to delete.
- Never use `tmp/` for authoritative contracts, reusable samples, committed fixtures, documentation, or required project state.
- Prefer existing project layout when it is more specific and does not conflict with these ownership boundaries.

## Contract Change Check

Update `contracts/` and relevant examples when modifying:

- API request or response shapes
- event names, payloads, or shared envelopes
- MQTT or other message topic formats
- JSON schemas or integration message formats

## Avoid

Do not create ownership-duplicating directories such as:

```text
tools/agent/
tools/agent/prompts/
tools/agent/checklists/
docs/specs/
docs/proposals/
docs/tasks/
docs/architecture/
contracts/specs/
```

Do not mechanically move existing files only because they differ from this convention. Apply relocations when requested or when needed for the current change, preserving repository-specific decisions.

## Bundled Resources

- Read [references/folder-responsibilities.md](references/folder-responsibilities.md) when resolving borderline placements, recommending a full layout, or explaining folder ownership in detail.
- Use [assets/AGENTS.snippet.md](assets/AGENTS.snippet.md) as a starting snippet when the user wants these ownership rules recorded in a project's `AGENTS.md`.
- Use [assets/project-structure.example.txt](assets/project-structure.example.txt) when presenting or creating an example directory skeleton.

## Completion Check

- Place new or updated files in the folder that owns their responsibility.
- Keep OpenSpec planning and design out of `docs/`.
- Update contracts and canonical examples when interface behavior changes.
- Keep disposable local artifacts in ignored `tmp/`, not in owned source or documentation folders.
- Avoid unnecessary new top-level directories.
- Avoid committing secrets or environment-specific values.
