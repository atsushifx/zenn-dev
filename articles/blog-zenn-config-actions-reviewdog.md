---
title: "Zenn: 既存の記事をレビューしないようにGitHub Actionsを修正する"
emoji: "🐙"
type: "tech"
topics: [ "zenn", "githubactions", "review", "lint", "CI" ]
published: false
---

## はじめに

`atsushifx`です。
[Zennの記事をGitHub連携でカッチリ管理するおすすめ設定](https://zenn.dev/jonghyo/articles/zenn-github-repo) は、大変役に立ちました。

上記の`GitHub Actions`を参考にして、既存の記事はレビュー対象外となるように修正しました。
この記事では、修正内容を説明します。

## 技術用語

この記事で扱う技術用語の一覧です。

- `[Zenn](https://zenn.dev/)`:
  技術記事や技術書を公開できる技術ブログプラットフォーム。

- `GitHub Actions`:
  `GitHub`上のリポジトリで、イベントに応じて自動ワークフローを実行できる `CI/CD` 機能。

- `pnpm`:
  `Node.js`のパッケージマネージャー`npm`の代替となる、高速なパッケージマネージャー。

- `lint`:
  ソースコードや文章中の文法、スタイル違反を検出し、指摘する静的解析ツールの総称。

- `textlint`:
  `Markdown`、テキストの文法、表記の誤りを校正するツール。

- `markdownlint`:
  `Markdown`ファイルにおいて`Markdown`の書式、スタイルのルール違反を指摘するツール。

## 前提条件

作成した`GitHub Actions`は、以下の条件で動かすことを前提にしています:

- デフォルトブランチを`main`にする。
- `パッケージマネージャー`に`pnpm`を使用する。

以上です。

## `GitHub Actions`

元記事にある`github/workflows/lint.yml`を修正し、変更された記事のみレビュー対象となるようにしました。

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=reviewdog.yaml)

主な変更点は、次のとおりです。

1. 手動でも、このワークフロー (`reviewdog`) を実行可能にする。

2. step: `Get changed files`:
   現ブランチと`main`ブランチ間で変更された、`Markdown`ファイルの一覧を取得する。
   `Fetch main repository`ステップで`main`ブランチをフェッチし、一覧が取得できるようにする。

3. step: `Setup pnpm`:
   パッケージマネージャー`pnpm`をセットアップして、`GitHub Actions`内で利用できるようにする。

4. step: `Install linters`
   `./bin/install_linter.sh`スクリプトを実行し、`lint`に必要なツールおよびルールをインストールする。

## install_linter.sh

`textlint`, `markdownlint`などの各種`lint`ツールをグローバルにインストールしています。
そのため、`package.json`にこれらのツールの依存関係が保存されません。
`install_linter.sh`スクリプトで上記の`lint`ツールをインストールします:

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=install_linter.sh)

`textlint`で使用するルールモジュールは、上記スクリプトの`packages`変数で設定します。

## おわりに

記事をレビューする`GitHub Actions`の修正点を簡単にまとめました。
各種`lint`ツールの設定は [atsushifx/zenn-dev](https://github.com/atsushifx/zenn-dev) に掲載しています。
参考になると幸いです。

それでは、Happy Hacking!
