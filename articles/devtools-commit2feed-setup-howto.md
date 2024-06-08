---
title: "Commit2Feed: GitHubページにRSSフィードを設定する"
emoji: "🔔"
type: "tech"
topics: [ "githubaction", "githubpage", "commit2feed", "RSS", ]
published: false
---

## tl;dr

1. `GitHub Pages`をつくる
2. `GitHub Actions`に`code2feed`を組み込む
3. 作成した`RSSフィード`を`GitHub Pages`に組み込む

以上で、リポジトリの更新を`RSS`で発信できます。
Enjoy!

## はじめに

`GitHub`では、各リポジトリのコミット履歴を`RSSフィード`として取得できます。
ただし、表示されるのはコミットログだけで、どのファイルがどう変更されたかは実際のコミットを見る必要があります。

そこで、コミットで変更した部分を`RSSフィード`のサマリーとして出力するカスタム`GitHub Actions`を作りました。
これにより、`RSSフィード`を見ることで、コードの変更がわかるようになります。

## `Commit2Feed`のセットアップ

`Commit2Feed`は、`GitHub Pages`用のカスタムアクションです。
作成した`RSSフィード`を GitHub ページに組み込むことで、アドレスバーに`RSSアイコン`が表示されるようになります。
結果、作成した`RSSフィード`が`Feedly`などの`フィードリーダー`で購読されやすくなります。

このページでは、[Today I Learned](https://github.com/atsushifx/til)リポジトリを例にして、セットアップ方法を解説します。

### `workflow`の設定

`Commit2Feed`カスタムアクションを使用して、`RSSフィード`を作成する`GitHub`ワークフローを作成します。

次の手順で、`RSSフィード`を作成します:

1. `GitHub Workflows`の作成
    リポジトリに`.github/workflows`ディレクトリを作成し、`generate_rss.yml`ファイルを作成します。
    ファイルの中身は、次のようになります。

    @[gist](https://gist.github.com/atsushifx/56d5076d940da8e1a297a568e7a67abd?file=generate_rss.yml)

2. `GitHub workflows`の権限設定
  作成した`RSSフィード`をリポジトリに保存するため、`GitHub Workflow`にリポジトリへの書き込み権限を設定します。

  2.1 権限設定画面へ移動
    リポジトリ画面から、

    - `Settings`メニューを選択し
    - 左の`General`メニューから、`Actions`-`General`を選択します。

  2.2 権限の設定
    下段の`Workflow permissios`画面で、

    - `Read and write permissions`を選択し、
    - `Allow GitHub Actions to create and approve pull requests`をチェックします。
    - `Save`ボタンで設定を保存します。
