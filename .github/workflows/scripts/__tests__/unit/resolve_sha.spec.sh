#shellcheck shell=sh
# .github/workflows/scripts/__tests__/unit/resolve_sha.spec.sh
# @(#) : ShellSpec unit tests for .github/workflows/scripts/resolve-sha.sh
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# ─── Internal Helpers ──────────────────────────────────────────────────────────

_SCRIPT="${SHELLSPEC_PROJECT_ROOT}/.github/workflows/scripts/resolve-sha.sh"

Describe 'resolve-sha.sh'
  Describe 'Given: workflow_dispatch event with parent commit'
    setup() {
      # Create temp files for GITHUB_ENV and GITHUB_OUTPUT
      GITHUB_ENV=$(mktemp)
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_ENV GITHUB_OUTPUT

      # Create a temp directory for PATH-based git stub
      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git to return 2 fields (HEAD SHA + parent SHA)
      printf '#!/bin/sh\necho "abc123def456 parentsha123"\n' > "$STUB_DIR/git"
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup() {
      rm -f "$GITHUB_ENV" "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup'
    After 'cleanup'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-01 - workflow_dispatch with parent commit'
        It 'writes BEFORE_SHA=parentsha123 to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "BEFORE_SHA=parentsha123"
        End

        It 'writes AFTER_SHA=abc123def456 to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "AFTER_SHA=abc123def456"
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "skip=false"
        End
      End
    End
  End

  Describe 'Given: workflow_dispatch event with no parent commit (initial commit)'
    setup_no_parent() {
      GITHUB_ENV=$(mktemp)
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_ENV GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git to return 1 field only (no parent)
      printf '#!/bin/sh\necho "abc123def456"\n' > "$STUB_DIR/git"
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup_no_parent() {
      rm -f "$GITHUB_ENV" "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_no_parent'
    After 'cleanup_no_parent'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-04 - initial commit, no parent'
        It 'writes skip=true to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The stderr should include "warning"
          The contents of file "$GITHUB_OUTPUT" should include "skip=true"
        End

        It 'exits with status 0'
          When run script "$_SCRIPT"
          The stderr should include "warning"
          The status should be success
        End

        It 'outputs a warning message'
          When run script "$_SCRIPT"
          The stderr should include "warning"
        End
      End
    End
  End

  Describe 'Given: workflow_dispatch event and git command fails'
    setup_git_fail() {
      GITHUB_ENV=$(mktemp)
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_ENV GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git to exit with non-zero (simulates git failure)
      printf '#!/bin/sh\nexit 128\n' > "$STUB_DIR/git"
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup_git_fail() {
      rm -f "$GITHUB_ENV" "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_git_fail'
    After 'cleanup_git_fail'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-03 - git failure causes job failure'
        It 'exits with non-zero status'
          When run script "$_SCRIPT"
          The status should be failure
        End
      End
    End
  End

  Describe 'Given: push event'
    setup_push() {
      GITHUB_ENV=$(mktemp)
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_ENV GITHUB_OUTPUT
      export EVENT_NAME="push"
    }
    cleanup_push() {
      rm -f "$GITHUB_ENV" "$GITHUB_OUTPUT"
    }
    Before 'setup_push'
    After 'cleanup_push'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-02 - push event with empty SHA'
        It 'writes BEFORE_SHA= (empty) to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "BEFORE_SHA="
        End

        It 'writes AFTER_SHA= (empty) to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "AFTER_SHA="
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "skip=false"
        End
      End
    End
  End

  Describe 'Given: pull_request event'
    setup_pr() {
      GITHUB_ENV=$(mktemp)
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_ENV GITHUB_OUTPUT
      export EVENT_NAME="pull_request"
    }
    cleanup_pr() {
      rm -f "$GITHUB_ENV" "$GITHUB_OUTPUT"
    }
    Before 'setup_pr'
    After 'cleanup_pr'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-02 - pull_request event with empty SHA'
        It 'writes BEFORE_SHA= (empty) to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "BEFORE_SHA="
        End

        It 'writes AFTER_SHA= (empty) to GITHUB_ENV'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_ENV" should include "AFTER_SHA="
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "skip=false"
        End
      End
    End
  End
End
