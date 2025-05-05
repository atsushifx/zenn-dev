<#
  .SYNOPSIS
    initialize textlint & markdownlint

  .DESCRIPTION
    initialize textlint & markdownlint
      this is
      install textlint & textllint rules,
      install markdownlint (cli2)

  .NOTES
    @Author   Furukawa, Atsushi <atsushifx@aglabo.com>
    @License  MIT License https://opensource.org/licenses/MIT

    @Since    2025-02-07
    @Version  1.0.0


  .LICENSE
  This project is licensed under the MIT License, see LICENSE for details
#>

$packages = @(
    "textlint",
    "textlint-filter-rule-allowlist",
    "textlint-filter-rule-comments",
    "textlint-rule-preset-ja-technical-writing",
    "textlint-rule-preset-ja-spacing",
    "textlint-rule-ja-no-orthographic-variants",
    "@textlint-ja/textlint-rule-no-synonyms",
    "sudachi-synonyms-dictionary",
    "@textlint-ja/textlint-rule-morpheme-match",
    "textlint-rule-ja-hiraku",
    "textlint-rule-no-mixed-zenkaku-and-hankaku-alphabet",
    "textlint-rule-common-misspellings",
    "@proofdict/textlint-rule-proofdict",
    "textlint-rule-prh",
    "markdownlint-cli2"
) | Join-String -Separator " "

$command = "pnpm add --global " + $packages
Invoke-Expression $command
