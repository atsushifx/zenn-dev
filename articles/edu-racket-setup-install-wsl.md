---
title: "WSL上に関数型プログラミング言語「Racket」をインストールする"
emoji: "☕"
type: "tech"
topics: [ "WSL", "Racket", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

## Racket のインストール

### `brew` を使用した Racket のインストール

`Homebrew`は、`macOS`/`Linux`に対応したパッケージマネージャーで WSL でも使用できます。
Racket も`brew`のリポジトリに登録されているので、`brew`コマンドでインストールできます。

次のコマンドで、Racket をインストールします:

```bash
brew install racket
```

以上で、Racket のインストールは終了です。

Racket が正常にインストールできたかどうかの確認は、次のようにします。

```bash
$ racket --version
Welcome to Racket v8.11.1 [cs].

$
```

上記のようにバージョンが表示されれば、インストールに成功しています。

### `raco pkg` の設定

Racket では、さまざまなライブラリ、拡張機能をパッケージとして提供しています。






### タブ補完機能の設定




### `XREPL`のインストール


## おわりに
