#!/usr/bin/env bash

set -euo pipefail

TEMPLATE_REMOTE_PATTERN="template-agentic-programming"
RUN_OPENSPEC=1
RUN_CODEX=1
ALLOW_NO_REMOTE=0
SELF_TEST=0
RESET=""
RED=""
GREEN=""
YELLOW=""
BLUE=""
BOLD=""
INITIAL_PROJECT_PROMPT=""
ICON_INFO="󰋽"
ICON_DONE="󰄬"
ICON_WARN="󰀪"
ICON_ERROR="󰅚"
ICON_STEP="󰔟"
ICON_SKIP="󰒭"
ICON_INPUT="󰖟"
ICON_CHECK="󰄲"

usage() {
  cat <<'EOF'
Usage: scripts/init-project.sh [options]

Initialize a repository created from template-agentic-programming.

Options:
  --no-codex          Create structure and initialize OpenSpec without asking Codex to fill documents.
  --no-openspec       Skip OpenSpec initialization.
  --allow-no-remote   Allow initialization before a dedicated Git remote is configured.
  --self-test         Run the initializer in a temporary derived-copy of this template.
  -h, --help          Show this help.

Safety:
  The script refuses to run when origin still points to template-agentic-programming.
EOF
}

die() {
  printf '%s[%s Error]%s %s\n' "$RED" "$ICON_ERROR" "$RESET" "$*" >&2
  exit 1
}

info() {
  printf '%s[%s Info]%s %s\n' "$BLUE" "$ICON_INFO" "$RESET" "$*"
}

success() {
  printf '%s[%s Done]%s %s\n' "$GREEN" "$ICON_DONE" "$RESET" "$*"
}

warn() {
  printf '%s[%s Warn]%s %s\n' "$YELLOW" "$ICON_WARN" "$RESET" "$*"
}

skip() {
  printf '%s[%s Skip]%s %s\n' "$BLUE" "$ICON_SKIP" "$RESET" "$*"
}

step() {
  printf '%s[%s Step]%s %s\n' "$BLUE" "$ICON_STEP" "$RESET" "$*"
}

self_test_check() {
  status="$1"
  message="$2"
  if [ "$status" -eq 0 ]; then
    printf '%s[%s Check]%s %s\n' "$GREEN" "$ICON_CHECK" "$RESET" "$message"
  else
    printf '%s[%s Check]%s %s\n' "$RED" "$ICON_ERROR" "$RESET" "$message"
  fi
}

for arg in "$@"; do
  case "$arg" in
    --no-codex)
      RUN_CODEX=0
      ;;
    --no-openspec)
      RUN_OPENSPEC=0
      ;;
    --allow-no-remote)
      ALLOW_NO_REMOTE=1
      ;;
    --self-test)
      SELF_TEST=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $arg"
      ;;
  esac
done

if [ -t 1 ]; then
  RESET=$'\033[0m'
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BLUE=$'\033[36m'
  BOLD=$'\033[1m'
fi

command -v git >/dev/null 2>&1 || die "git is required."

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "Run this script from inside a Git repository."
cd "$ROOT"

