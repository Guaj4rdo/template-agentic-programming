# {{PROJECT_NAME}}

![Banner]({{README_BANNER_PATH}})

{{PROJECT_SUMMARY}}

## Purpose

{{PROJECT_PURPOSE}}

Primary responsibilities:

- {{PRIMARY_RESPONSIBILITY_1}}
- {{PRIMARY_RESPONSIBILITY_2}}
- {{PRIMARY_RESPONSIBILITY_3}}

## Technology

| Area | Choice |
| --- | --- |
| Language | `{{LANGUAGE}}` |
| Framework or application style | `{{FRAMEWORK_OR_APPLICATION_STYLE}}` |
| Runtime | `{{RUNTIME_AND_VERSION}}` |
| Package manager or build tool | `{{PACKAGE_MANAGER_OR_BUILD_TOOL}}` |
| Data storage | `{{DATABASE_OR_STORAGE}}` |

## Project Structure

This project follows the structure rules in `AGENTS.md` and uses OpenSpec for non-trivial changes.

```text
{{PROJECT_SPECIFIC_STRUCTURE}}
```

## Setup

Prerequisites:

- {{PREREQUISITE_1}}
- {{PREREQUISITE_2}}

Install or initialize:

```bash
{{COMMAND_SETUP}}
```

Create local configuration from the sanitized example:

```bash
cp .env.example .env
```

Document required environment variables below without committing real secret values.

| Variable | Required | Description |
| --- | --- | --- |
| `{{ENV_VAR_NAME_1}}` | {{ENV_VAR_REQUIRED_1}} | {{ENV_VAR_DESCRIPTION_1}} |
| `{{ENV_VAR_NAME_2}}` | {{ENV_VAR_REQUIRED_2}} | {{ENV_VAR_DESCRIPTION_2}} |

## Development Commands

| Activity | Command |
| --- | --- |
| Run locally | `{{COMMAND_RUN}}` |
| Build | `{{COMMAND_BUILD}}` |
| Lint or static checks | `{{COMMAND_LINT}}` |
| Run tests | `{{COMMAND_TEST}}` |
| Integration or end-to-end tests | `{{COMMAND_TEST_INTEGRATION}}` |
| Database setup or migrations | `{{COMMAND_DATABASE}}` |

## Testing

{{TESTING_STRATEGY}}

## Specifications and Documentation

- Agent instructions and project decisions: `AGENTS.md`
- OpenSpec changes and capability specifications: `openspec/`
- Developer documentation: `docs/dev/`
- External system notes: `docs/external/`
- Authoritative technical contracts: `contracts/`
- Disposable local working artifacts: `tmp/` (ignored by Git and safe to delete)

Authoritative external sources:

| Source | URL | Used For |
| --- | --- | --- |
| {{SOURCE_NAME_1}} | {{SOURCE_URL_1}} | {{SOURCE_USE_WHEN_1}} |

## Security

{{SECURITY_AND_CONFIG_RULES}}

Never commit real credentials, tokens, private keys, sensitive production payloads, or populated local environment files.

## Contribution and Delivery

{{DELIVERY_EXPECTATIONS}}

Commit and pull request convention:

{{COMMIT_AND_PR_CONVENTION}}
