#shellcheck shell=sh
# .github/workflows/scripts/__tests__/unit/lint_sh.spec.sh
# @(#) : ShellSpec unit tests for .github/workflows/scripts/lint.sh
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# ─── Internal Helpers ──────────────────────────────────────────────────────────

_SCRIPT="${SHELLSPEC_PROJECT_ROOT}/.github/workflows/scripts/lint.sh"

Describe 'lint.sh'

  Describe 'Given: CHANGED_COUNT is non-numeric'
    setup_non_numeric() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR
      printf '#!/bin/sh\necho "textlint $*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/textlint"
      printf '#!/bin/sh\necho "markdownlint $*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"
      export CHANGED_COUNT="abc"
      export CHANGED_FILES=""
    }
    cleanup_non_numeric() {
      rm -rf "$STUB_DIR"
    }
    Before 'setup_non_numeric'
    After 'cleanup_non_numeric'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-02 - CHANGED_COUNT non-numeric causes failure'
        It 'T-04-02-02: exits with non-zero status when CHANGED_COUNT is not a number'
          When run script "$_SCRIPT"
          The status should not eq 0
          The stderr should include "error"
        End
      End
    End
  End

  Describe 'Given: CHANGED_COUNT is 0'
    setup_count_zero() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR
      printf '#!/bin/sh\necho "textlint $*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/textlint"
      printf '#!/bin/sh\necho "markdownlint $*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"
      export CHANGED_COUNT="0"
      export CHANGED_FILES=""
    }
    cleanup_count_zero() {
      rm -rf "$STUB_DIR"
    }
    Before 'setup_count_zero'
    After 'cleanup_count_zero'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-03 - skip scenarios'
        It 'T-04-03-01: exits with status 0 when count is 0'
          When run script "$_SCRIPT"
          The status should eq 0
          The output should include "warning"
          The stderr should include "warning"
        End

        It 'T-04-03-01: outputs a warning message when count is 0'
          When run script "$_SCRIPT"
          The output should include "warning"
          The stderr should include "warning"
        End
      End
    End
  End

  Describe 'Given: CHANGED_FILES has two existing files with newline separator'
    setup_two_files() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR
      TMP_FILE_A=$(mktemp --suffix=.md)
      TMP_FILE_B=$(mktemp --suffix=.md)
      printf '# test a\n' > "$TMP_FILE_A"
      printf '# test b\n' > "$TMP_FILE_B"
      export TMP_FILE_A TMP_FILE_B

      printf '#!/bin/sh\nprintf "textlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/textlint"
      printf '#!/bin/sh\nprintf "markdownlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"

      CHANGED_FILES="${TMP_FILE_A}
