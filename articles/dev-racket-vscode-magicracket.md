---
title: "開発環境: Visual Studio Code+Racket LSPのRacket開発環境を構築する"
emoji: "🎾"
type: "tech" 
topics: [ "VSCode", "開発環境", "環境構築", "Racket",  "MagicRacket" ]
published: false
---

## TL;DR

- `racket-langserver`をインストール
- `Magic Racket`をインストール
- `Magic Racket`を`racket-langserver`用に設定

以上で、`VS Code`で Racket 用 LSP が使えるようになる。
Enjoy!

## 1. はじめに

`Visual Studio Code`には、Racket 用の各種 extension が提供されています。
これらの extension をインストールすれば、`VS Code`で Racket の開発ができます。

とくに、Racket LSP クライアントである`Magic Racket`拡張を入れると、開発の効率が大幅に上がります。

### 1.1. LSPとは

LSP (Language Server Protocol) は、プログラミングの効率アップのための共通のインターフェイスです。
プログラミングをサポートする機能には、変数名などのコードの補完、ヘルプの表示、シンタックスハイライトなどがあります。
LSP は、これらの機能をプログラミング言語に依存しないプロトコルとして定義します。
そして、LSP に対応したエディタならどのエディタでも、上記のサポート機能が使えます。

たとえば、この記事では `Racket LSP`+`Visual Studio Code`での使用を説明していますが、`Vim`/`Neovim` エディタでも同様のことができます。

### 1.2. `racket-langserver`とは

`racket-langserver`は Racket 用の LSP言語サーバーです。`racket-langserver`を利用することで、Racket プログラミング時にコード補完や高度なコードシンタックスチェックが行えます。

## 2. Racket言語サーバーのインストール

Racket の言語サーバー`racket-langserver`はパッケージで提供されています。よって、`raco`で`racket-langserver`をインストールできます。

### 2.1. `raco` による言語サーバーのインストール

次の手順で、`racket-langserver`をインストールします。

1. `raco`コマンドの実行:}
   以下のコマンドを実行する

   ```powershell
   raco pkg install --auto racket-langserver
   ```

2. `racket-langserver`のインストール:
   コンソールにいかのようなメッセージが表示される。

  ```powershell
  Resolving "racket-langserver" via https://download.racket-lang.org/releases/8.9/catalog/
  Resolving "racket-langserver" via https://pkgs.racket-lang.org
   .
   .
   
  ```

上記のメッセージが表示され、コマンドラインに戻れば`racket-langserver`のインストールは完了です。

### 2.2. "Racket言語サーバー"の実行

インストールが完了すれば、Racket言語サーバー (`racket-langserver`)が実行できます。
次の手順で、`racket-langserver`を実行します。

1. `racket-langserver`の起動:
    次のコマンドを実行し、`racket-langserver`を起動する

    ```powershell
    racket --lib racket-langserver
    ```

2. `LSP`コマンドの実行:
   適当な `LSP`コマンドを入力し、`Ctrl+Z`キーで"\<EOF\>"を入力する

   ```powershell
   content-length: 24
   
   { "method": "version" }
   #<EOF> <-- `Ctrl+Z`キーで"<EOF>"を入力
   ```

3. エラーメッセージの確認:
   コマンドの実行結果としてエラーメッセージが出ることを確認する

   ```powershell
   jsexpr->string: expected argument of type <legal JSON value>; given: #<eof>
   context...:
    .
    .
   ```

上記のようにエラーメッセージが出力されれば、言語サーバー派生上に動作しています。

## 2. VS Codeの設定

`VS Code`に`Magic Racket`をいれ、`Racket`プログラミング環境を構築します。

### 2.1. `Magic Racket`とは

`Magic Racket`は、`Visual Studio Code`用の"Racket LSP"クライアントです。
LSP によるエラー表示や定義部へのジャンプなどをサポートしており、プログラミングを効率化します。

また、`REPL` をサポートしており選択した`式`やファイルをインタープリターで実行できます。

### 2.2. `Magic Racket`のインストール

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

## さいごに

以上で、`Visual Studio Code`+`Racket LSP`による Racket開発環境が構築できました。
for 文など、特殊な構文の書き方をポップアップで説明してくれるので、予想以上に使いやすいです。

これで、Racket のプログラミングもはかどるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `racket-langserver`: <https://github.com/jeapostrophe/racket-langserver>
- `Magic Racket`: <https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket>