if [ "$SELF_TEST" -eq 1 ]; then
  command -v rsync >/dev/null 2>&1 || die "rsync is required for --self-test."

  TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/template-init-self-test.XXXXXX")"
  step "Creating temporary derived repository at $TEST_DIR"
  rsync -a --exclude='.git' ./ "$TEST_DIR/"
  git -C "$TEST_DIR" init -q -b main
  git -C "$TEST_DIR" remote add origin https://github.com/example/template-self-test.git

  FORWARDED_ARGS=()
  for arg in "$@"; do
    if [ "$arg" != "--self-test" ]; then
      FORWARDED_ARGS+=("$arg")
    fi
  done

  info "Running self-test in isolated derived copy"
  if [ "${#FORWARDED_ARGS[@]}" -gt 0 ]; then
    (
      cd "$TEST_DIR"
      ./scripts/init-project.sh "${FORWARDED_ARGS[@]}"
    )
  else
    (
      cd "$TEST_DIR"
      ./scripts/init-project.sh
    )
  fi

  CHECK_STATUS=0
  if [ -d "$TEST_DIR/docs/dev" ] && [ -d "$TEST_DIR/contracts/api" ] && [ -d "$TEST_DIR/src" ] && [ -d "$TEST_DIR/tests/unit" ]; then
    self_test_check 0 "Base project folders were created"
  else
    self_test_check 1 "Base project folders are incomplete"
    CHECK_STATUS=1
  fi

  if git -C "$TEST_DIR" check-ignore -q tmp/init-project; then
    self_test_check 0 "tmp/ contents are ignored by Git"
  else
    self_test_check 1 "tmp/ contents are not ignored by Git"
    CHECK_STATUS=1
  fi

  if [ "$RUN_OPENSPEC" -eq 1 ]; then
    if [ -d "$TEST_DIR/openspec" ] && [ -d "$TEST_DIR/openspec/specs" ] && [ -d "$TEST_DIR/openspec/changes/archive" ]; then
      self_test_check 0 "OpenSpec directories were created"
    else
      self_test_check 1 "OpenSpec directories are missing"
      CHECK_STATUS=1
    fi

    if [ -f "$TEST_DIR/openspec/project.md" ] && grep -Fq '<!-- init-project:initial-prompt:start -->' "$TEST_DIR/openspec/project.md"; then
      self_test_check 0 "Initial project prompt was recorded in openspec/project.md"
    else
      self_test_check 1 "Initial project prompt is missing from openspec/project.md"
      CHECK_STATUS=1
    fi
  else
    self_test_check 0 "OpenSpec step was intentionally skipped"
  fi

  if [ "$RUN_CODEX" -eq 1 ]; then
    if rg -q '\{\{' "$TEST_DIR/AGENTS.md" "$TEST_DIR/README.md" 2>/dev/null; then
      self_test_check 1 "Codex left unresolved placeholders in AGENTS.md or README.md"
      CHECK_STATUS=1
    else
      self_test_check 0 "Codex resolved AGENTS.md and README.md placeholders"
    fi
  else
    self_test_check 0 "Codex step was intentionally skipped"
  fi

  success "Self-test completed in $TEST_DIR"
  info "Inspect files in the temporary copy, then remove it when finished."
  info "Temporary path: $TEST_DIR"
  exit "$CHECK_STATUS"
fi

ORIGIN_URL="$(git config --get remote.origin.url 2>/dev/null || true)"
if [ -z "$ORIGIN_URL" ]; then
  if [ "$ALLOW_NO_REMOTE" -ne 1 ]; then
    die "No origin remote configured. Create the project repository first, or use --allow-no-remote intentionally."
  fi
elif printf '%s' "$ORIGIN_URL" | grep -q "$TEMPLATE_REMOTE_PATTERN"; then
  die "origin still points to the template repository ($ORIGIN_URL). Create a derived repository before initializing it."
fi

if [ ! -f "AGENTS.md" ] || [ ! -f "README.template.md" ]; then
  die "Template files AGENTS.md and README.template.md are required in the repository root."
fi

if [ "$RUN_OPENSPEC" -eq 1 ]; then
  command -v openspec >/dev/null 2>&1 || die "openspec is required, or run with --no-openspec."
fi
if [ "$RUN_CODEX" -eq 1 ]; then
  command -v codex >/dev/null 2>&1 || die "codex is required, or run with --no-codex."
fi

mkdir -p tmp/init-project
WORK_DIR="$ROOT/tmp/init-project"

