---
title: "Racket: Visual Studio CodeにRacket用プロファイルを設定する"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "VisualStudioCode", "VSCode", "開発環境", "環境構築", ]
published: false
---

## はじめに

この記事では、`VS Code` (`Visual Studio Code`)を`Racket`のプログラミング用に環境設定する方法を紹介します。
これにより、`Racket`ソースコードのタブ補完、コードフォーマットなどの便利な機能を利用できます。
上記の環境設定は、`VS Code`に`Racket`プログラミング用のプロファイルとして保存します。
これにより、複数のプロジェクトに共通の`Racket`の設定が使えるようになります。

`VS Code`で、高度な`Racket`プログラミングをすすめ、関数型プログラミングの学習を進めましょう。
Enjoy!

## 1. 前提条件

### 1.1 Racketのセットアップ

`Racket`は、すでにセットアップ済みであるものとします。
まだの場合は、[WSL上でRacketをセットアップする方法](https://zenn.dev/atsushifx/articles/edu-racket-setup-install-wsl)を参照して`Racket`をセットアップしてください。

### 1.2 `VS Code`の設定

`VS Code`には、プログラミング用に`programming`プロファイルが設定されているものとします。
まだの場合は、[VS Codeでプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv)を参考に、`programming`プロファイルを作成してください。

この記事では、`programming`プロファイルに`Racket`用の設定を追加することで、`Racket`用のプロファイルを作成します。

## 2. `Racket`拡張機能のインストール

### 2.1 `Racket LSP`のインストール

`VS Code`の`Racket`用拡張機能は、`LSP`を使ってコードのタブ補完、エラー検出といった高度な編集機能を実現しています。
そのため、`Racket`側で`LSP`をインストールする必要があります。
`Racket`用`LSP`として、`racket-langserver`パッケージが提供されているので、`raco`でこれをインストールします。

次のコマンドで、`racket-langserver`をインストールします:

```bash
raco pkg install --auto --scope installation racket-langserver

```

次に、`racket-langserver`を起動し`LSP`が正常に動作しているか確認します。

次のコマンドで、`LSP`を起動します:

```bash
racket --lib racket-langserver

```

次に、`LSP`に適当なコマンドを入力しエラーメッセージが出力されることを確認します。
次のテキストを入力します:

```bash: LSP
content-length: 5

hello
[EOF][EOF] ← Ctrl+D(WSL)/Ctrl+Z(Windows)でEOFを入力
```

エラーメッセージが出力されれば、正常に動作しています。

```bash
Unexpected EOF
```

### 2.2 `fmt`のインストール

`Racket`用のコードフォーマッタ`fmt`をインストールします。
次のコマンドで、`fmt`をインストールします:

```bash
raco pkg install --auto --scope installation fmt

```

`fmt`を使用するには、つぎのようにソースコードファイルを指定します。

```bash
raco fmt helloworld.rkt

```

フォーマットされたコードを標準出力に出力します。

```racket: helloworld.rkt
#lang racket

(display '("Hello," "my first racket!"))
(newline)

```

## 3. `VS Code`の設定

### 3.1 プロファイルの作成

`Racket`用に新しいプロファイルを作成します。

次の手順で、新しいプロファイルを作成します:

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

`VS Code`は、`EditorConfig for VS Code'拡張機能により上記`.editorconfig`でタブやインデントを設定します。

## おわりに
