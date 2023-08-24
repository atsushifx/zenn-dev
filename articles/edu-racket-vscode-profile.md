---
title: "RacketプログラミングのためのVisual Studio Code環境構築"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "開発環境","VisualStudioCode", "環境構築"]
published: false
---

## はじめに

この記事では、Racket[^1]プログラミング用に Visual Studio Code[^2] をセットアップする手順を紹介します。
メジャーなエディタである`Visual Studio Code`に、Racket プログラミング用の環境を構築することで、効率的に Racket のプログラミングができます。

[^1]: Racket: 関数型プログラミング言語の一種でシンプルな構文と豊富なライブラリが特徴
[^2]: `Visual Studio Code`: オープンソースのコードエディタで、拡張性に優れ、主要なプログラミング言語に対応

## 1.  セットアップ

### 1.1. Racketのインストール

Racket は、コンソール上で:

```powershell
winget install racket.racket
```

で、簡単にインストールできます。

インストール先ディレクトリを指定するなどの、詳しいインストール方法は[Windowsに関数型言語'Racket'をインストールする方法](edu-lang-racket-install)を読んでください。

### 1.2 `Visual Studio Code`の初期設定

この記事では、[VS Code でプログラミングするための拡張機能と設定](dev-vscode-progeny)にしたがって`Visual Studio Code`をセットアップしていることとしています。

`Visual Studio Code`をインストールしたばかりの人や拡張機能[^3]についてよくわからないほうは、上記記事を参照してください。

[^3]: 拡張機能: `VS Code`に追加できる機能拡張で、プログラミング言語や作業環境に特化した機能を提供

## 2. Visual Studio Codeのセットアップ

### 2.1. プロファイルの役割と利点

プロファイル[^4]は、異なる作業環境ごとに拡張機能や設定を簡単に切り替えるためのツールです。記事を書くためのプロファイルやプログラミング用のプロファイルといった区別をつけることで、作業効率を向上させることができます。

[^4]: プロファイル: 作業環境に名前をつけ拡張機能や設定を保存する機能

### 2.2. Racket用プロファイルの作成

今回、[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)をもとにプロファイルを作成します。
以下の手順で、プロファイルを作成します:

1. \[プロファイルの作成\]の選択
    \[設定\]-\[プロファイル\]-\[プロファイルの作成\]を選び、\[新しいプロファイルの作成\]ダイアログを表示する。
    ![プロファイルの作成]( https://i.imgur.com/o1nuJFp.png)

2. \[新しいプロファイルの作成\]
    <!-- textlint-disable -->
    \[プロファイル名\]に"racket-programming"、\[コピー元\]に"programming"を入力して、\[作成\]をクリックする。
    <!-- textlint-enable --->
     ![新しいプロファイル](https://i.imgur.com/vHqth5k.png)

3.プロファイルの作成完了
    プロファイル"racket-programming"が作成される。

以上で、プロファイルの作成は完了です。
このプロファイルに Racket 用の拡張機能、設定を追加すれば`VS Code`のセットアップは完了です。

## 3. 拡張機能の追加

Racket プログラミング用に、以下の拡張機能を追加します。

### 3.1. Night Owl

Night Owl は、コーディング用のカラーテーマ[^5]です。
このテーマは、目に優しい色使いとシンタックスハイライト[^6]が特長です。

[^5]: カラーテーマ: コードエディタの色彩をカスタマイズするための設定
[^6]: シンタックスハイライト: プログラミングの構文をわかりやすくするためにキーワード種別ごとに色分けする機能

### 3.2. Code Runner

`Code Runner` はプログラムの実行を支援する拡張機能です。詳細な設定については、"[Racketプログラミング用にCode Runnerをインストール・設定する方法](dev-racket-vscode-coderunner)"を参照してください。

### 3.3. Magic Racket

Magic Racket は、Racket 用のコード入力補完やシンタックスハイライトを提供する拡張機能です。詳細については、"[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](dev-racket-vscode-magicracket)"を参照してください。

### 3.4.その他の拡張機能

そのほかにも、プログラミングに有用拡張機能を追加しています。詳細は、"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"をご覧ください。

## 4. Racketプログラミング用の設定

上記で追加した拡張機能について、どのように設定したかを追加します。

### 4.1. Code Runnerの設定

`Code Runner'には、Racketプログラムを動作させる設定を追加します。
設定ファイル"settings.json"に、次の設定を追加します:

```json: settings.json
"code-runner.executorMap": {
  "racket": "racket $fullFileName",
}
```

### 4.2. Magic Racketの設定

`Magic Racket`には、特別な設定の必要はありません。ただし、`Racket`用の`LSP`[^7]を設定する必要があります。
詳細については、[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](dev-racket-vscode-magicracket)を参照してください。

[^7]: `LSP (Language Server Protocol): プログラミング言語ごとのコード分析や補完を行うためのプロトコル

### 4.3. その他の拡張機能の設定

そのほかの拡張機能の設定については、"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"を参照してください。

### 4.4. 設定ファイル

設定ファイル'extensions.json'に、インストールしたい拡張機能の ID をリストアップします。
`VS Code`は、`extension.json`に記述された拡張機能をまとめてインストールします。
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

## おわりに

この記事を通じて、Racket プログラミング用に`Visual Studio Code`をセットアップする方法を解説しました。
`VS Code`には、ほかにも強力な拡張機能があります。
それらを利用して、独自の開発環境を構築するのもよいでしょう。

自分に最適な開発環境を構築して、Racket プログラミングの世界をより楽しんでください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [VS Code Extensions](https://marketplace.visualstudio.com/vscode)
- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver)

### ブログ記事

- [Windowsに関数型言語'Racket'をインストールする方法](edu-lang-racket-install)
- [Racket プログラミング用に Code Runner をインストール・設定する方法](https://zenn.dev/atsushifx/articles/dev-racket-vscode-coderunner)
- [Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](https://zenn.dev/atsushifx/articles/dev-racket-vscode-magicracket)
- [VS Codeでプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv)
