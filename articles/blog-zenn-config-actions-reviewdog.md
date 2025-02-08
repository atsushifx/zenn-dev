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

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=reviewdog.yaml)

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

@[gist](https://gist.github.com/atsushifx/e1d23573f4658ad5244e3414ba2877f0?file=installlinter.sh)

`textlint`で使用するルールモジュールは、上記スクリプトの`packages`で設定します。

## おわりに

以上、修正した`GitHub Actions`について簡単にまとめました。
`textlint`のルールなど、実際の設定は [atsushifx/zenn-dev](https://github.com/atsushifx/zenn-dev) に載っていますので参考にしてください。

それでは、Happy Hacking!
