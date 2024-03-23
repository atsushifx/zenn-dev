---
title: "OCaml: OCaml用にVS Codeをセットアップする"
emoji: "🐪"
type: "tech"
topics: [ "OCaml", "VSCode", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

`VSCode` (`Visual Studio Code`)には、さまざまなプログラミング言語用の機能拡張があります。
この記事では、`VSCode`に`OCaml`用の機能拡張を入れて、`OCaml`開発環境を構築します。

## `OCaml`パッケージのインストール

### `Ocaml言語サーバ`のインストール

`VS Code`の`OCaml`拡張は、`lsp` (言語サーバ)を使ってタブ補完やコードフォーマットを行います。
このセクションでは、`OCaml`の`lsp`をインストールします。

次のコマンドで、`OCaml`用`lsp`をインストールします:

```bash
opam install --yes ocaml-lsp-server

```

次のようにして、`lsp`の動作を確認します:

1. `lsp`の起動
    次のコマンドで`lsp`を起動する

    ```bash
    ocamllsp
    ```

2. エラーメッセージの確認
    \[Enter]を入力し、`lsp`がエラーメッセージを出力するか確認する

    ```bash
    # \[Enter]を入力

    /-----------------------------------------------------------------------
    | Internal error: Uncaught exception.
    | Error: content length absent
    ```

    上記のようなエラーメッセージが出力される

3. `lsp`の中止
    \[`Ctrl+C`]を入力し、`lsp`を中止する

    ```bash
    ^C  # [Ctrl+C]を入力

    >
    ```

上記のようにエラーメッセージが出力されれば、`lsp`は正常にインストールされています。

### コードフォーマッタのインストール

`OCaml`のコードフォーマット用に、コードフォーマッタをインストールします。

次のコマンドで、コードフォーマッタをインストールします。

```bash
opam install --yes ocamlformat

```

次のようにして、コードフォーマッタの動作を確認します:

1. フォーマッタ用に`.ocamlformat`を作成する:

    ```bash
    touch .ocamlformat
    ```

2. 適当な`OCaml`プログラムをフォーマッタで整形する:

    ```bash
    ocamlformat --enable-outside-detected-project hello.ml
    (* my first ocaml progrram *)
    print_endline "Hello, OCaml!!"

    ```

    **注意**:
    動作確認用に`OCaml`のプログラムを指定する。`hello.ml`でなくても良い。

上記のように整形されたプログラムが出力されれば、フォーマッタの正常にインストールされています。

## 機能拡張のインストール

### `OCaml Platform`のインストール

`OCaml`のプログラミング用に、`OCaml Platform`をインストールします。

次の手順で、`OCaml Platform`をインストールします:

1. `VS Code`を起動する:

   ```bash
   code .
   ```

2. [拡張機能:マーケートプレイス]を表示する:
  [`Ctrl+Shift+X`]を入力し、[拡張機能:マーケットプレイス]を表示する。

3. [`OCaml Platform`]を検索する:
  上部の入力ウィンドウに`caml`と入力し、[`OCaml Platform`]を検索する。

4. [`OCaml Platform`]をインストールする:
  [インストール]をクリックし、[`OCaml Platform`]をインストールする。

### `Code Runner`のインストール

`Code Runner`は、編集中のプログラムを実行する機能拡張です。
編集するプログラミング言語にあわせて、適当なコマンドを実行します。

次の手順で、[`Code Runner`]をインストールします。

1. `VS Code`を起動する:

   ```bash
   code .
   ```

2. [拡張機能:マーケートプレイス]を表示する:
  [`Ctrl+Shift+X`]を入力し、[拡張機能:マーケットプレイス]を表示する。

3. [`Code Runner`]を検索する:
  上部の入力ウィンドウに`code`と入力し、[`OCaml Platform`]を検索する。

4. [`Code Runner`]をインストールする:
  [インストール]をクリックし、[`Code Runner`]をインストールする。

### \[`Code Runner`]の設定

\[`Code Runner`]を使用するため、設定ファイルに`OCaml`用の設定を追加します。

次の手順で、`OCaml`用の設定を追加します。

1. `VS Code`を起動する:

   ```bash
   code .
   ```

2. 設定ファイルを開く:
  [`Ctrl+Shift+P`]として、\[`Open User Settings (JSON)`]を選び、設定ファイル(`settings.json`)を開く。

3. `OCaml`設定を追加する:
  設定ファイル (`settings.json`)に次の行を追加する。

  ``` :settings.json
  code-runner.executorMap": {
    "ocaml": "cd $dir && ocaml $fileName"
  }
  ```

  **注意**:
  `executorMap`にほかの言語の設定もある場合があります。

以上で、`Run Code` (`Ctrl+Shift+N`)でプログラムが実行できます。

## おわりに

この記事では、`VS Code` (`Visual Studio Code`)に`OCaml`のための拡張機能を追加する方法を説明しました。
これにより、`VS Code`のリッチな編集機能を使って`OCaml`プログラムを書き、実行できるようになりました。

このように機能拡張を使うことで、`OCaml`による関数型プログラミングの学習がますます便利になります。
これを利用して、自分の学習を進めプログラマーとしてステップアップしましょう。
それでは、Happy Hacking!
