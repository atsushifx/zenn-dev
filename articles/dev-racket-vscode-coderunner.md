---
title: "Racket: Racketプログラミング用にCode Runnerをインストールする"
emoji: "🎾"
type: "tech"
topics: [ "VSCode", "開発環境", "環境構築", "Racket",  "CodeRunner" ]
published: true
---

## tl;dr

- `VS Code`に`Code RUnner`をインストール
- `Code Runner`で LISPプログラムを Racket で動くように設定
- `VS Code`上で`Racket`プログラムを実行

`Code Runner`のおかげで、`Visual Studio Code`から`racket`プログラムを実行できます。
Enjoy!

## 1. はじめに

この記事では、`Visual Studio Code`に`Code Runner`をインストールして、`Racket`プログラムを実行させる方法を説明します。
`Visual Studio Code`は強力なエディタですが、`Racket`のデバッグ機能が不足していることがあります。
`Code Runner`を使用することで、`Visual Studio Code`から`Racket`プログラムを実行できるようになります。

### 1.1. Code Runnerとは

`Code Runner`は、`Visual Studio Code`内でさまざまなプログラムのコードを実行する拡張機能です。
対応言語は Python、JavaScript、Java、C#、PHP、Ruby など多数にのぼり、Racket もその 1つです。

`Code Runner`を実行すると、指定したコマンドを実行して実行結果を出力 Window に出力します。
たとえば、プログラムが`Racket`のプログラムなら`racket \<コードファイル\>`となります。

## 2. Code Runnerのインストール

`VS Code`に`Code Runner`をインストールする方法には 2種類あります。それぞれの方法を説明します。

### 2.1. VS Code上でのCode Runnerのインストール

次の手順で、`Code Runner`をインストールします。

1. 拡張機能の選択:
   左側のメニューから`拡張機能`をクリックする (または、`Ctrl+Shift+X`を押す)
   ![拡張機能](https://i.imgur.com/4JIrBTs.png)

2. 'Code Runner`の検索:
   検索バーに`Code Runner`を入力し、検索結果から該当の拡張機能を検索する
   ![Code Runner](https://i.imgur.com/bdYaeL0.png)

3. `Code Runner`のインストール:
  \[`インストール`\]をクリックして、`Code Runner`をインストールする
  ![インストール](https://i.imgur.com/uWyBHCe.png)

以上で、`Code Runner`のインストールは完了です。

### 2.2. コマンドラインからのCode Runnerのインストール

`VS Code`では、コマンドラインから拡張機能をインストールできます。
次の手順で、`Code Runner`をインストールします。

1. `PowerShell`を開く:
   ![PowerShell](https://i.imgur.com/2YbB7lj.png)

2. 以下のコマンドを実行:

   ```powershell
   code --install-extension formulahendry.code-runner
   ```

以上で、`Code Runner`のインストールは完了です。

## 3. Code Runnerの設定

`Code Runner`は言語ごとに実行するコマンドを設定できます。
そのためには、"VS Code"の設定ファイル"`settings.json`"に"Executor Map"を設定する必要があります。

### 3.1. Executor Mapの編集

次の手順で、`Executor Map を編集します。

1. ユーザー設定を開く:
   `Ctrl+Shift+P`とし、\[ユーザー設定を開く\]を選ぶ
   ![ユーザー設定](https://i.imgur.com/y94dSHr.png)

2. 設定を追加:
   "settings.json"に下記の設定を追加し、RacketでRacket/Scheme/LISPプログラムを実行できるようにします。

   ```json: settings.json
   "code-runner.customCommand": "echo hello",
   "code-runner.executorMap": {
      "racket": "racket $fullFileName",
      "scheme": "racket $fullFileName",
      "lisp": "racket $fulFileName",
   },
   ```

3. 設定の保存
   `Ctrl+S`とし設定ファイルを保存し、`Ctrl+W`で閉じる

以上で、`Executor Map`の編集は完了です。

## 4. Code Runnerの実行

### 4.1 "Hello World"プログラムの実行

[3.1](#31-executor-mapの編集)の設定を確認するため、"Hello World"プログラムを実行します。
次の手順で、"Hello World"プログラムを実行します。

1. `Hello World`の作成:
   `VS Code`で次のプログラムを作成する

   ```racket: hello.rkt
   #lang racket

   (display "Hello, my first racket!")
   ```

2. プログラムの実行:
   `Ctrl+Alt+N`、または右クリック+\[Run Code\]として、作成した"`hello.rkt`"プログラムを実行する

3. 出力の確認:
   \[出力\]ウィンドウで下記のメッセージが出ることを確認する

   ```output
   Hello, my first racket!
   ```

上記のように、プログラムのメッセージが表示されていれば、`Code Runner`は正常に動作しています。

## さいごに

この記事では、`Visual Studio Code`に`Code Runner`をインストールして、Racketプログラムを実行させる方法を紹介しました。

`VS Code`で`Racket`が動かせることで、Racket の学習が進むことでしょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- `VS Code CLI`: <https://code.visualstudio.com/docs/editor/command-line>
- `Code Runner`: <https://github.com/formulahendry/vscode-code-runner>