run_step() {
  label="$1"
  slug="$2"
  shift 2
  log_file="$WORK_DIR/$slug.log"

  if [ -t 1 ]; then
    "$@" >"$log_file" 2>&1 &
    pid=$!
    spinner='|/-\'
    i=0
    while kill -0 "$pid" 2>/dev/null; do
      frame="$(printf '%s' "$spinner" | cut -c $((i % 4 + 1)))"
      printf '\r%s[%s Step]%s %s %s' "$BLUE" "$ICON_STEP" "$RESET" "$label" "$frame"
      i=$((i + 1))
      sleep 0.12
    done
    if wait "$pid"; then
      printf '\r%s[%s Done]%s %s\n' "$GREEN" "$ICON_DONE" "$RESET" "$label"
      return 0
    fi
    printf '\r%s[%s Error]%s %s\n' "$RED" "$ICON_ERROR" "$RESET" "$label" >&2
    printf '%s[%s Info]%s See %s\n' "$BLUE" "$ICON_INFO" "$RESET" "$log_file" >&2
    return 1
  fi

  step "$label"
  if "$@" >"$log_file" 2>&1; then
    success "$label"
    return 0
  fi
  printf '%s[%s Error]%s %s\n' "$RED" "$ICON_ERROR" "$RESET" "$label" >&2
  printf '%s[%s Info]%s See %s\n' "$BLUE" "$ICON_INFO" "$RESET" "$log_file" >&2
  return 1
}

OPEN_SPEC_STATUS="not-run"

create_structure() {
  mkdir -p \
    docs/dev \
    docs/external \
    contracts/api \
    contracts/events \
    contracts/payloads \
    contracts/topics \
    contracts/examples \
    src \
    tests/unit \
    tests/integration \
    tests/e2e \
    tests/fixtures \
    scripts \
    infra \
    data/samples \
    data/fixtures \
    data/seeds \
    tmp

  for dir in \
    docs/dev \
    docs/external \
    contracts/api \
    contracts/events \
    contracts/payloads \
    contracts/topics \
    contracts/examples \
    src \
    tests/unit \
    tests/integration \
    tests/e2e \
    tests/fixtures \
    infra \
    data/samples \
    data/fixtures \
    data/seeds; do
    if [ ! -e "$dir/.gitkeep" ]; then
      : > "$dir/.gitkeep"
    fi
  done
}

prompt_required() {
  prompt="$1"
  value=""
  while [ -z "$value" ]; do
    printf '%s: ' "$prompt" >&2
    IFS= read -r value || die "Input interrupted."
  done
  printf '%s' "$value"
}

prompt_optional() {
  prompt="$1"
  default="$2"
  value=""
  printf '%s [%s]: ' "$prompt" "$default" >&2
  IFS= read -r value || die "Input interrupted."
  if [ -z "$value" ]; then
    value="$default"
  fi
  printf '%s' "$value"
}

capture_initial_prompt() {
  if [ -n "$INITIAL_PROJECT_PROMPT" ]; then
    return 0
  fi

  printf '\n%s%s[%s Input]%s Provide the initial project direction for OpenSpec and Codex.\n' "$BOLD" "$BLUE" "$ICON_INPUT" "$RESET" >&2
  INITIAL_PROJECT_PROMPT="$(prompt_required "Initial project prompt for Codex and OpenSpec")"
}

