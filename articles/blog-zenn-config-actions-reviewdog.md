---
title: "Zenn: 変更した記事だけレビューするGitHub Action"
emoji: "🐙"
type: "tech"
topics: [ "zenn", "githubactions", "review", "lint", 'CI' ]
published: false
---

## はじめに

`atsushifx`です。
[Zennの記事をGitHub連携でカッチリ管理するおすすめ設定](https://zenn.dev/jonghyo/articles/zenn-github-repo) は、大変役に立ちました。

上記の`GitHub Actions`を参考に、既存の記事のレビューをしないようにした`GitHub Actions`を作成したので、それを説明します。

## 前提条件

作成した`GitHub Actions`は、以下の条件で動かすことを前提にしています:

- デフォルトブランチを`main`にする
- `パッケージマネージャー`に`pnpm`を使用する

以上です。

## `GitHub Actions`

元記事の`github/workflows/lint.yml`を修正して、変更がある記事のみをレビューするようにしました。

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=reviewdog.yaml)

主な変更点は、次の通り:

1. 手動でも、この`Actions`を実行可能に

2. step: `get changed files`:
   現ブランチと`main`ブランチ間で変更された、マークダウンファイルの一覧を取得する。
   `fetch main repository`ステップで`main`ブランチをフェッチし、一覧が取得できるようにする。

3. step: `setup pnpm`:
   パッケージマネージャー`pnpm`をセットアップし、`Actions`内で使用可能にする。

4. step: `Install linters`
   `./bin/installlinter.sh`スクリプトを実行し、`lint`に必要なツールおよびルールをインストールする。

## installlinter.sh

`textlint`, `markdownlint`などの各種`lint`ツールをグローバルにインストールしています。
`package.json`では上記のツールが記録されないため、`installlinter.sh`スクリプトで上記をインストールします:

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=installlinter.sh)

`textlint`で使用するルールモジュールは、上記スクリプトの`packages`で設定します。

## おわりに

以上、記事をレビューする`GitHub Actions`の修正点について、簡単にまとめました。
各種`lint`ツールの設定は [atsushifx/zenn-dev](https://github.com/atsushifx/zenn-dev) に掲載しています。
筆者が実際に使っている設定ですので、参考になるでしょう。

それでは、Happy Hacking!
