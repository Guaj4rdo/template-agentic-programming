#!/usr/bin/env bash
set -euo pipefail

# Project Initialization Script
# Creates the base folder structure and runs openspec init.
# This script MUST NOT be run on the template repository itself.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PROJECT_ROOT}"

echo "=== Project Initialization Script ==="

# 1. Guard: do not run on the template repository
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if echo "${REMOTE_URL}" | grep -qi "template-agentic-programming"; then
  echo -e "${RED}ERROR: This repository still points to the template remote.${NC}"
  echo "Please update the origin remote to your derived project URL before initializing."
  echo "Example: git remote set-url origin <your-new-repo-url>"
  exit 1
fi

# 2. Create folder structure
echo "Creating folder structure..."

mkdir -p openspec/project
mkdir -p openspec/specs
mkdir -p openspec/changes/archive

mkdir -p docs/dev
mkdir -p docs/external

mkdir -p contracts/api
mkdir -p contracts/events
mkdir -p contracts/payloads
mkdir -p contracts/topics
mkdir -p contracts/examples

mkdir -p src
mkdir -p infra
mkdir -p data/samples
mkdir -p data/fixtures
mkdir -p data/seeds

mkdir -p tests/unit
mkdir -p tests/integration
mkdir -p tests/e2e
mkdir -p tests/fixtures

mkdir -p tmp

echo -e "${GREEN}Folder structure created.${NC}"

# 3. Ensure tmp/ is in .gitignore
if [ -f ".gitignore" ]; then
  if ! grep -q "^tmp/" ".gitignore"; then
    echo "" >> .gitignore
    echo "# Disposable local working artifacts" >> .gitignore
    echo "tmp/" >> .gitignore
    echo -e "${YELLOW}Added tmp/ to .gitignore${NC}"
  else
    echo "tmp/ already in .gitignore"
  fi
else
  echo -e "${YELLOW}Warning: .gitignore not found. Creating one with tmp/${NC}"
  echo "# Disposable local working artifacts" > .gitignore
  echo "tmp/" >> .gitignore
fi

# 4. Run openspec init if available
if command -v openspec &> /dev/null; then
  echo "Running openspec init..."
  openspec init || echo -e "${YELLOW}Warning: openspec init returned a non-zero exit code.${NC}"
else
  echo -e "${YELLOW}Warning: 'openspec' command not found in PATH.${NC}"
  echo "Please install OpenSpec and run 'openspec init' manually."
fi

echo ""
echo -e "${GREEN}=== Initialization complete ===${NC}"
echo "Next steps:"
echo "  1. Run '/template-init' in opencode to fill AGENTS.md and README.md interactively."
echo "  2. Copy .env.example to .env and configure secrets locally (never commit .env)."
echo "  3. Review the generated files and create an initial commit when ready."
