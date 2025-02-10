---
title: "Zenn: 既存の記事をレビューしないようにGitHub Actionsを修正する"
emoji: "🐙"
type: "tech"
topics: [ "zenn", "githubactions", "review", "lint", "CI" ]
published: true
---

## はじめに

`atsushifx`です。
[Zennの記事をGitHub連携でカッチリ管理するおすすめ設定](https://zenn.dev/jonghyo/articles/zenn-github-repo) は、大変参考になりました。

参考記事の`GitHub Actions`をもとに、既存の記事をレビュー対象外とするように修正しました。
この記事では、修正内容を説明します。

## 技術用語

この記事で使用する主要な技術用語について説明します。

- [`Zenn`](https://zenn.dev/):
  技術記事や技術書を公開できる技術ブログプラットフォーム。

- `GitHub Actions`:
  `GitHub`上のリポジトリで、イベントに応じて自動ワークフローを実行できる `CI/CD` 機能。

- `pnpm`:
  `Node.js` のパッケージマネージャー`npm` の代替となる、高速なパッケージマネージャー。

- `lint`:
  ソースコードや文章中の文法、スタイル違反を検出し、指摘する静的解析ツールの総称。

- `textlint`:
  `Markdown`、テキストの文法、表記の誤りを校正するツール。

- `markdownlint`:
  `Markdown`ファイルにおいて`Markdown` の書式やスタイルのルール違反を指摘するツール。

## 前提条件

このワークフローは、以下の条件で動作します。

- デフォルトブランチを`main`にする。
- パッケージマネージャーとして`pnpm`を使用する。

## `GitHub Actions`

元記事にある `github/workflows/lint.yml` を修正し、変更された記事のみレビュー対象となるようにしました。

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=reviewdog.yaml)

主な変更点は、次のとおりです。

1. このワークフロー (`reviewdog`) を手動でも実行できるようにする。

2. step: `Get changed files`
   現在のブランチと`main`ブランチを比較して変更があった`Markdown` ファイルの一覧を取得する。
   `Fetch main repository`ステップで`main`ブランチをフェッチし、一覧が取得できるようにする。

3. step: `Setup pnpm`
   パッケージマネージャー`pnpm`をセットアップして、`GitHub Actions` 環境で利用できるようにする。

4. step: `Install linters`
   `./bin/install_linter.sh`スクリプトを実行し、`lint`に必要なツールおよびルールをインストールする。

## install_linter.sh

`textlint`, `markdownlint`などの各種`lint`ツールをグローバルにインストールしています。
これらのツールの依存関係は、`package.json` に保存されません。
そのため、`install_linter.sh`スクリプトを実行して、必要な `lint`ツールをインストールします。

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=install_linter.sh)

`textlint`で使用するルールモジュールは、上記スクリプトの`packages`変数に設定されています。

## おわりに

記事をレビューする`GitHub Actions`の修正点を簡単にまとめました。
各種`lint`ツールの設定は [atsushifx/zenn-dev](https://github.com/atsushifx/zenn-dev) にて公開しています。
参考になると幸いです。

それでは、Happy Hacking!
