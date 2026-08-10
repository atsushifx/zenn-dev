#shellcheck shell=sh
# runners/__tests__/unit/run-shellspec.unit.spec.sh
# @(#) : ShellSpec unit tests for runners/run-shellspec.sh
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# ─── Internal Helpers ──────────────────────────────────────────────────────────

_SCRIPT="${SHELLSPEC_PROJECT_ROOT}/runners/run-shellspec.sh"

# resolve_spec_files is exercised by sourcing run-shellspec.sh rather than by
# running it. Two reasons:
#
#   1. Recursion. This spec file lives under __tests__/unit/, so it is itself
#      part of the "unit" and "all" sets. Invoking `run-shellspec.sh unit` from
#      here would rediscover and re-run this very file, without bound.
#   2. Cost. The type-resolution paths never need shellspec to actually launch;
#      only the resolved file list and the exit status are under test.
#
# run-shellspec.sh guards its main() behind a BASH_SOURCE check, so sourcing it
# defines the functions without running anything. `set -euo pipefail` leaks in
# from that source, so every helper below runs in a subshell and relaxes it;
# otherwise a deliberately failing call would abort shellspec's own shell.

# Runs resolve_spec_files against an isolated fixture tree.
# The real repository is not used as the search root: its spec inventory shifts
# as files are added (this file included), which would make any assertion here
# drift. SPEC_SEARCH_ROOT is read at source time, hence it is set beforehand.
resolve_in_fixture() {
  (
    SPEC_SEARCH_ROOT="$FIXTURE_ROOT"
    export SPEC_SEARCH_ROOT
    # shellcheck disable=SC1090
    . "$_SCRIPT"
    set +eu
    resolve_spec_files "$@"
  )
}

# Reports the integration gate value after resolving the given test type.
# Emits the resulting SKIP_INTEGRATION_TESTS on stdout so it can be asserted.
gate_after_resolve() {
  (
    SPEC_SEARCH_ROOT="$FIXTURE_ROOT"
    SKIP_INTEGRATION_TESTS=1
    export SPEC_SEARCH_ROOT SKIP_INTEGRATION_TESTS
    # shellcheck disable=SC1090
    . "$_SCRIPT"
    set +eu
    resolve_spec_files "$@" >/dev/null 2>&1
    printf '%s\n' "$SKIP_INTEGRATION_TESTS"
  )
}

# Fixture tree: one unit spec, and an empty functional directory so that
# "functional" is a real-but-empty test type rather than a missing one.
setup_fixture() {
  FIXTURE_ROOT=$(mktemp -d)
  export FIXTURE_ROOT
  mkdir -p "$FIXTURE_ROOT/__tests__/unit" "$FIXTURE_ROOT/__tests__/functional"
  printf '#shellcheck shell=sh\nDescribe "fixture"\nEnd\n' \
    > "$FIXTURE_ROOT/__tests__/unit/sample.unit.spec.sh"
}

cleanup_fixture() {
  rm -rf "$FIXTURE_ROOT"
}

