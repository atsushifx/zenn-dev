#shellcheck shell=sh
# .github/workflows/scripts/__tests__/unit/resolve_sha.unit.spec.sh
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
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT

      # Create a temp directory for PATH-based git stub
      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git: rev-list returns multiple lines of "<commit> <parent>" pairs.
      # Only the first line describes HEAD; later lines are older ancestors and
      # must never be used for before_sha/after_sha.
      cat > "$STUB_DIR/git" <<'STUB'
#!/bin/sh
case "$1" in
rev-list)
  echo "abc123def456 parentsha123"
  echo "parentsha123 grandparent789"
  echo "grandparent789 greatgrand000"
  ;;
rev-parse) echo "false" ;;
esac
STUB
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup() {
      rm -f "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup'
    After 'cleanup'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-01 - workflow_dispatch with parent commit'
        It 'writes before_sha=parentsha123 to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "before_sha=parentsha123"
        End

        It 'writes after_sha=abc123def456 to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "after_sha=abc123def456"
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "skip=false"
        End
      End
    End
  End

  Describe 'Given: schedule event with parent commit'
    setup_schedule() {
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      cat > "$STUB_DIR/git" <<'STUB'
#!/bin/sh
case "$1" in
rev-list) echo "abc123def456 parentsha123" ;;
rev-parse) echo "false" ;;
esac
STUB
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="schedule"
    }
    cleanup_schedule() {
      rm -f "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_schedule'
    After 'cleanup_schedule'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-05 - non push/PR event resolves SHA itself'
        It 'writes the resolved before_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 1 of contents of file "$GITHUB_OUTPUT" should equal "before_sha=parentsha123"
        End

        It 'writes the resolved after_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 2 of contents of file "$GITHUB_OUTPUT" should equal "after_sha=abc123def456"
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The contents of file "$GITHUB_OUTPUT" should include "skip=false"
        End
      End
    End
  End

  Describe 'Given: non push/PR event with no parent commit on a full clone'
    setup_no_parent() {
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git: rev-list returns 1 field only (no parent),
      # rev-parse reports a full (non-shallow) clone -> a true initial commit.
      cat > "$STUB_DIR/git" <<'STUB'
#!/bin/sh
case "$1" in
rev-list) echo "abc123def456" ;;
rev-parse) echo "false" ;;
esac
STUB
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup_no_parent() {
      rm -f "$GITHUB_OUTPUT"
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

  Describe 'Given: non push/PR event with no parent commit on a shallow clone'
    setup_shallow() {
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git: rev-list returns 1 field only, but rev-parse reports a shallow
      # clone -> the parent exists upstream and is merely not fetched.
      cat > "$STUB_DIR/git" <<'STUB'
#!/bin/sh
case "$1" in
rev-list) echo "abc123def456" ;;
rev-parse) echo "true" ;;
esac
STUB
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup_shallow() {
      rm -f "$GITHUB_OUTPUT"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_shallow'
    After 'cleanup_shallow'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-06 - shallow clone must not be treated as initial commit'
        It 'exits with non-zero status'
          When run script "$_SCRIPT"
          The stderr should include "error"
          The status should be failure
        End

        It 'outputs an error message'
          When run script "$_SCRIPT"
          The status should be failure
          The stderr should include "error"
        End

        It 'does not write skip=true to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The stderr should include "error"
          The status should be failure
          The contents of file "$GITHUB_OUTPUT" should not include "skip=true"
        End
      End
    End
  End

  Describe 'Given: non push/PR event and git command fails'
    setup_git_fail() {
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT

      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      # Stub git to exit with non-zero (simulates git failure)
      printf '#!/bin/sh\nexit 128\n' > "$STUB_DIR/git"
      chmod +x "$STUB_DIR/git"

      export PATH="$STUB_DIR:$PATH"
      export EVENT_NAME="workflow_dispatch"
    }
    cleanup_git_fail() {
      rm -f "$GITHUB_OUTPUT"
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
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT
      export EVENT_NAME="push"
    }
    cleanup_push() {
      rm -f "$GITHUB_OUTPUT"
    }
    Before 'setup_push'
    After 'cleanup_push'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-02 - push event delegates to upstream action'
        It 'writes an empty before_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 1 of contents of file "$GITHUB_OUTPUT" should equal "before_sha="
        End

        It 'writes an empty after_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 2 of contents of file "$GITHUB_OUTPUT" should equal "after_sha="
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 3 of contents of file "$GITHUB_OUTPUT" should equal "skip=false"
        End
      End
    End
  End

  Describe 'Given: pull_request event'
    setup_pr() {
      GITHUB_OUTPUT=$(mktemp)
      export GITHUB_OUTPUT
      export EVENT_NAME="pull_request"
    }
    cleanup_pr() {
      rm -f "$GITHUB_OUTPUT"
    }
    Before 'setup_pr'
    After 'cleanup_pr'

    Describe 'When: resolve-sha script is executed'
      Describe 'Then: Task T-02-02 - pull_request event delegates to upstream action'
        It 'writes an empty before_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 1 of contents of file "$GITHUB_OUTPUT" should equal "before_sha="
        End

        It 'writes an empty after_sha to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 2 of contents of file "$GITHUB_OUTPUT" should equal "after_sha="
        End

        It 'writes skip=false to GITHUB_OUTPUT'
          When run script "$_SCRIPT"
          The line 3 of contents of file "$GITHUB_OUTPUT" should equal "skip=false"
        End
      End
    End
  End
End
