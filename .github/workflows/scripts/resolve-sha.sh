#!/usr/bin/env bash
# scripts/resolve-sha.sh
# @(#) : Resolve before_sha and after_sha outputs for GitHub Actions
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

set -euo pipefail

case "${EVENT_NAME:-}" in
push | pull_request)
  # Leave both SHAs empty and let ca-get-changed-files resolve the range itself.
  {
    echo "before_sha="
    echo "after_sha="
    echo "skip=false"
  } >>"${GITHUB_OUTPUT}"
  ;;
*) # any other event (workflow_dispatch, schedule, release, ...): resolve the range here
  # "<commit> <parent>..." for HEAD only: field 1 is HEAD, field 2 is its first parent.
  # A commit with no visible parent yields a single field.
  _parents=$(git rev-list --parents -n 1 HEAD)
  _head_line=$(echo "$_parents" | head -n 1)
  _field_count=$(echo "$_head_line" | wc -w)

  if [ "$_field_count" -ge 2 ]; then
    _after_sha=$(echo "$_head_line" | cut -d' ' -f1)
    _before_sha=$(echo "$_head_line" | cut -d' ' -f2)
    {
      echo "before_sha=${_before_sha}"
      echo "after_sha=${_after_sha}"
      echo "skip=false"
    } >>"${GITHUB_OUTPUT}"
  elif [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    # The parent exists upstream but was never fetched. Skipping here would let
    # the lint silently pass, so fail instead.
    echo "::error::Shallow clone: cannot resolve the parent commit. Fetch more history." >&2
    exit 1
  else
    echo "::warning::No parent commit found. Skipping lint." >&2
    echo "skip=true" >>"${GITHUB_OUTPUT}"
    exit 0
  fi
  ;;
esac
