---
title: "Racket: Visual Studio CodeでのRacket LSPプログラミング環境の構築方法"
emoji: "🎾"
type: "tech"
topics: [ "VSCode", "開発環境", "環境構築", "Racket",  "MagicRacket" ]
published: false
---

## tl;dr

- `racket-langserver`をインストール
- `VS Code`に`Magic Racket`をインストール
- `Magic Racket`の設定

以上で、`VS Code`で `Racket LSP`が使えるようになります。
Enjoy!

## 1. はじめに

この記事では、LSP[^1](Language Server Protocol)を用いて、Racket の効率的なプログラミング環境を構築する手順について説明します。
`Racket`用の LSP である`Racket LSP`と、それを`Visual Studio Code`で使用するための LSP クライアント`Magic Racket`を組み合わせることで  、コード補完やコードの自動整形といったプログラミングサポート機能を利用できます。

[^1]: LSP: 各種プログラミング言語に依存しないで、プログラミングをサポートする機能を提供するための共通のインターフェイスプロトコル。

### 1.1. LSPとは

LSP (Language Server Protocol) は、プログラミング効率向上のための標準的なインターフェイスです。
LSP が提供するプログラミングサポート機能には、コードの補完、構文のポップアップ表示、シンタックスハイライトなどがあります。
LSP は、これらの機能をプログラミング言語に依存しない方式で提供するためのプロトコルとして定義します。
そして、LSP に対応したエディタならば、上記のサポート機能が使えます。

この記事では`Racket LSP`を`Visual Studio Code`で使用する方法を説明していますが、`Vim`や`emacs`のような他のエディタにも LSP クライアントが提供されています。
これらのエディタでも、このようなプログラミングサポート機能が利用できます。

### 1.2. `racket-langserver`とは

`racket-langserver`[^2]は`Racket`言語専用の LSP です。`racket-langserver`は、Racket プログラミング時にコード補完やコードシンタックスチェックなどのプログラミングサポートを提供します。

[^2]:`racket-langserver`: Racket 用の LSP。これにより、コード補完やシンタックスチェックなどのプログラミングサポートが可能になる。

### 1.3. `Magic Racket`とは

`Magic Racket`[^3]は、`Visual Studio Code`に対応する`Racket LSP`クライアントクライアントとしての役割を持つ拡張機能 (`extension`) です。
`Racket LSP` (`racket-langserver`) と連携して、プログラミングをサポートするさまざまな機能を提供します。
`REPL`[^4]のサポートもあるため、選択した式やファイルを直接実行できます。

[^3]:`Magic Racket`:`Visual Studio Code`用の`Racket LSP`クライアント。Racket プログラミング時に、`Racket LSP`サーバーと連携してプログラミングをサポートする機能を提供する。
[^4]:`REPL` (`Read`-`Eval`-`Print`-`Loop`): 対話的なプログラミングインターフェイスで、入力したプログラムを実際に評価して返す。Racket で実行したい式やコードを`REPL`に入力することで、その結果を即座に確認できる。

## 2. `Racket LSP`サーバーのインストール

Racket の LSP サーバー`racket-langserver`はパッケージで提供されています。これは、`raco`[^5]というツールを使ってインストールします。

[^5]:`raco`: Racket言語の開発支援ツール。パッケージ管理やプログラムのコンパイル／テストなどを行なう。

### 2.1. `raco` による`Racket LSP`のインストール

以下のコマンドを使って`racket-langserver`をインストールします。

1. `raco pkg`コマンドの実行:
   以下の`raco pkg`コマンドを実行し、パッケージをインストールする

   ```powershell
   raco pkg install --auto racket-langserver
   ```

コマンドラインに戻れば`racket-langserver`のインストールは完了です。

### 2.2. "`racket-langserver`"の実行

`racket-langserver`を起動し、LSP コマンドを入力して正常に動作しているか確認します。

1. `racket-langserver`の起動:
    次のコマンドを実行し、`racket-langserver`を起動する

    ```powershell
    racket --lib racket-langserver
    ```

2. `LSP`コマンドの実行:
   `racket-langserver`が起動して、コマンドの入力を待つ状態になったら、任意の`LSP`コマンドを入力して`Ctrl+Z`キーで入力を終了する

   ```powershell
   content-length: 24
   
   { "method": "version" }
   #<EOF> ← `Ctrl+Z`キーで"<EOF>"を入力
   ```

3. エラーメッセージの確認:
   上記のコマンドの実行結果として、下記のようなエラーメッセージが出ることを確認する

   ```powershell
   jsexpr->string: expected argument of type <legal JSON value>; given: #<eof>
   context...:
    .
    .
   ```

上記のようなエラーメッセージが出力された場合、これは言語サーバーが正常に動作していることを示しています。

## 3. `Racket LSP`クライアントのインストール

次に、`VS Code`に`Racket LSP`のクライアントである`Magic Racket extension`をインストールします。
これにより、`VS Code` で `Racket LSP`のさまざまな機能が利用できます。

### 3.1. `Magic Racket`のインストール

次の手順で、`Magic Racket extension`をインストールします。

1. 拡張機能の選択:
   `VS Code`の左側のメニューから`拡張機能`を選択する
   [![拡張機能](https://i.imgur.com/4JIrBTs.png)](https://imgur.com/4JIrBTs)

2. 'Magic Racket`の検索:
   検索ウィンドウに`Magic Racket`と入力して、該当の拡張機能を検索する
   [![Magic Racket](https://i.imgur.com/DV1cXLQ.png)](https://imgur.com/DV1cXLQ)

3. `Magic Racket`のインストール:
  \[`インストール`\]をクリックして、`Magic Racket`をインストールする
  [![インストール](https://i.imgur.com/sjIih4s.png)](https://imgur.com/sjIih4s)

以上の手順で、`Magic Racket`のインストールは完了です。

### 3.2. `Magic Racket`の設定

`Magic Racket`では、Racket の実行パス、言語サーバーを実行するための引数などを設定できます。
ただし、`racket-langserver`が正常に動作していれば、設定の変更は必要ありません。

`Magic Racket`の設定方法は、次の通りです。

1. `VS Code`の左側のメニューから`拡張機能`を選択する:
   ![拡張機能](https://i.imgur.com/4JIrBTs.png)

2. `Magic Racket`を選択する:
   ![インストール](https://i.imgur.com/sjIih4s.png)

3. \[拡張機能の設定\]を選択して設定ウィンドウを開く:
   ![設定](https://i.imgur.com/V3zShBh.png)

4. 必要に応じて、各種項目を設定する:

以上で、設定の変更は完了です。

## さいごに

以上で、`Visual Studio Code`+`Racket LSP`による Racket開発環境が構築できました。
`Magic Racket`を導入することで、プログラミングのサポートがさらに強化され、効率的な Racket プログラミングが可能となります。

これからは、Racket LSP を活用して、より効率的なプログラミングを行なうことができます。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Language Server Protocol Specification](https://github.com/tennashi/lsp_spec_ja)
- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver)
- [`Magic Racket`](https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket)
