#!/usr/bin/env bash
# src: .github/workflows/scripts/lint.sh
# @(#) : lint articles using textlint and markdownlint
#
# Copyright (c) 2025 atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

set -euo pipefail

# ─── Validate inputs ───────────────────────────────────────────────────────────

if ! printf '%s' "${CHANGED_COUNT:-}" | grep -qE '^[0-9]+$'; then
  echo "error: CHANGED_COUNT is not a valid number: '${CHANGED_COUNT:-}'" >&2
  exit 1
fi

# ─── Skip if no changed files ──────────────────────────────────────────────────

if [ "${CHANGED_COUNT}" -eq 0 ]; then
  echo "warning: CHANGED_COUNT is 0, no files to lint" >&2
  echo "warning: CHANGED_COUNT is 0, no files to lint"
  exit 0
fi

# ─── Build file list (skip deleted files) ─────────────────────────────────────

_files=""
while IFS= read -r _file; do
  [ -z "$_file" ] && continue
  if [ ! -f "$_file" ]; then
    echo "deleted -> skip: $_file"
    continue
  fi
  _files="${_files}${_files:+ }${_file}"
done <<EOF
${CHANGED_FILES}
EOF

# ─── Skip if all files were deleted ───────────────────────────────────────────

if [ -z "$_files" ]; then
  echo "warning: all changed files have been deleted, skipping lint"
  exit 0
fi

# ─── Run linters ──────────────────────────────────────────────────────────────

# shellcheck disable=SC2086
textlint --config configs/textlintrc.yaml ${_files}

# shellcheck disable=SC2086
markdownlint --config configs/.markdownlint-cli2.yaml ${_files}