${TMP_FILE_B}"
      export CHANGED_FILES
      export CHANGED_COUNT="2"
    }
    cleanup_two_files() {
      rm -f "$TMP_FILE_A" "$TMP_FILE_B"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_two_files'
    After 'cleanup_two_files'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-00 - newline-to-space conversion'
        It 'T-04-00-01: textlint is called once with both files'
          When run script "$_SCRIPT"
          The status should eq 0
          The contents of file "$STUB_DIR/calls.log" should include "textlint"
          The contents of file "$STUB_DIR/calls.log" should include "$TMP_FILE_A"
          The contents of file "$STUB_DIR/calls.log" should include "$TMP_FILE_B"
        End
      End

      Describe 'Then: Task T-04-01 - lint execution on existing files'
        It 'T-04-01-01: textlint is called with --config configs/textlintrc.yaml'
          When run script "$_SCRIPT"
          The status should eq 0
          The contents of file "$STUB_DIR/calls.log" should include "--config configs/textlintrc.yaml"
        End

        It 'T-04-01-02: markdownlint is called with --config configs/.markdownlint-cli2.yaml'
          When run script "$_SCRIPT"
          The status should eq 0
          The contents of file "$STUB_DIR/calls.log" should include "--config configs/.markdownlint-cli2.yaml"
        End
      End
    End
  End

  Describe 'Given: one file deleted, one file exists'
    setup_one_deleted() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR
      TMP_FILE=$(mktemp --suffix=.md)
      printf '# test\n' > "$TMP_FILE"
      export TMP_FILE
      DELETED_FILE="/nonexistent/deleted_$(date +%s).md"
      export DELETED_FILE

      printf '#!/bin/sh\nprintf "textlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/textlint"
      printf '#!/bin/sh\nprintf "markdownlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"

      CHANGED_FILES="${DELETED_FILE}
${TMP_FILE}"
      export CHANGED_FILES
      export CHANGED_COUNT="2"
    }
    cleanup_one_deleted() {
      rm -f "$TMP_FILE"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_one_deleted'
    After 'cleanup_one_deleted'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-03 - skip scenarios'
        It 'T-04-03-02: logs "deleted -> skip" for missing file'
          When run script "$_SCRIPT"
          The status should eq 0
          The output should include "deleted -> skip"
        End

        It 'T-04-03-02: only existing file is linted (deleted file not passed to textlint)'
          When run script "$_SCRIPT"
          The status should eq 0
          The output should include "deleted -> skip"
          The contents of file "$STUB_DIR/calls.log" should include "$TMP_FILE"
          The contents of file "$STUB_DIR/calls.log" should not include "$DELETED_FILE"
        End
      End
    End
  End

  Describe 'Given: all files are deleted'
    setup_all_deleted() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR

      printf '#!/bin/sh\nprintf "textlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/textlint"
      printf '#!/bin/sh\nprintf "markdownlint %%s\\n" "$*" >> "%s/calls.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"

      export CHANGED_FILES="/nonexistent/a.md
/nonexistent/b.md"
      export CHANGED_COUNT="2"
    }
    cleanup_all_deleted() {
      rm -rf "$STUB_DIR"
    }
    Before 'setup_all_deleted'
    After 'cleanup_all_deleted'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-03 - all files deleted'
        It 'T-04-03-03: exits with status 0 when all files are deleted'
          When run script "$_SCRIPT"
          The status should eq 0
          The output should include "deleted -> skip"
        End

        It 'T-04-03-03: no linter is called when all files are deleted'
          When run script "$_SCRIPT"
          The status should eq 0
          The output should include "deleted -> skip"
          The file "$STUB_DIR/calls.log" should not be exist
        End
      End
    End
  End

  Describe 'Given: one existing file, textlint exits non-zero'
    setup_textlint_fail() {
      STUB_DIR=$(mktemp -d)
      export STUB_DIR
      TMP_FILE=$(mktemp --suffix=.md)
      printf '# test\n' > "$TMP_FILE"
      export TMP_FILE

      printf '#!/bin/sh\nexit 1\n' > "$STUB_DIR/textlint"
      printf '#!/bin/sh\necho "called" >> "%s/ml.log"\nexit 0\n' "$STUB_DIR" > "$STUB_DIR/markdownlint"
      chmod +x "$STUB_DIR/textlint" "$STUB_DIR/markdownlint"
      export PATH="$STUB_DIR:$PATH"

      export CHANGED_FILES="$TMP_FILE"
      export CHANGED_COUNT="1"
    }
    cleanup_textlint_fail() {
      rm -f "$TMP_FILE"
      rm -rf "$STUB_DIR"
    }
    Before 'setup_textlint_fail'
    After 'cleanup_textlint_fail'

    Describe 'When: lint.sh is executed'
      Describe 'Then: Task T-04-02 - fail-fast behavior'
        It 'T-04-02-01: exits with non-zero status when textlint fails'
          When run script "$_SCRIPT"
          The status should not eq 0
        End

        It 'T-04-02-01: markdownlint is not called when textlint fails'
          When run script "$_SCRIPT"
          The status should not eq 0
          The file "$STUB_DIR/ml.log" should not be exist
        End
      End
    End
  End

End
