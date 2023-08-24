---
title: "RacketプログラミングのためのVisual Studio Code環境構築"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "開発環境","VisualStudioCode", "環境構築"]
published: false
---

## はじめに

この記事では、Racket[^1]のプログラミング用に、Visual Studio Code[^2] をセットアップする手順を紹介します。

Racket はシンプルな構文と豊富なライブラリで知られる関数型プログラミング言語であり、教育用言語として実績があります。
`Visual Studio Code`(以下、`VS Code`)は、オープンソースのコードエディタです。主要なプログラミング言語をサポートしており、Racket もその中に含まれます。

[^1]: Racket: 関数型プログラミング言語の一種でシンプルな構文と豊富なライブラリが特徴
[^2]: `Visual Studio Code`: オープンソースのコードエディタで、拡張性に優れ、主要なプログラミング言語に対応

## 1.  セットアップ

### 1.1. Racketのインストール

Racket は、Windows パッケージマネージャーを使うことで簡単にインストールできます。
コンソール上で下記のコマンドを入力します。

```powershell
winget install racket.racket
```

インストール先ディレクトリを指定するなどの、詳しいインストール方法は[Windowsに関数型言語'Racket'をインストールする方法](edu-lang-racket-install)を参照してください。

### 1.2 `Visual Studio Code`の初期設定

Visual Studio Code を使いこなすためには、拡張機能[^3]の追加やフォントの設定などの初期設定が重要です。

この記事では、[VS Code でプログラミングするための拡張機能と設定](dev-vscode-progeny)にしたがって`Visual Studio Code`を初期設定していることとしています。

上記記事を読むことで、`VS Code`でプログラミングをするための初期設定が完成します。
`VS Code`の初期設定が終わっていない人は、是非読んでおいてください。

[^3]: 拡張機能: `VS Code`に追加できる機能拡張で、プログラミング言語や作業環境に特化した機能を提供

## 2. Visual Studio Codeのセットアップ

### 2.1. プロファイルの役割と利点

プロファイル[^4]は、作業環境に名前をつけてそれぞれの作業環境を簡単に切り替えられる機能です。
記事執筆用の作業環境には文章構成用の拡張機能を追加し、プログラミング用にはコードの表示や入力の補助をする拡張機能を追加するというふうに、それぞれに特化した環境を構築できます。
ま他、それぞれの作業環境を簡単に切り替えられるので作業の効率が上がります。

`VS Code`のプロファイルについては、[Profiles in Visual Studio Code](https://code.visualstudio.com/docs/editor/profiles)を参照してください。

[^4]: プロファイル: 作業環境に名前をつけ拡張機能や設定を保存する機能

### 2.2. Racket用プロファイルの作成

今回、[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)をもとにプロファイルを作成します。
以下の手順で、プロファイルを作成します:

1. \[プロファイルの作成\]の選択
    \[設定\]-\[プロファイル\]-\[プロファイルの作成\]を選んで、\[新しいプロファイルの作成\]ダイアログを表示する。
    ![プロファイルの作成]( https://i.imgur.com/o1nuJFp.png)

2. \[新しいプロファイルの作成\]
    \[プロファイル名\]に"racket-programming"を入力し、\[コピー元\]に"programming"を選択して\[作成\]をクリックする。
     ![新しいプロファイル](https://i.imgur.com/vHqth5k.png)

3.プロファイルの作成完了
    プロファイル"racket-programming"が作成される。

以上で、プロファイルの作成は完了しました。
このプロファイルに Racket 用の拡張機能、設定を追加すれば`VS Code`のセットアップは完了です。

## 3. 拡張機能の追加

Racket プログラミング用に、以下の拡張機能を追加します。

### 3.1. Night Owl

Night Owl は、プログラミング向けのカラーテーマ[^5]です。
このテーマの特徴は、視覚に優しい色調と分かりやすいシンタックスハイライト[^6]です。

[^5]: カラーテーマ: コードエディタの色彩をカスタマイズするための設定
[^6]: シンタックスハイライト: プログラミングの構文をわかりやすくするために、キーワードの種別ごとに色分けする機能

### 3.2. Code Runner

`Code Runner` は、外部アプリを使ってプログラムを実行する拡張機能です。
`Code Runner`により、作成したプログラミングを簡単に実行し、結果を見ることができます。

詳細については、"[Racketプログラミング用にCode Runnerをインストール・設定する方法](dev-racket-vscode-coderunner)"を参照してください。

### 3.3. Magic Racket

Magic Racket は、Racket の`LSP`[^7]を用いてコード入力補完やシンタックスハイライトを提供する拡張機能です。入力補完により打ち間違いが減りますし、シンタックスハイライトによりコードの見通しがよくなります。
現代のプログラミングでは、必須の拡張機能と言っていいでしょう。

詳細については、"[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](dev-racket-vscode-magicracket)"を参照してください。

[^7]: `LSP (Language Server Protocol): プログラミング言語ごとのコード分析や補完を行なうためのプロトコル

### 3.4.その他の拡張機能

そのほかにも、プログラミングに有用拡張機能を追加しています。詳細は、"[VS Codeでプログラミングするための拡張機能と設定](dev-vscode-progenv)"をご覧ください。

## 4. Racketプログラミング用の設定

上記で追加した拡張機能について、どのように設定したかを追加します。

### 4.1. Code Runnerの設定

`Code Runner'には、Racketプログラムの動作設定を追加します。
設定ファイル"settings.json"に、次の設定を追加します:

```json: settings.json
"code-runner.executorMap": {
  "racket": "racket $fullFileName",
}
```

### 4.2. Magic Racketの設定

`Magic Racket`自体には、特別な設定の必要はありませんが、該当言語として`Racket`用の`LSP`を設定する必要があります。
詳細については、[Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](dev-racket-vscode-magicracket)を参照してください。

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

この記事では、Racket のプログラミング用に`Visual Studio Code`をセットアップする方法を解説しました。
この記事の通りに設定をすれば、効率的に Racket のプログラミングができるでしょう。

`Visual Studio Code`には、ほかにも拡張機能があるので、それらを使って自分独自の開発環境を構築するのもよいでしょう。

自分に最適な開発環境を構築して、Racket プログラミングの世界をより楽しんでください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [VS Code Extensions](https://marketplace.visualstudio.com/vscode)
- [Profiles in Visual Studio Code](https://code.visualstudio.com/docs/editor/profiles)
- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver)

### ブログ記事

- [Windowsに関数型言語'Racket'をインストールする方法](edu-lang-racket-install)
- [Racket プログラミング用に Code Runner をインストール・設定する方法](https://zenn.dev/atsushifx/articles/dev-racket-vscode-coderunner)
- [Visual Studio CodeでのRacket LSPプログラミング環境の構築方法](https://zenn.dev/atsushifx/articles/dev-racket-vscode-magicracket)
- [VS Codeでプログラミングするための拡張機能と設定](https://zenn.dev/atsushifx/articles/dev-vscode-progenv)
