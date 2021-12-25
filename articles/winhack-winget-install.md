---
title: "Windows: winget: wingetをインストールする"
emoji: "🪆"
type: "tech"
topics: [Windows, 環境構築, SCM, winget, パッケージマネージャ, CLI ]
published: true

---

## tl;dr

`winget`は、2021年に安定版となりました。Windows 11 では、はじめから使えるようになっています。
winget 経由での winget のバージョンアップはまだできません。この記事では、手動で`winget`をインストールします。

## はじめに

`winget`は`Windows`のコマンドライン、いわゆる CLI で実行するアプリインストーラです。
`Windows Terminal`上で`winget install <パッケージ>`とすることで、簡単にアプリをインストールできます。

### `winget`のインストール

`winget`は、Microsoft のアプリ インストーラー~(`Microsoft.DesktopAppInstaller`)~に含まれています。
アプリインストーラは Microsoft ストアで提供されているので、ストア経由でアプリインストーラーをインストールします。

次の手順で、`アプリ インストーラー`をインストールします。

1. Microsoft ストアへのアクセス
   Microsoft ストアを開きます。

   ![Microsoftストア](https://i.imgur.com/A2IURwg.jpg)

2. アプリの検索
   検索窓に'アプリインストーラー'と入力して、検索します。

   ![Microsoftストア](https://i.imgur.com/EYErtsw.jpg)

3. アプリのインストール
  [入手]をクリックし、`アプリ インストーラー`をインストールします。

   ![Microsoftストア](https://i.imgur.com/VJOOa95.jpg)

以上で、`アプリ インストーラー`のインストールは終了です。
これで、コマンドラインツール`winget`も使えます。
