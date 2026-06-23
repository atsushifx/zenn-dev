#shellcheck shell=sh
# .github/workflows/scripts/__tests__/unit/ci_lint_articles_yaml.spec.sh
# @(#) : ShellSpec unit tests for .github/workflows/ci-lint-articles.yaml structure
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# ─── Internal Helpers ──────────────────────────────────────────────────────────

_YAML="${SHELLSPEC_PROJECT_ROOT}/.github/workflows/ci-lint-articles.yaml"

Describe 'ci-lint-articles.yaml'
  Describe 'Given: the workflow YAML file exists'
    Describe 'When: the steps list is inspected'
      Describe 'Then: Task T-00-01 - YAML workflow structure'
        It 'T-00-01-01: has 6 steps in correct order'
          When run bash -c "yq '.jobs.lint-on-github.steps[].id' \"$_YAML\" | tr '\n' ' ' | grep -qE '^checkout validate-env resolve-sha changed-files setup-repo lint[[:space:]]*\$' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-01-02: checkout step has persist-credentials: false'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"checkout\") | .with[\"persist-credentials\"]' \"$_YAML\" | grep -qx 'false' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-01-03a: changed-files step has skip propagation if condition'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"changed-files\") | .if' \"$_YAML\" | grep -qF \"steps.resolve-sha.outputs.skip != 'true'\" && echo ok"
          The output should equal "ok"
        End

        It 'T-00-01-03b: setup-repo step has skip propagation if condition'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"setup-repo\") | .if' \"$_YAML\" | grep -qF \"steps.resolve-sha.outputs.skip != 'true'\" && echo ok"
          The output should equal "ok"
        End

        It 'T-00-01-03c: lint step has skip propagation if condition'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"lint\") | .if' \"$_YAML\" | grep -qF \"steps.resolve-sha.outputs.skip != 'true'\" && echo ok"
          The output should equal "ok"
        End
      End

      Describe 'Then: Task T-00-02 - Action SHA pinning'
        It 'T-00-02-01: actions/checkout is pinned to commit SHA df4cb1c'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"checkout\") | .uses' \"$_YAML\" | grep -qF 'actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-02-02: ca-validate-environment is pinned to commit SHA f4e8d97'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"validate-env\") | .uses' \"$_YAML\" | grep -qF 'ca-validate-environment@f4e8d971ee9093901df0255154e643fd1f2ee10d' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-02-03: ca-get-changed-files is pinned to commit SHA f4e8d97'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"changed-files\") | .uses' \"$_YAML\" | grep -qF 'ca-get-changed-files@f4e8d971ee9093901df0255154e643fd1f2ee10d' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-02-04: ca-setup-repo is pinned to commit SHA f4e8d97'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"setup-repo\") | .uses' \"$_YAML\" | grep -qF 'ca-setup-repo@f4e8d971ee9093901df0255154e643fd1f2ee10d' && echo ok"
          The output should equal "ok"
        End

        It 'T-00-02-05: setup-repo with.ref is pinned to commit SHA bec772f'
          When run bash -c "yq '.jobs.lint-on-github.steps[] | select(.id == \"setup-repo\") | .with.ref' \"$_YAML\" | grep -qF 'bec772fc1d22fbf43fd57ef3a71f7972b83b3e24' && echo ok"
          The output should equal "ok"
        End
      End
    End
  End
End