write_context_file() {
  context_file="$WORK_DIR/project-context.md"

  capture_initial_prompt
  printf '\n%s%s[%s Input]%s Provide structured project context for Codex.\n' "$BOLD" "$BLUE" "$ICON_INPUT" "$RESET" >&2
  project_name="$(prompt_required "Project name")"
  project_purpose="$(prompt_required "Purpose and system type")"
  responsibilities="$(prompt_required "Primary responsibilities (semicolon-separated)")"
  tech_stack="$(prompt_required "Technical stack and fixed decisions")"
  runtime="$(prompt_required "Runtime and package manager")"
  structure="$(prompt_optional "Project-specific structure additions" "No additions beyond the base structure")"
  command_setup="$(prompt_required "Setup command")"
  command_run="$(prompt_required "Local run command")"
  command_build="$(prompt_required "Build command")"
  command_lint="$(prompt_required "Lint or static-check command")"
  command_test="$(prompt_required "Test command")"
  command_integration="$(prompt_optional "Integration/e2e test command" "Not applicable")"
  command_database="$(prompt_optional "Database initialization/migration command" "Not applicable")"
  testing_strategy="$(prompt_required "Testing strategy")"
  environment_variables="$(prompt_optional "Required environment variable names (comma-separated)" "Not applicable")"
  external_sources="$(prompt_optional "External documentation sources (URLs and use, semicolon-separated)" "No external sources required")"
  additional_skills="$(prompt_optional "Additional project skills and triggers" "No additional skills apply")"
  security_rules="$(prompt_required "Security and configuration rules")"
  delivery="$(prompt_required "Delivery expectations")"
  commit_convention="$(prompt_optional "Commit and pull request convention" "Conventional Commits; report tests and configuration changes in pull requests")"

  {
    printf '# Initial Project Context\n\n'
    printf '## Initial Project Prompt\n\n'
    printf '%s\n\n' "$INITIAL_PROJECT_PROMPT"
    printf -- '- Project name: %s\n' "$project_name"
    printf -- '- Purpose and system type: %s\n' "$project_purpose"
    printf -- '- Primary responsibilities: %s\n' "$responsibilities"
    printf -- '- Technical stack and fixed decisions: %s\n' "$tech_stack"
    printf -- '- Runtime and package manager: %s\n' "$runtime"
    printf -- '- Project-specific structure additions: %s\n' "$structure"
    printf -- '- Setup command: `%s`\n' "$command_setup"
    printf -- '- Local run command: `%s`\n' "$command_run"
    printf -- '- Build command: `%s`\n' "$command_build"
    printf -- '- Lint or static-check command: `%s`\n' "$command_lint"
    printf -- '- Test command: `%s`\n' "$command_test"
    printf -- '- Integration/e2e command: `%s`\n' "$command_integration"
    printf -- '- Database initialization/migration command: `%s`\n' "$command_database"
    printf -- '- Testing strategy: %s\n' "$testing_strategy"
    printf -- '- Required environment variable names: %s\n' "$environment_variables"
    printf -- '- External documentation sources: %s\n' "$external_sources"
    printf -- '- Additional project skills and triggers: %s\n' "$additional_skills"
    printf -- '- Security and configuration rules: %s\n' "$security_rules"
    printf -- '- Delivery expectations: %s\n' "$delivery"
    printf -- '- Commit and pull request convention: %s\n' "$commit_convention"
  } > "$context_file"

  printf '%s' "$context_file"
}

sync_openspec_project_context() {
  project_file="openspec/project.md"
  block_file="$WORK_DIR/openspec-initial-prompt.md"
  temp_file="$WORK_DIR/openspec-project.tmp"
  start_marker='<!-- init-project:initial-prompt:start -->'
  end_marker='<!-- init-project:initial-prompt:end -->'

  {
    printf '%s\n' "$start_marker"
    printf '## Initial Project Prompt\n\n'
    printf '%s\n\n' "$INITIAL_PROJECT_PROMPT"
    printf 'This section is managed by `scripts/init-project.sh` and records the original project direction captured during repository initialization.\n'
    printf '%s\n' "$end_marker"
  } > "$block_file"

  if [ ! -f "$project_file" ]; then
    {
      printf '# Project Context\n\n'
      printf 'This file stores durable OpenSpec context for the repository.\n\n'
      cat "$block_file"
    } > "$project_file"
    return 0
  fi

  if grep -Fq "$start_marker" "$project_file"; then
    awk -v start="$start_marker" -v end="$end_marker" '
      FNR == NR { replacement = replacement $0 ORS; next }
      index($0, start) { printf "%s", replacement; skipping = 1; next }
      index($0, end) { skipping = 0; next }
      !skipping { print }
    ' "$block_file" "$project_file" > "$temp_file"
    mv "$temp_file" "$project_file"
  else
    if [ -s "$project_file" ]; then
      printf '\n' >> "$project_file"
    fi
    cat "$block_file" >> "$project_file"
  fi
}

