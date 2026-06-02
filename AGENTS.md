# {{PROJECT_NAME}} - Repository Guidelines

Complete this file after `/template-init` and before substantive implementation work. Replace every required double-braced field with project-specific guidance, or explicitly state `Not applicable` when a section does not apply. Do not leave unresolved placeholders in an active project.

For repositories created from this template, run the initialization in two steps:
1. `bash scripts/init-project.sh` — creates the base folder structure and runs `openspec init`.
2. In opencode, run `/template-init` — interactively fills this document and `README.md` from `README.template.md`.

The script must not be run while `origin` points to the template repository.

## Initialization Checklist

After `/template-init`, define all of the following:

| Required Information | Value |
| --- | --- |
| Project name | `{{PROJECT_NAME}}` |
| Purpose and system type | `{{PROJECT_PURPOSE}}` |
| Primary responsibilities | `{{PRIMARY_RESPONSIBILITIES}}` |
| Technical stack and fixed decisions | `{{TECH_STACK}}` |
| Runtime and package manager | `{{PACKAGE_MANAGER_AND_RUNTIME}}` |
| Project-specific structure | `{{PROJECT_SPECIFIC_STRUCTURE}}` |
| Setup command | `{{COMMAND_SETUP}}` |
| Local run command | `{{COMMAND_RUN}}` |
| Build command | `{{COMMAND_BUILD}}` |
| Lint command | `{{COMMAND_LINT}}` |
| Test command | `{{COMMAND_TEST}}` |
| Testing strategy | `{{TESTING_STRATEGY}}` |
| External documentation sources | `{{EXTERNAL_DOCUMENTATION_SOURCES}}` |
| Project-specific skills | `{{PROJECT_SPECIFIC_SKILLS}}` |
| Security and configuration rules | `{{SECURITY_AND_CONFIG_RULES}}` |
| Delivery expectations | `{{DELIVERY_EXPECTATIONS}}` |
| Commit and pull request convention | `{{COMMIT_AND_PR_CONVENTION}}` |

## `/init` Completion Checklist

Complete these checks before substantive implementation work begins:

- [ ] Replace every double-braced field in `AGENTS.md`, or explicitly set the field to `Not applicable`.
- [ ] Replace the template repository `README.md` with a project README derived from `README.template.md`.
- [ ] Update `.env.example` with all required sanitized configuration variables and confirm local secret files are ignored.
- [ ] Confirm the repository remote belongs to this derived project and does not point to `template-agentic-programming`.
- [ ] Run `openspec init` for the derived project and confirm the OpenSpec workflow is initialized before starting non-trivial changes.
- [ ] Register project-specific skills and load rules in the skills table below, or explicitly state that no additional skills apply.
- [ ] Register authoritative external documentation sources, or explicitly state that no external source is required.
- [ ] Confirm project-specific structure, technical decisions, commands, and testing strategy are documented.
- [ ] Confirm security rules and delivery expectations are documented.
- [ ] Confirm disposable local artifacts use ignored `tmp/` and that no required project state is stored there.
- [ ] Verify no real secrets, credential files, or sensitive production payloads are tracked.

## Project Purpose

`{{PROJECT_PURPOSE}}`

Primary responsibilities:

- `{{PRIMARY_RESPONSIBILITY_1}}`
- `{{PRIMARY_RESPONSIBILITY_2}}`
- `{{PRIMARY_RESPONSIBILITY_3}}`

Do not infer undocumented business behavior, integration semantics, or product requirements. Use explicit user instructions, committed specifications, registered external sources, and established code behavior as the basis for changes.

## Skills and Instruction Sources

Load relevant skills before editing files governed by their rules.

| Skill | Use When | Path |
| --- | --- | --- |
| `personal-project-structure` | Creating, moving, or reviewing file locations; adding documentation, contracts, sample data, scripts, or infrastructure; deciding whether work belongs in OpenSpec rather than `docs/`; introducing or evaluating top-level folders. | [`.codex/skills/personal-project-structure/SKILL.md`](.codex/skills/personal-project-structure/SKILL.md) |
| `{{ADDITIONAL_SKILL_NAME}}` | `{{ADDITIONAL_SKILL_TRIGGER}}` | `{{ADDITIONAL_SKILL_PATH}}` |

Rules:

- Apply `$personal-project-structure` before creating or relocating project artifacts.
- Load every additional project skill whose trigger matches the task before changing affected behavior or contracts.
- Keep project-specific skills documented in this table so an agent can discover them without guessing.

## Internet and External Documentation Sources

Register authoritative external sources used to implement or verify integrations, APIs, SDKs, protocols, platform behavior, or terminology.

| Source | URL | Use When | Authority |
| --- | --- | --- | --- |
| `{{SOURCE_NAME_1}}` | `{{SOURCE_URL_1}}` | `{{SOURCE_USE_WHEN_1}}` | `{{SOURCE_AUTHORITY_1}}` |
| `{{SOURCE_NAME_2}}` | `{{SOURCE_URL_2}}` | `{{SOURCE_USE_WHEN_2}}` | `{{SOURCE_AUTHORITY_2}}` |

Documentation usage rules:

