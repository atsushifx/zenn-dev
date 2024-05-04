---
title: "Racket: Visual Studio Codeで快適なRacket開発環境を構築する"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "VisualStudioCode", "VSCode", "開発環境", "環境構築", ]
published: false
---

## はじめに

この記事では、`VS Code` (`Visual Studio Code`)に、`Racket`用のプロファイルを設定し、快適な`Racket`開発環境を構築する方法を紹介します。
構築後は、タブ補完やコードフォーマットなど便利な機能を利用して、プロジェクトを効率的に進行できるようになります。

`Racket`用プロファイルを利用することで、プロジェクト間で共通の設定を活用でき、開発の一貫性を保ちながら効率化を図ることができます。

`VS Code`を使用して、`Racket`で関数型プログラミングの学習を進めましょう。
Enjoy!

## 1. 前提条件

### 1.1 Racketのセットアップ

`Racket`は、すでにセットアップされていることを前提としています。
まだの場合は、[WSL上でRacketをセットアップする方法](https://zenn.dev/atsushifx/articles/edu-racket-setup-install-wsl)を参照してください。

### 1.2 VS Codeの設定

`VS Code`には、`programming`プロファイルが設定されているとします。
まだの場合は、[`VS Code`でプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv)を参照して、`programming`プロファイルを作成してください。

## 2. Racket拡張機能のインストール

### 2.1 `Racket LSP`のインストール

`VS Code`の`Racket`用拡張機能は、`LSP`を使ってコードのタブ補完、エラー検出といった高度な編集機能を実現しています。
そのため、`Racket`側で`LSP`をインストールする必要があります。
`Racket`用`LSP`として、`racket-langserver`パッケージが提供されてます。

次のコマンドで、`racket-langserver`をインストールします:

```bash
raco pkg install --auto --scope installation racket-langserver

```

次に、`racket-langserver`を起動し`LSP`が正常に動作しているかを確認します:

```bash
racket --lib racket-langserver

```

`LSP`に適当なコマンドを入力して、エラーメッセージが出力されることを確認します。
次のテキストを入力します:

```bash
content-length: 5

hello
[EOF][EOF] ← Ctrl+D(WSL)/Ctrl+Z(Windows)でEOFを入力
```

次のようにエラーメッセージが出力されれば、正常に動作しています:

```bash
Unexpected EOF
```

### 2.2 `fmt`のインストール

`Racket`用のコードフォーマッタ`fmt`をインストールします。

次のコマンドで、`fmt`をインストールします:

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

## 3. `VS Code`の環境設定

### 3.1 プロファイルの作成

`Racket`用に新しいプロファイル`racket-programming`を作成します。

次の手順で、プロファイルを作成します:

1. [プロファイルの作成]を開く
  [⚙ (歯車の記号)]-[プロファイル]-[プロファイルの作成]を選択し、[プロファイルの作成]ダイアログを開きます。
  ![create-profile menu](https://i.imgur.com/gyfm8WR.jpg)

2. プロファイルを作成する
  プロファイル名に`racket-programming`を入力し、[コピー元]に`programming`を選んで、[作成]をクリックします。
  [create-profile create profile](https://i.imgur.com/qryC0jv.jpg)

### 3.2 `VS Code`拡張機能のインストール

次の手順で、`Racket`用の拡張機能をインストールします:

1. 拡張機能画面を開く
   アクティビティバーの拡張機能アイコンをクリックし、拡張機能画面を開きます。
   ![拡張機能マーケットプレイス](https://i.imgur.com/grZSgOG.jpg)

2. `Magic Racket`をインストール
   検索ウィンドウに`Magic Racket`と入力し、表示された`Magic Racket`をインストールします。

3. `racket-fmt`をインストール
   検索ウィンドウに`racket-fmt`と入力し、表示された`racket-fmt`をインストールします。

### 3.3 `Code Runner`の設定

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

## 4. その他の設定ファイル

### 4.1 `editorconfig`の設定

`Racket`コード用に、次のように`editorconfig`を設定します:

@[gist](https://gist.github.com/atsushifx/fbc86f1649ed1d5778812ea21bf73804?file=editorconfig)

`VS Code`は`EditorConfig`拡張機能を用いて、上記の`.editorconfig`に従いタブやインデントを設定します。

## おわりに

以上で、`VS Code`に`Racket`用のプロファイルが設定できました。
これにより、`Racket`ソースファイルによるプログラミングが行えます。
より、実際のプログラミングに近い方式となり、関数型プログラミングの学習もレベルアップするでしょう。

`Racket`でのプログラミングを通じて、関数型プログラミングを楽しんでください。

それでは、Happy Hacking!

## 技術用語と注釈

- `Racket`:
  教育や研究、実用的なアプリケーション開発で使用される関数型プログラミング言語

- `VS Code` (`Visual Studio Code`):
  多様なプログラミング言語を拡張機能によってサポートした、Microsoft製のソースコードエディタ

- `LSP` (`Language Server Protocol`):
  プログラミング言語に対応したコード補完やエラー検出、コードフォーマット機能を提供するためにエディタや IDE に提供されるプロトコル

- `racket-langserver`:
  `Racket`用にパッケージとして提供される`LSP`の実装

- `fmt`:
  `Racket`用に提供されるコードフォーマッタ

- `Code Runner`:
  `VS Code`において、様座なプログラミング言語を直接実行する機能を提供する`VS Code`格調機能

- `editorconfig`:
  エディタ、IDE でコードの統一した書式設定で適用するための設定ファイル

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
