#!/usr/bin/env bash
#
# @(#) : common environ settings
#
# @version  1.0.0
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @date     2024-02-06
# @license  MIT
#
# @desc<<
# 
# install script: textlint & rules, markdownlint 
#
#<<

pnpm add --global --save-dev \
  textlint \
  textlint-filter-rule-allowlist textlint-filter-rule-comments \
  textlint-rule-preset-ja-technical-writing textlint-rule-preset-ja-spacing \
  textlint-rule-ja-no-orthographic-variants \
  @textlint-ja/textlint-rule-no-synonyms sudachi-synonyms-dictionary \
  @textlint-ja/textlint-rule-morpheme-match \
  textlint-rule-ja-hiraku \
  textlint-rule-no-mixed-zenkaku-and-hankaku-alphabet \
  textlint-rule-common-misspellings \
  @proofdict/textlint-rule-proofdict \
  textlint-rule-prh \
  markdownlint-cli2