write_codex_prompt() {
  context_file="$1"
  prompt_file="$WORK_DIR/codex-init-prompt.md"

  cat > "$prompt_file" <<EOF
Initialize the derived project documentation using the supplied context.

Read:
- AGENTS.md
- README.template.md
- .env.example
- .codex/skills/personal-project-structure/SKILL.md
- $context_file

Tasks:
0. Treat the "Initial Project Prompt" section as the highest-priority stylistic and directional guidance for how to shape AGENTS.md and README.md, as long as it does not conflict with explicit task constraints below.
1. Replace all double-braced placeholders in AGENTS.md with concrete project instructions from the context. Use "Not applicable" where the context explicitly says it does not apply.
2. Replace README.md with the completed project README derived from README.template.md. Do not leave template-maintenance instructions in the project README.
3. Update .env.example only with the sanitized environment variable names stated in the context. Do not add secrets, real credentials, or inferred variables.
4. Reflect initialized OpenSpec usage and the existing project folder policy accurately.
5. Do not modify scripts/init-project.sh, .gitignore, openspec/, the personal-project-structure skill, or application code.
6. Do not invent external URLs, commands, integrations, or security requirements that are absent from the context.
7. Before finishing, check AGENTS.md and README.md for unresolved double-braced placeholders and remove or resolve them.

Project context:

$(cat "$context_file")
EOF

  printf '%s' "$prompt_file"
}

if [ "$RUN_OPENSPEC" -eq 1 ] || [ "$RUN_CODEX" -eq 1 ]; then
  capture_initial_prompt
fi

printf '%s%s[%s Step]%s Initializing derived project at %s\n' "$BOLD" "$BLUE" "$ICON_STEP" "$RESET" "$ROOT"
create_structure
success "Created base project folders and tracked placeholders (tmp/ remains disposable and ignored)"

if [ "$RUN_OPENSPEC" -eq 1 ]; then
  run_step "Initializing OpenSpec for Codex" "openspec-init" openspec init --tools codex .
  for dir in openspec/specs openspec/changes/archive; do
    if [ -d "$dir" ] && [ ! -e "$dir/.gitkeep" ]; then
      : > "$dir/.gitkeep"
    fi
  done
  if [ -d "openspec" ] && [ -d "openspec/specs" ] && [ -d "openspec/changes/archive" ]; then
    OPEN_SPEC_STATUS="initialized"
    if grep -q '^Failed:' "$WORK_DIR/openspec-init.log" 2>/dev/null; then
      OPEN_SPEC_STATUS="initialized-with-warnings"
      warn "OpenSpec created its structure but reported a tool-setup warning. Review $WORK_DIR/openspec-init.log"
    fi
    sync_openspec_project_context
    success "Recorded the initial project prompt in openspec/project.md"
  else
    OPEN_SPEC_STATUS="failed"
    die "OpenSpec did not create the expected workflow directories. Review $WORK_DIR/openspec-init.log"
  fi
else
  OPEN_SPEC_STATUS="skipped"
  skip "OpenSpec initialization disabled"
fi

if [ "$RUN_CODEX" -eq 1 ]; then
  context_file="$(write_context_file)"
  prompt_file="$(write_codex_prompt "$context_file")"
  run_step "Generating AGENTS.md, README.md, and .env.example with Codex" "codex-init" \
    codex exec --ephemeral -s workspace-write -C "$ROOT" - < "$prompt_file"
else
  skip "Codex document generation disabled"
fi

success "Project initialization completed."
if [ "$OPEN_SPEC_STATUS" = "initialized-with-warnings" ]; then
  warn "OpenSpec workflow directories are ready, but auxiliary Codex setup reported a warning. Review $WORK_DIR/openspec-init.log if you need that integration."
fi
info "Review changes with: git status --short"
info "Review generated instructions and sanitized configuration before committing."