Describe 'run-shellspec.sh'
  Describe 'Given: a spec tree containing unit specs but no functional specs'
    Before 'setup_fixture'
    After 'cleanup_fixture'

    Describe 'When: resolve_spec_files is called with a test type that has specs'
      Describe 'Then: Task T-176-01 - a populated test type resolves successfully'
        It 'exits with status 0'
          When call resolve_in_fixture unit
          The status should be success
          The stdout should include 'sample.unit.spec.sh'
        End

        It 'lists the discovered spec file on stdout'
          When call resolve_in_fixture unit
          The stdout should include '__tests__/unit/sample.unit.spec.sh'
        End
      End
    End

    Describe 'When: resolve_spec_files is called with a test type that has no specs'
      Describe 'Then: Task T-176-02 - an empty test type is an error, not a silent success'
        It 'exits with non-zero status'
          When call resolve_in_fixture functional
          The status should be failure
          The stderr should be present
        End

        It 'names the offending test type on stderr'
          When call resolve_in_fixture functional
          The status should be failure
          The stderr should include "No spec files found for test type 'functional'"
        End

        It 'resolves no spec files on stdout'
          When call resolve_in_fixture functional
          The status should be failure
          The stderr should be present
          The stdout should equal ''
        End
      End
    End

    Describe 'When: resolve_spec_files is called with an unknown test type'
      Describe 'Then: Task T-176-03 - a mistyped test type is rejected'
        It 'exits with non-zero status'
          When call resolve_in_fixture unti
          The status should be failure
          The stdout should be present
        End

        # The unknown-argument message is printed without a >&2 redirect, so at
        # function level it lands on stdout; main() is what routes it to stderr.
        It 'reports the unknown argument'
          When call resolve_in_fixture unti
          The status should be failure
          The stdout should include "Unknown argument 'unti'"
        End
      End
    End

    Describe 'When: resolve_spec_files is called with a glob matching no files'
      Describe 'Then: Task T-176-04 - an unmatched glob is an error'
        It 'exits with non-zero status'
          When call resolve_in_fixture './no/such/__tests__/unit/*.spec.sh'
          The status should be failure
          The stderr should be present
        End

        It 'names the offending pattern on stderr'
          When call resolve_in_fixture './no/such/__tests__/unit/*.spec.sh'
          The status should be failure
          The stderr should include 'No spec files found matching glob'
        End
      End
    End

    Describe 'When: resolve_spec_files is called with a glob matching real files'
      Describe 'Then: Task T-176-05 - a matching glob resolves successfully'
        It 'exits with status 0 and lists the matched spec'
          When call resolve_in_fixture '__tests__/unit/*.spec.sh'
          The status should be success
          The stdout should include 'sample.unit.spec.sh'
        End
      End
    End

    # Regression guard: this case set once narrowed to "system" alone. All three
    # gate-opening types are asserted separately so that losing any one of them
    # fails on its own line.
    Describe 'When: resolve_spec_files is called with a type that opens the integration gate'
      Describe 'Then: Task T-176-06 - integration, system and all clear SKIP_INTEGRATION_TESTS'
        It 'clears the gate for the integration type'
          When call gate_after_resolve integration
          The stdout should equal '0'
        End

        It 'clears the gate for the system type'
          When call gate_after_resolve system
          The stdout should equal '0'
        End

        It 'clears the gate for the all type'
          When call gate_after_resolve all
          The stdout should equal '0'
        End
      End
    End

    Describe 'When: resolve_spec_files is called with a type outside the integration gate'
      Describe 'Then: Task T-176-07 - unit leaves SKIP_INTEGRATION_TESTS closed'
        It 'leaves the gate closed for the unit type'
          When call gate_after_resolve unit
          The stdout should equal '1'
        End
      End
    End
  End

  # These two paths exit inside main() before shellspec is ever launched, so
  # running the script directly is cheap and cannot recurse into this spec.
  Describe 'Given: the runner is invoked with no spec selection'
    Describe 'When: the script is run without arguments'
      Describe 'Then: Task T-176-08 - a bare invocation is rejected'
        It 'exits with non-zero status'
          When run script "$_SCRIPT"
          The status should be failure
          The stderr should be present
        End

        It 'prints usage to stderr'
          When run script "$_SCRIPT"
          The status should be failure
          The stderr should include 'Usage: run-shellspec.sh'
        End
      End
    End

    Describe 'When: the script is run with only an option and no test selection'
      Describe 'Then: Task T-176-09 - an options-only invocation is rejected'
        It 'exits with non-zero status'
          When run script "$_SCRIPT" --integration
          The status should be failure
          The stderr should be present
        End

        It 'prints usage to stderr'
          When run script "$_SCRIPT" --integration
          The status should be failure
          The stderr should include 'Usage: run-shellspec.sh'
        End
      End
    End
  End

  Describe 'Given: the runner is pointed at a spec file that does not exist'
    # resolve_spec_files accepts any *.spec.sh argument on suffix alone and does
    # no existence check, so it succeeds here; the failure comes from shellspec
    # rejecting the path further down. This is asserted end-to-end for that
    # reason. Only the status and the stream are checked: shellspec's message is
    # emitted with --color, so its text is ANSI-wrapped and brittle to match.
    Describe 'When: the script is run with a missing spec path'
      Describe 'Then: Task T-176-10 - a missing spec file fails the run'
        It 'exits with non-zero status'
          When run script "$_SCRIPT" './no/such/file.spec.sh'
          The status should be failure
          The stderr should be present
        End
      End
    End
  End
End
