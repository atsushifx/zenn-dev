---
title: "OCaml: OCaml用にVisual Studio Codeをセットアップする"
emoji: "🐪"
type: "tech"
topics: [ "OCaml", "VSCode", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

`Visual Studio Code` (以下、`VS Code`)は多言語をサポートする強力なエディタです。
`OCaml`用の拡張機能も提供されています。
この記事では、`VS Code`での`OCaml`開発環境の構築方法を紹介します。

## 1. `OCaml`パッケージのインストール

### 1.1 `LSP`サーバのインストール

`VS Code`の`OCaml Platform`拡張機能は、`LSP` (`Language Server Protocol`)を使用しています。
`OCaml`の`LSP`サーバパッケージをインストールし、動作を確認します。

次のコマンドで、`OCaml`用`LSP`をインストールします:

```bash
opam install --yes ocaml-lsp-server

```

**注意**:
関連パッケージを自動的にインストールするため、`--yes`オプションを追加しています。

`LSP`の動作確認は、`ocamllsp`を実行してエラーメッセージが出力されることを確認します。
次の手順で、`LSP`を動作確認します:

1. `LSP`サーバの起動:
    次のコマンドで`LSP`サーバを起動する

    ```bash
    ocamllsp
    ```

2. エラーメッセージの確認:
    \[Enter\]キーを押して、`LSP`サーバからエラーメッセージを出力されるかを確認する
    **注意**:
    これは、`LSP`サーバが正常に動作していることを確認するため

    ```bash
      # [Enter]を押す

    /-----------------------------------------------------------------------
    | Internal error: Uncaught exception.
    | Error: content length absent
    ```

    上記のようなエラーメッセージが出力される

3. `LSP`サーバの停止:
    \[`Ctrl+C`\]を入力し、`LSP`を中止する

    ```bash
    ^C  # [Ctrl+C]を押して、中止する

    >
    ```

上記のようにエラーメッセージが出力されれば、`LSP`は正常にインストールされています。

### 1.2 コード整形ツールのインストール

`OCaml`のコードを整形するツール`ocamlformat`をインストールし、動作を確認します。
次のコマンドで、コード整形ツールをインストールします:

```bash
opam install --yes ocamlformat

```

次の手順で、コード整形ツールの動作を確認します:

1. フォーマッタ用に`.ocamlformat`を作成する:

    ```bash
    touch .ocamlformat
    ```

2. コード整形用にプログラムを作成する:

   ```OCaml: hello.ml
    (* my first OCaml program *)
    print_endline "Hello, OCaml!!"

    ```

3. 上記の`OCaml`プログラムをフォーマッタで整形する:

    ```bash
    ocamlformat hello.ml
    (* my first OCaml program *)
    print_endline "Hello, OCaml!!"

    ```

    **注意**:
    ｀Warning`エラーが出る場合は、`--enable-outside-detected-project`を追加する

上記のように整形されたプログラムが出力されれば、フォーマッタの正常にインストールされています。

## 2. 拡張機能のインストール

### 2.1 `OCaml Platform`のインストール

`OCaml Platform`は`LSP`を利用して、コーディング時にタブ補完やエラーチェックを行います。
次の手順で、`OCaml Platform`をインストールします:

1. `VS Code`を起動する:

   ```bash
   code .
   ```

2. [拡張機能ビュー]を表示する:
  [`Ctrl+Shift+X`]を入力し、[拡張機能ビュー]を表示する。

3. [`OCaml Platform`]を検索する:
  上部の検索バーに`ocaml`と入力し、[`OCaml Platform`]を検索する。

4. [`OCaml Platform`]をインストールする:
  \[インストール\]をクリックし、[`OCaml Platform`]をインストールする。

### 2.2 `Code Runner`のインストール

`Code Runner`は、編集中のプログラムを簡単に実行できる拡張機能です。
編集するプログラミング言語にあわせて、適当なコマンドを実行します。

次の手順で、[`Code Runner`]をインストールします。

1. `VS Code`を起動する:

   ```bash
   code .
   ```

2. [拡張機能ビュー]を表示する:
  [`Ctrl+Shift+X`]を入力し、[拡張機能ビュー]を表示する。

3. [`Code Runner`]を検索する:
  上部の検索バーに`code`と入力し、[`OCaml Platform`]を検索する。

4. [`Code Runner`]をインストールする:
  \[インストール\]をクリックし、[`Code Runner`]をインストールする。

### 2.3 `Code Runner`の設定

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
  これにより、`OCaml`でのプログラム実行時に適切なコマンドが使用される。

  ``` :settings.json
  code-runner.executorMap": {
    "ocaml": "cd $dir && ocaml $fileName"
  }
  ```

  **注意**:
  `OCaml`以外の言語で環境構築する場合は、`executorMap`セクション内にほかの言語の設定を追加します。

以上で、`Run Code`でプログラムが実行できます。

## おわりに

この記事では、`VS Code`に`OCaml`の拡張機能を追加する方法を説明しました。
このように拡張機能を使用することで、`OCaml`による関数型プログラミングの学習がより便利になりました。

今後は`VS Code`を活用して、`OCaml`で関数型プログラミングを学習しましょう。
それによって、さらにスキルを向上させていきましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用される主な技術用語について解説します:

- `OCaml`:
  強力な型システムを特徴とする関数型プログラミング言語

- `VS Code` (`Visual Studio Code`):
  Microsoft によって開発された、軽量で強力な機能を持つコードエディタ

- `opam`:
  `OCaml`用のライブラリやツールを提供する`OCaml`パッケージマネージャー

- `LSP` (`Language Server Protocol`):
  エディタ、IDE用に統一された方法でプログラミング言語のサポートを提供するプロトコル

- `OCaml Platform`:
  `OCaml`プログラミングのために、`OCaml`言語のサポートを強化する`VS Code`拡張機能

- `Code Runner`:
  任意の言語のコードスニペットやファイルを簡単に実行できる`VS Code`拡張機能

## 参考資料

### Webサイト

- [`opam`](https://opam.ocaml.org/):
  `OCaml`用パッケージマネージャー

- [`ocaml-lsp`](https://github.com/ocaml/ocaml-lsp):
  `OCaml`用`LSP`サーバ

- [`ocamlformat`](https://github.com/ocaml-ppx/ocamlformat):
  `OCaml`用コード整形ツール

- [`OCaml Platform`](https://github.com/ocamllabs/vscode-ocaml-platform):
  `OCaml`用`VS Code`拡張機能

- [`Code Runner`](https://github.com/formulahendry/vscode-code-runner)
  コード実行`VS Code`拡張機能