- Prefer official documentation, standards, or primary specifications for external behavior.
- Consult registered sources before changing endpoint paths, API shapes, SDK usage, protocol formats, provider terminology, or integration assumptions.
- Record durable notes about third-party systems in `docs/external/`.
- Keep the project's authoritative internal interfaces, schemas, events, payloads, topics, and canonical examples in `contracts/`, even when they derive from external documentation.
- When code or local documentation conflicts with a primary external source, follow explicit user instructions first; otherwise verify the external behavior and update affected local documentation, contracts, and implementation together.

## Project Structure and OpenSpec Rules

This project follows `$personal-project-structure`.

| Responsibility | Owned Location |
| --- | --- |
| Planning, requirements, capability specs, change proposals, change designs, and implementation tasks | `openspec/` |
| Durable developer setup, operation, debugging, and onboarding documentation | `docs/dev/` |
| External vendor, API, SDK, platform, and third-party research notes | `docs/external/` |
| Official technical interfaces, schemas, API contracts, events, payloads, topics, and canonical examples | `contracts/` |
| Executable application or product code | `src/` |
| Automated tests, test helpers, and test-only fixtures | `tests/` |
| Repeatable developer, CI, maintenance, migration, or deployment commands | `scripts/` |
| Deployment, infrastructure, containers, networks, orchestration, and infrastructure-as-code definitions | `infra/` |
| Reusable samples, seeds, local-development data, and anonymized fixtures | `data/` |
| Disposable generated output, debug captures, temporary downloads, previews, and scratch exports | `tmp/` |

Project-specific additions or refinements:

```text
{{PROJECT_SPECIFIC_STRUCTURE}}
```

Rules:

- For a non-trivial feature, refactor, behavior change, contract change, or infrastructure change, use an OpenSpec change under `openspec/changes/<change-name>/`.
- Do not duplicate OpenSpec proposals, designs, requirements, or task lists in `docs/`.
- Update relevant contracts and canonical examples when interfaces or integration formats change.
- Keep `tmp/` ignored and disposable. Promote durable results to their owning folder before completing a task.
- Do not put required runtime state, authoritative documents, contracts, reusable samples, or committed test fixtures in `tmp/`.
- Do not create `tools/agent/`, `tools/agent/prompts/`, `tools/agent/checklists/`, `docs/specs/`, `docs/proposals/`, `docs/tasks/`, `docs/architecture/`, or `contracts/specs/` to duplicate existing ownership.
- Do not introduce new top-level directories unless explicitly requested or technically justified by documented project architecture.

## Technical Decisions and Conventions

The values completed in this table are binding unless the user explicitly changes them.

| Decision | Project Value |
| --- | --- |
| Language | `{{LANGUAGE}}` |
| Framework or application style | `{{FRAMEWORK_OR_APPLICATION_STYLE}}` |
| Runtime and version | `{{RUNTIME_AND_VERSION}}` |
| Package manager or build tool | `{{PACKAGE_MANAGER_OR_BUILD_TOOL}}` |
| Database or storage | `{{DATABASE_OR_STORAGE}}` |
| Key integrations or transports | `{{KEY_INTEGRATIONS_OR_TRANSPORTS}}` |
| Configuration system | `{{CONFIGURATION_SYSTEM}}` |
| Naming and style conventions | `{{NAMING_AND_STYLE_CONVENTIONS}}` |

Additional technical constraints:

- `{{TECHNICAL_CONSTRAINT_1}}`
- `{{TECHNICAL_CONSTRAINT_2}}`

## Build, Test, and Development Commands

| Activity | Command |
| --- | --- |
| Install or setup | `{{COMMAND_SETUP}}` |
| Run locally | `{{COMMAND_RUN}}` |
| Build | `{{COMMAND_BUILD}}` |
| Lint or static checks | `{{COMMAND_LINT}}` |
| Run tests | `{{COMMAND_TEST}}` |
| Run integration or end-to-end tests | `{{COMMAND_TEST_INTEGRATION}}` |
| Database migrations or initialization | `{{COMMAND_DATABASE}}` |

Keep this file, `README.md`, package manifests, task runners, and the actual working commands aligned.

## Testing Guidelines

Testing approach:

`{{TESTING_STRATEGY}}`

Rules:

- Add or update tests with functional changes according to the affected behavior and risk.
- Keep fixtures deterministic; place test-only fixtures in `tests/fixtures/` and reusable examples or seeds in `data/`.
- Verify contract examples or schemas together with tests when integration formats change.
- Report the validation commands executed and any checks that could not be run.

## Security and Configuration

Project-specific security and configuration rules:

`{{SECURITY_AND_CONFIG_RULES}}`

Baseline rules:

- Never commit credentials, tokens, private keys, real secrets, or sensitive production payloads.
- Keep example configuration files sanitized and document required variables without real values.
- Keep secrets outside source code, documentation examples, committed data, and contract fixtures.
- Treat any project-specific credential handling or data classification rules defined above as mandatory.

## Delivery and Change Management

Expected deliverables for implementation work:

`{{DELIVERY_EXPECTATIONS}}`

When completing work, report:

- files or subsystems changed
- tests and validation commands executed
- contract, migration, or configuration impacts
- external documentation sources consulted when behavior depends on third-party systems

Commit and pull request convention:

`{{COMMIT_AND_PR_CONVENTION}}`
