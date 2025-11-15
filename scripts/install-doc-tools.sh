#!/usr/bin/env bash
# src: /scripts/install-doc-tools.sh
# @(#) : ドキュメントツールインストールスクリプト
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
# Released under the MIT License.

set -euo pipefail

# Main installation function
main() {
    echo "📦 Installing writer tooling..."

    # Install packages via pnpm
    pnpm add --global \
        textlint \
        textlint-filter-rule-allowlist \
        textlint-filter-rule-comments \
        textlint-rule-preset-ja-technical-writing \
        textlint-rule-preset-ja-spacing \
        textlint-rule-ja-no-orthographic-variants \
        @textlint-ja/textlint-rule-no-synonyms \
        sudachi-synonyms-dictionary \
        @textlint-ja/textlint-rule-morpheme-match \
        textlint-rule-ja-hiraku \
        textlint-rule-no-mixed-zenkaku-and-hankaku-alphabet \
        textlint-rule-common-misspellings \
        @proofdict/textlint-rule-proofdict \
        textlint-rule-prh \
        markdownlint-cli2 \
        cspell

    echo "✅ Writer tooling installation completed."
}

main
