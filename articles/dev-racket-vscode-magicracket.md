---
title: "Racket: `Racket LSP`を使って`Visual Studio Code`にRacketプログラミング環境を構築する方法"
emoji: "🎾"
type: "tech"
topics: [ "VSCode", "開発環境", "環境構築", "Racket",  "MagicRacket" ]
published: false
---

## tl;dr

- `racket-langserver`をインストール
- `VS Code`に`Magic Racket`をインストール
- 'Magic Racket`の設定

以上で、`VS Code`で Racket 用 LSP が使えるようになります。
いかで、詳細な手順を解説します。

## 1. はじめに

`Visual Studio Code`には、LSP[^1](Language Server Protocol)に対応した各種拡張が提供されています。
Racket言語には、`Magic Racket`という`Racket LSP`クライアントが提供されています。

Racket言語サーバーと`Magic Racket`を組み合わせることで、効率的な Racket プログラミング環境を構築できます。

[^1]LSP: 各種プログラミング言語に依存しないで、プログラミングをサポートする機能を提供するための共通のインターフェイスプロトコル。

### 1.1. LSPとは

LSP (Language Server Protocol) は、プログラミングの効率アップのための共通のインターフェイスです。
プログラミングをサポートする機能には、コードの補完、構文のポップアップ表示、シンタックスハイライトなどがあります。
LSP は、これらの機能をプログラミング言語に依存しないプロトコルとして定義します。
そして、LSP に対応したエディタならどのエディタでも、上記のサポート機能が使えます。

たとえば、この記事では `Racket LSP`+`Visual Studio Code`での使用を説明していますが、`Vim`/`Neovim` エディタでも同様のことができます。

### 1.2. `racket-langserver`とは

`racket-langserver`[^2]は Racket 用の LSP言語サーバーです。`racket-langserver`を利用することで、Racket プログラミング時にコード補完や高度なコードシンタックスチェックなどのプログラミングサポートを行います。

[^2]:`racket-langserver`: Racket言語に対応した LSP の実装。Racket のプログラミングをサポートするさまざまな機能を提供する。

### 1.3. `Magic Racket`とは

`Magic Racket`[^3]は、`Visual Studio Code`用の`Racket LSP`クライアント拡張です。
Racket言語サーバー (例:`racket-langserver`) と連携して、プログラミングをサポートするさまざまな機能を提供します。

また、`REPL`[^4]をサポートしており選択した`式`やファイルをインタープリターで実行できます。

[^3]:`Magic Racket`:`Visual Studio Code`用の`Racket LSP`クライアント。Racket プログラミング時に、`Racket LSP`サーバーと連携してプログラミングをサポートする機能を提供する。
[^4]:｀`REPL` (`Read`-`Eval`-`Print`-`Loop`): 対話的なプログラミングインターフェイスで、入力したプログラムを実際に評価して返す。Racket で実行したい式やコードを`REPL`に入力することで、その結果を即座に確認できる。

## 2. `Racket LSP`サーバーのインストール

Racket の LSP サーバー`racket-langserver`はパッケージで提供されています。よって、`raco`で`racket-langserver`をインストールできます。

### 2.1. `raco` による言語サーバーのインストール

次の手順で、`racket-langserver`をインストールします。

1. `raco`コマンドの実行:
   以下のコマンドを実行する

   ```powershell
   raco pkg install --auto racket-langserver
   ```

2. `racket-langserver`のインストール:
   コンソールに下記のメッセージが表示される。

  ```powershell
  Resolving "racket-langserver" via https://download.racket-lang.org/releases/8.9/catalog/
  Resolving "racket-langserver" via https://pkgs.racket-lang.org
   .
   .
   
  ```

上記のメッセージが表示され、コマンドラインに戻れば`racket-langserver`のインストールは完了です。

### 2.2. "`racket-langserver`"の実行

ここでは、`racket-langserver`を起動し、LSP コマンドを入力して動作を確認します。

1. `racket-langserver`の起動:
    次のコマンドを実行し、`racket-langserver`を起動する

    ```powershell
    racket --lib racket-langserver
    ```

2. `LSP`コマンドの実行:
   `racket-langserver`がコマンドの入力待ちになるので、適当な `LSP`コマンドを入力して`Ctrl+Z`キーで入力を終了する

   ```powershell
   content-length: 24
   
   { "method": "version" }
   #<EOF> ← `Ctrl+Z`キーで"<EOF>"を入力
   ```

3. エラーメッセージの確認:
   上記のコマンドの実行結果として、いかのようなエラーメッセージが出ることを確認する

   ```powershell
   jsexpr->string: expected argument of type <legal JSON value>; given: #<eof>
   context...:
    .
    .
   ```

上記のようにエラーメッセージが出力されれば、言語サーバーは正常に動作しています。

## 3. `Racket LSP`クライアントのインストール

`VS Code`に’Racket LSP`のクライアントである`Magic Racket 拡張`をインストールします。
これにより、`VS Code`で Racket言語サーバーのさまざまな機能が使えます。

### 3.1. `Magic Racket`とは

`Magic Racket`は、`Visual Studio Code`用の"Racket LSP"クライアントで、以下の機能を提供します:

- LSP によるエラー表示とエラー修正のサポート
- 定義部へのジャンプと定義の参照
- 変数のホバー情報表示
- コードの補完
- コードの自動成形

また、`REPL`をサポートしていて選択した式やファイルを`REPL`で実行できるので、迅速なプログラムのテストや実行が可能です。

### 3.2. `Magic Racket`のインストール

次の手順で、`Magic Racket`拡張をインストールします。

1. 拡張機能の選択:
   `VS Code`で`拡張機能`を選択する
   [![拡張機能](https://i.imgur.com/4JIrBTs.png)](https://imgur.com/4JIrBTs)

2. 'Magic Racket`の検索:
   検索ウィンドウに`Magic Racket`と入力し、`Magic Racket`を探す
   [![Magic Racket](https://i.imgur.com/DV1cXLQ.png)](https://imgur.com/DV1cXLQ)

3. `Magic Racket`のインストール:
  \[インストール\]をクリックして、`Magic Racket`をインストールする
  [![インストール](https://i.imgur.com/sjIih4s.png)](https://imgur.com/sjIih4s)

以上で、`Magic Racket`のインストールは完了です。

### 3.3. `Magic Racket`の設定

`Magic Racket`では、Racket の実行時パス、言語サーバーを実行するための引数などを設定できます。
ただし、`racket-langserver`が正常に動作していれば、設定の変更は必要ありません。

## さいごに

以上で、`Visual Studio Code`+`Racket LSP`による Racket開発環境が構築できました。
`Magic Racket`を導入することで、プログラミングのサポートがさらに強化され、効率的な Racket プログラミングが可能となります。

これからも、Racket でのプログラミングを通じて自身の能力を向上させましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver)
- [`Magic Racket`](https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket)
