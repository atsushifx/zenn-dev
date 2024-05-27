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

### `GitHub Pages`の作成

[TIL](https://github.com/atsushifx/til)のページを作成します。
プロジェクトルートに`/docs`ディレクトリを作成し、そこにファイル`index.md`を作成します。

次に、以下の手順で`GitHub Pages`を作成します。

1. `GitHub Pages`メニューを表示する
   リポジトリメニューから\[Settings]をクリックし、そのあと左サイドメニューの\[Pages\]をクリックします。
   [GitHub Pages](https://github.com/atsushifx/til/settings/pages)画面が表示されます。

2. 表示するブランチを設定する
   \[Build and deployment]で、ブランチ`main`、フォルダー`/docs`を選択して\[`save`]します。

3. Page が作成される
   [TILのページ](https://atsushifx.github.io/til/)が作成されます。
   `TOPページ`は、`index.md`のマークダウンとなります。

