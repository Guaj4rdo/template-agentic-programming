# Folder Responsibilities

Consult this reference when an artifact could plausibly fit in more than one owned directory.

## Contents

- [`openspec/`](#openspec)
- [`docs/dev/`](#docsdev)
- [`docs/external/`](#docsexternal)
- [`docs/assets/`](#docsassets)
- [`contracts/`](#contracts)
- [`src/`](#src)
- [`tests/`](#tests)
- [`scripts/`](#scripts)
- [`infra/`](#infra)
- [`data/`](#data)
- [`tmp/`](#tmp)
- [Borderline Placements](#borderline-placements)

## `openspec/`

Own formal, change-oriented planning and specification work:

```text
openspec/project.md
openspec/specs/
openspec/changes/archive/
openspec/changes/<change-name>/proposal.md
openspec/changes/<change-name>/design.md
openspec/changes/<change-name>/tasks.md
openspec/changes/<change-name>/specs/
```

Use `openspec/changes/<change-name>/` for every non-trivial feature, refactor, contract change, infrastructure change, or behavior change. Use kebab-case change names. Do not use OpenSpec for stable developer how-to documentation.

## `docs/dev/`

Own durable developer-facing operating knowledge:

- local setup and environment configuration
- debugging and troubleshooting guides
- coding conventions and onboarding notes
- common developer commands

Examples:

```text
docs/dev/local-setup.md
docs/dev/debugging.md
docs/dev/coding-conventions.md
docs/dev/database-local-setup.md
```

Do not place feature proposals, task lists, or change designs here.

## `docs/external/`

Own knowledge sourced from systems outside the project:

- vendor API or SDK notes
- platform behavior and limitations
- integration research and external constraints
- third-party documentation summaries and links

Examples:

```text
docs/external/meta-whatsapp-api.md
docs/external/flighthub-api.md
docs/external/stripe-payments.md
docs/external/supabase-limits.md
```

Do not place the project's official internal interface definitions here.

## `docs/assets/`

Own static resources referenced by project documentation and README:

- README banner images, logos, and project branding
- Diagrams, flowcharts, and architecture visuals
- Screenshots and demo GIFs used in developer guides

Examples:

```text
docs/assets/banner.png
docs/assets/logo.svg
docs/assets/architecture-diagram.png
```

Keep these files small and optimized. Do not store large binary artifacts, video files, or generated build output in `docs/assets/`.

## `contracts/`

Own authoritative interfaces between systems:

```text
contracts/api/
contracts/events/
contracts/payloads/
contracts/topics/
contracts/examples/
```

| Directory | Owns | Examples |
| --- | --- | --- |
| `contracts/api/` | API specifications | `openapi.yaml`, `admin-api.openapi.yaml` |
| `contracts/events/` | Event definitions and domain event contracts | `patrol-events.md`, `device-state-events.md` |
| `contracts/payloads/` | Schemas and payload definitions | `envelope.schema.json`, `telemetry.schema.json` |
| `contracts/topics/` | Message topic naming and standards | `mqtt-topic-standard.md`, `patrol-topics.md` |
| `contracts/examples/` | Canonical valid interface examples | `telemetry-message.json`, `patrol-started.json` |

Update the relevant contract and examples when integration behavior changes.

## `src/`

Own executable application source:

- business and domain logic
- application modules, services, controllers, and handlers
- UI code
- adapters and repositories
- runtime configuration code

Do not place OpenSpec artifacts, infrastructure definitions, raw data fixtures, or documentation in `src/`.

## `tests/`

Own automated validation:

```text
tests/unit/
tests/integration/
tests/e2e/
tests/fixtures/
```

Keep fixture data in `tests/fixtures/` only when tests exclusively own it. Put reusable example, seed, or local-development data in `data/`.

## `scripts/`

Own repeatable executable commands used in development, CI, deployment, or maintenance:

```text
scripts/dev.sh
scripts/build.sh
scripts/test.sh
scripts/deploy.sh
scripts/db/migrate.sh
scripts/db/seed.sh
```

Store definitions of deployed resources and environments in `infra/`, not in `scripts/`.

## `infra/`

Own infrastructure, deployment, and runtime-environment definitions:

- Dockerfiles and Compose definitions
- reverse-proxy configuration
- system services
- Kubernetes manifests
- Terraform and Ansible configuration

Examples:

```text
infra/docker/Dockerfile
infra/compose/docker-compose.yml
infra/nginx/app.conf
infra/systemd/app.service
infra/terraform/main.tf
infra/k8s/deployment.yaml
```

Do not place application source code in `infra/`.

## `data/`

Own non-source data used by the project:

```text
data/samples/
data/fixtures/
data/seeds/
```

Use it for reusable samples, seed files, local-development data, and anonymized real-world examples. Store authoritative schemas in `contracts/`, not in `data/`.

## `tmp/`

Own disposable local working artifacts that can be regenerated or deleted without affecting project correctness:

```text
tmp/downloads/
tmp/debug/
tmp/exports/
tmp/generated/
```

Use it for API response dumps captured during investigation, temporary downloads, diagnostic output, generated previews, one-off exports, and intermediate conversion artifacts.

Rules:

- Keep `tmp/` ignored by Git.
- Treat every file under `tmp/` as deletable without review.
- Do not store authoritative contracts, durable external research, reusable samples, test fixtures, seeds, source code, or configuration required to run the project in `tmp/`.
- Promote useful durable content to its owning directory before finishing the task.

## Borderline Placements

| Artifact | Place it in | Reason |
| --- | --- | --- |
| Design for a proposed feature | `openspec/changes/<change-name>/design.md` | It participates in change planning. |
| Long-lived explanation of local database setup | `docs/dev/` | It helps future developers operate the project. |
| Notes about an external webhook provider | `docs/external/` | It documents third-party behavior. |
| The webhook payload the project promises to accept | `contracts/` | It is an authoritative system interface. |
| JSON payload used as a canonical valid contract example | `contracts/examples/` | It validates or illustrates the contract. |
| JSON payload reused for development seed data | `data/` | It is reusable operating data, not the contract. |
| Fixture created only to exercise a failing test | `tests/fixtures/` | Its ownership is test-specific. |
| Raw API response downloaded temporarily while debugging | `tmp/` | It is disposable investigative output. |
| Sanitized response retained as a reusable integration example | `data/samples/` or `contracts/examples/` | Its durable responsibility determines the owner. |
| Shell command that applies Terraform | `scripts/` | It is executable automation. |
| Terraform files applied by that command | `infra/` | They define infrastructure state. |
