---
title: "Racket: Racketプログラミング用にVisual Studio Codeをセットアップする"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "開発環境","Visual Studio Code", "環境構築"]
published: false
---

## はじめに

この記事では、Racket プログラミング用に Visual Studio Code をセットアップする手順を紹介します。
Racket には `Dr Racket`` という統合開発環境が用意されており、すぐにプログラミングをはじめることができます。

しかし、実際にコーディング作業を始めるさいには使い慣れた既存のエディタを使いたくなります。
ここでは、メジャーなエディタである`Visual Studio Code` で快適な Racket プログラミング環境を構築する方法を説明します。

## Visual Studio Code とは

`Visual Studio Code` (以下、`VS Code`) は、Microsoft が提供する高機能かつ軽量なオープンソースのコードエディタです。多くのプログラミング言語に対応し、拡張機能によって機能を追加できます。
VS Code を利用することで、Racket プログラミングの効率を向上させることができます。

## Visual Studio Codeのセットアップ

### Visual Studio Codeのプロファイル

`VS Code`で環境構築をするには、まずプロファイルを設定する必要があります。
プロファイルは、追加した拡張機能、キーなどの設定、UI  の状態をまとめたものです。
これに名前をつけて保存することで、ブログ記事の執筆やプログラミングなど、目的ごとに最適な環境で作業できます。

今回は、プログラミング用なので"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"をもとに環境を構築します。

### Visual Studio Codeの拡張機能

"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"で紹介した拡張機能のほかに、以下の拡張機能を追加しています。

#### Night Owl

`Night Owl` は、コーディング用のカラーテーマです。目に優しく、コードのシンタックスハイライトがわかりやすいのが特徴です。

#### Code Runner

`Code Runner`は作成したプログラムを実行する拡張機能です。設定などの詳しいことは、"[Racketプログラミング用にCode Runnerをインストール・設定する方法](dev-racket-vscode-coderunner)"を参照してください。

#### Magic Racket

`Magic Racket`は、Racket 用にコード入力補完、シンタックスハイライトなどを追加する拡張機能です。詳しいことは、"[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](/dev-racket-vscode-magicracket)"を参照してください。

#### その他の拡張機能

ほかにも拡張機能を追加しています。これらは、"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"で紹介しています。

### Racketプログラミング用の設定

上記で追加した拡張機能について、どのように設定したかを追加します。

<!-- markdownlint-disable-next-line no-duplicate-header -->
#### Code Runner

`Code Runner'では、Racketプログラムを動作させる設定を追加します。

設定ファイル"settings.json"は、以下のようになります:

```json: settings.json
"code-runner.executorMap": {
  "racket": "racket $fullFileName",
  "scheme": "racket $fullFiVisual Studio CodeでのRacket LSPプログラミング環境の構築方法leName",
  "lisp": "racket $fulFileName",
 },
```

<!-- markdownlint-disable-next-line no-duplicate-header -->
#### Magic Racket

`racket-langserver`が正常に動作していればとくに設定の必要はありません。
詳しいことは、[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](dev-racket-vscode-magicracket)を参照してください。

<!-- markdownlint-disable-next-line no-duplicate-header -->
##### その他の拡張機能

そのほかの拡張機能の設定については、"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"を参照してください。

### 設定ファイル

この記事での開発環境を構築するための設定ファイルを紹介します。

#### extensions.json

`extensions.json`には、追加したい拡張機能の ID を列挙します。
下記を追加後に、`VS Code`でインストールを選択すると各拡張機能をインストールします。
詳しいことは、[VS Codeでプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv#3.-%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)を参照してください。

"extensions.json"は、以下の通りです:

``` json: extensions.json
{
  "recommendations": [
    "sdras.night-owl"
   "evzen-wybitul.magic-racket"
    "aaron-bond.better-comments",
    "formulahendry.code-runner",
    "streetsidesoftware.code-spell-checker",
    "editorconfig.editorconfig",
    "oderwat.indent-rainbow",
    "ymotongpoo.licenser",
    "fnando.linter",
    "shardulm94.trailing-spaces",
    "ionutvmi.path-autocomplete"
  ]
}

```

### おわりに

### 参考資料

#### Webサイト

- [VS Code Extensions](https://marketplace.visualstudio.com/vscode)
- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver)

#### ブログ記事

- [VS Codeでプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv)
- [Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](https://zenn.dev/atsushifx/articles/dev-racket-vscode-magicracket)
- Racket プログラミング用に Code Runner をインストール・設定する方法](<https://zenn.dev/atsushifx/articles/dev-racket-vscode-coderunner>)
