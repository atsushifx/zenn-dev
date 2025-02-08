---
title: "Zenn: 変更した記事だけレビューするGitHub Action"
emoji: "🐙"
type: "tech"
topics: [ "zenn", "githubactions", "review", "lint", ]
published: false
---

## はじめに

`atsushifx`です。
[Zennの記事をGitHub連携でカッチリ管理するおすすめ設定](https://zenn.dev/jonghyo/articles/zenn-github-repo)　は大変、役に立ちました。
上記の`GitHub Actions`を参考に、既存の記事のレビューをしないようにした`GitHub Actions`を作成したので、それを説明します。

## 前提条件

作成した`GitHub Actions`は、以下の条件で動かすことを前提にしています:

- デフォルトブランチを`main`にする
- `パッケージマネージャー`に`pnpm`を使用する

以上です。

## `GitHub Actions`

もとの記事の`github/workflows/lint.yml`をもとに、新規/修正された記事のみレビューするように修正しました。

``` .github/workflows/reviewdog.yaml
## @(#) : reviewdog / lint new articles
#
# @version  1.0.0
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @since    2025-02-05
# @license  MIT
#
# @desc<<
#
# lint new articles on GitHub
#
#<<

name: reviewdog

# PR及び手動でAction実行
on:
  pull_request:
    branches: [main]
    paths:
      - '**/*.md'
  workflow_dispatch:

# 実行するAction
jobs:
    lint-on-github:
        name: lint on github
        runs-on: ubuntu-latest

        steps:
          - name: checkout repository
            uses: actions/checkout@v4

          - name: fetch main repository
            run: |
              git fetch origin main

          - name: get changed files
            id: changed
            run: |
              head_sha="$(git rev-parse HEAD)"
              base_sha="$(git rev-parse origin/main)"
              echo "head: ${head_sha}"
              echo "base: ${base_sha}"
              files=$(git diff --name-only ${base_sha} ${head_sha} -- '**/*.md')
              echo "changed: ${files}"
              echo "files=${files}" >> $GITHUB_OUTPUT

          - name: setup node
            uses: actions/setup-node@v4
            with:
              node-version: 20

          - name: setup pnpm
            uses: pnpm/action-setup@v4
            with:
              version: 10

          - name: restore cache
            id: cache-restore
            uses: actions/cache/restore@v4
            with:
              key: ${{ runner.os }}-cache
              path: |
                node_modules
                ~/.pnpm-store
                .textlintcache

          - name: make install script executable
            run: |
              chmod +x ./bin/installlinter.sh

          - name: Install linters
            if: ${{ steps.cache-restore.outputs.cache-hit != 'true' }}
            run: |
              ./bin/installlinter.sh "--save-prod --reporter silent "
              pnpm list

          - name: lint text
            if: ${{ steps.changed.outputs.files != '' }}
            env:
              changed_files: "${{ steps.changed.outputs.files }}"
            run: |
              pnpm run lint:docs "${changed_files}"

          - name: lint markdown
            if: ${{ steps.changed.outputs.files != '' }}
            env:
              changed_files: "${{ steps.changed.outputs.files }}"
            run: |
              pnpm run lint:markdown "${changed_files}"

          - name: Always save cache
            id: cache-save
            uses: actions/cache/save@v4
            with:
              key: ${{ steps.cache-restore.outputs.cache-primary-key }}
              path: |
                node_modules
                ~/.pnpm-store
                .textlintcache
```

主な変更点は、次の通り:

1. 手動でも、この`Actions`を実行可能に

2. step: `get changed files`:
   このステップで、現ブランチと`main`ブランチで変更のあるマークダウンファイルを取得する。
   `main`ブランチも必要なため、`fetch main repository`ステップで`main`ブランチをフェッチ

3. step: `setup pnpm`:
   パッケージマネージャー`pnpm`をセットアップ、`Actions`内で使用可能に

4. step: `Install linters`
   `textlint`、`markdoownlin`および`lint`用のルールをインストール。
   インストール自体は`./bin/installlinter.sh`で行なう。

## installlinter.sh

自分の環境では、`textlint`などの各種`lint`コマンドはグローバルにインストールしています。
`package.json`では、インストールされた`linter`およびルールモジュールがわからないのでスクリプトでインストールしています。

``` ./bin/installlinter.sh:bash
#!/usr/bin/env bash
#
# @(#) : common environ settings
#
# @version  1.0.1
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @since    2024-02-06
# @license  MIT
#
# @desc<<
#
# install script: textlint & rules, markdownlint
#
#<<

### initialize
set -euC -o pipefail

## initialize variables
# default option
declare -a default_options=(
    "--global"
    "--save-dev"
)

# install packages
declare -a packages=(
    "textlint"
    "textlint-filter-rule-allowlist"
    "textlint-filter-rule-comments"
    "textlint-rule-preset-ja-technical-writing"
    "textlint-rule-preset-ja-spacing"
    "textlint-rule-ja-no-orthographic-variants"
    "@textlint-ja/textlint-rule-no-synonyms"
    "sudachi-synonyms-dictionary"
    "@textlint-ja/textlint-rule-morpheme-match"
    "textlint-rule-ja-hiraku"
    "textlint-rule-no-mixed-zenkaku-and-hankaku-alphabet"
    "textlint-rule-common-misspellings"
    "@proofdict/textlint-rule-proofdict"
    "textlint-rule-prh"
    "markdownlint-cli2"
)

##  main
# オプションの処理
if [ $# -eq 0 ]; then
    options="${default_options[@]}"
else
    options="$@"
fi

## exec
pnpm add $options "${packages[@]}"
```

`textlint`で使用するルールモジュールは、上記スクリプトの`packages`で設定します。

## おわりに

以上、修正した`GitHub Actions`について簡単にまとめました。
`textlint`のルールなど、実際の設定は [atsushifx/zenn-dev](https://github.com/atsushifx/zenn-dev) に載っていますので参考にしてください。

それでは、Happy Hacking!
