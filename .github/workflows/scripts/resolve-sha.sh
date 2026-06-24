#!/usr/bin/env bash
# scripts/resolve-sha.sh
# @(#) : Resolve BEFORE_SHA and AFTER_SHA for GitHub Actions
#
# Copyright (c) 2026- atsushifx <https://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

set -euo pipefail

if [ "${EVENT_NAME:-}" = "workflow_dispatch" ]; then
  _parents=$(git rev-list --parents -n 5 HEAD)
  _field_count=$(echo "$_parents" | wc -w)

  if [ "$_field_count" -ge 2 ]; then
    _after_sha=$(echo "$_parents"  | head -n 1 | cut -d' ' -f1)
    _before_sha=$(echo "$_parents" | tail -n 1 | cut -d' ' -f1)
    echo "BEFORE_SHA=${_before_sha}" >>"${GITHUB_ENV}"
    echo "AFTER_SHA=${_after_sha}" >>"${GITHUB_ENV}"
    echo "skip=false" >>"${GITHUB_OUTPUT}"
  else
    echo "::warning::No parent commit found. Skipping lint." >&2
    echo "skip=true" >>"${GITHUB_OUTPUT}"
    exit 0
  fi
else  # other events: PUSH, PullRequest
  echo "BEFORE_SHA=" >>"${GITHUB_ENV}"
  echo "AFTER_SHA=" >>"${GITHUB_ENV}"
  echo "skip=false" >>"${GITHUB_OUTPUT}"
fi
