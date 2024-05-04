---
title: "Racket: Visual Studio Codeで快適なRacket開発環境を構築する"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "VisualStudioCode", "VSCode", "開発環境", "環境構築", ]
published: true
---

## はじめに

この記事では、`VS Code` (`Visual Studio Code`) を使用して、`Racket`の開発環境を最適化する方法を解説します。
`Racket`専用プロファイルを設定し、タブ補完やコードフォーマットなど、開発効率を高める機能を導入します。

`Racket` で関数型プログラミングを学び、プログラマーとしてのスキルを向上させましょう。

## 1. 前提条件

### 1.1 Racketのセットアップ

`Racket` がすでにインストールされていることを前提としています。
`Racket` インストールがまだの場合は、`Racket` のセットアップに関する以下の記事を参照してください。

- [WSL上でRacketをセットアップする方法](https://zenn.dev/atsushifx/articles/edu-racket-setup-install-wsl)

### 1.2 `VS Code`設定

`VS Code` に`programming` プロファイルが設定されていることを前提としています。
この設定がまだの場合は、以下のリンクから`VS Code`でのプログラミング環境の設定方法を確認してください。

- [VS Codeでプログラミング環境を設定する](<https://zenn.dev/atsushifx/articles/dev-vscode-progenv>)

## 2. Racket拡張機能のインストール

### 2.1 `Racket LSP`設定

`Racket`用のコード補完機能、エラーチェック機能を実現するために、`LSP` (`Language Server Protocol`)を利用します。
`Racket`側では、`Racket`用 `LSP`サーバ `racket-langserver` をセットアップします。

次の手順で、`racket-langserver` をインストールし、動作チェックします:

1. `racket-langserver`のインストール
   次のコマンドを実行し、`racket-langserver`をインストールする。

   ```bash
   raco pkg install --auto --scope installation racket-langserver

   ```

2. `racket-langserver`の起動
   動作チェックのため、`racket-langserver`を起動する。

   ```bash
   racket --lib racket-langserver

   ```

3. `racket-langserver`の動作チェック
   適当なコマンドを入力し、エラーが出力されるかチェックする。

   ```bash
   content-length: 5

   hello
   [EOF][EOF] ← Ctrl+D(WSL)/Ctrl+Z(Windows)でEOFを入力
   ```

4. エラーチェック
   エラーメッセージが出力されるかをチェックする。

   ```bash
   Unexpected EOF
   ```

### 2.2 `fmt`インストール手順

`Racket`用のコードフォーマッタ `fmt` をインストールします。

次のコマンドで、`fmt` をインストールします:

```bash
raco pkg install --auto --scope installation fmt

```

`fmt`を使用するには、つぎのようにソースコードファイルを指定します:

```bash
raco fmt helloworld.rkt

```

`fmt`は、フォーマットされたコードを標準出力に出力します。

```racket: helloworld.rkt
#lang racket

(display '("Hello," "my first racket!"))
(newline)

```

## 3. `VS Code`環境設定詳細

### 3.1 プロファイル作成

`Racket`専用のプロファイル `racket-programming` を `VS Code` に設定します。

次の手順で、プロファイルを作成します:

1. [プロファイルの作成]を開く
  [⚙ (歯車の記号)]-[プロファイル]-[プロファイルの作成]を選択し、[プロファイルの作成]ダイアログを開きます。
  ![create-profile menu](https://i.imgur.com/gyfm8WR.jpg)

2. プロファイルを作成する
  プロファイル名を `racket-programming` として入力し、[コピー元]に `programming` を選んで、[作成]をクリックします。
  ![create-profile create profile](https://i.imgur.com/qryC0jv.png)

### 3.2 `VS Code`拡張機能インストール

次の手順で、`Racket`用の拡張機能をインストールします:

1. 拡張機能画面を開く
   アクティビティバーの拡張機能アイコンをクリックし、拡張機能画面を開きます。
   ![拡張機能マーケットプレイス](https://i.imgur.com/grZSgOG.jpg)

2. `Magic Racket`をインストール
   検索ウィンドウに `Magic Racket` と入力し、表示された `Magic Racket` をインストールします。

3. `racket-fmt`をインストール
   検索ウィンドウに `racket-fmt` と入力し、表示された `racket-fmt` をインストールします。

以上で、`コード補完、エラー検出、コードフォーマットなどの機能が利用できます。

### 3.3 `Code Runner`設定

拡張機能`Code Runner`に、`Racket`プログラミング実行用の設定を追加します。

次の手順で、設定を追加します:

1. ユーザー用設定ファイルを開く
  [`Ctrl+Shift+P`]→`open user settings`として、ユーザー用の`settings.json`ファイルを開きます。

2. `Executor Map`を追加
  `settings.json`ファイルに、次のように`executorMap`を追加します。

  ```json: settings.json
  "code-runner.executorMap": {
    "racket": "cd $dir && racket $fileName",
  }
  ```

## 4. 追加設定ファイル

### 4.1 `editorconfig`設定

`Racket`コードの書式設定に、`editorconfig` を使用します。
`VS Code` は、`Editorconfig`拡張機能により、`editorconfig` の設定を適用します。

次のように、`.editorconfig`を設定します:

@[gist](https://gist.github.com/atsushifx/fbc86f1649ed1d5778812ea21bf73804?file=editorconfig)

## おわりに

以上で、`VS Code`に`Racket`用のプロファイルが設定できました。
れにより、`Racket`ソースファイルでのプログラミングがスムーズに行えます。

より実践的なプログラミング体験を通じて、関数型プログラミングのスキルを向上させましょう。

それでは、Happy Hacking!

## 技術用語と注釈

- `Racket`:
  教育や研究、実用的なアプリケーション開発で使用される関数型プログラミング言語

- `VS Code` (`Visual Studio Code`):
  多様なプログラミング言語を拡張機能によってサポートした、Microsoft製のソースコードエディタ

- `LSP` (`Language Server Protocol`):
  エディタと通信して、コード補完、エラー検出、コードフォーマット機能などを提供するプロトコル

- `racket-langserver`:
  `Racket`用にパッケージとして提供され、`Racket`のコード補完機能などを提供する `LSP` の実装

- `fmt`:
  `Racket`用に提供されるコードフォーマッタ

- `Code Runner`:
  `VS Code` において、様座なプログラミング言語を直接実行する機能を提供する`VS Code`格調機能

- `editorconfig`:
  エディタ、`IDE` でコードの統一した書式設定で適用するための設定ファイル

## 参考資料

### Webサイト

- [Magic Racket](https://github.com/Eugleo/magic-racket):
  `VS Code`用の`Racket LSP`クライアント。コードのタブ補完、エラーチェックといった機能を実現する。

- [`racket fmt`](https://github.com/suxiaogang223/racket-fmt):
  `Racket`用コードフォーマッタ

- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver):
  `Racket`用の`LSP`サーバ

- [`racket fmt`公式ドキュメント](https://docs.racket-lang.org/fmt/)
  `Racket`公式サイトによるコードフォーマッタのドキュメント
