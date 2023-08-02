---
title: "Racket: Racketプログラミング用にCode Runnerをインストール・設定する方法"
emoji: "🎾"
type: "tech"
topics: [ "VSCode", "開発環境", "環境構築", "Racket",  "CodeRunner" ]
published: true
---

## tl;dr

- `VS Code`に`Code Runner`をインストール
- `Code Runner`で Racket/Scheme/LISP プログラムを Racket で動くように設定
- Racketプログラムを`VS Code`上で実行

`Code Runner`のおかげで、`Visual Studio Code`から`Racket`プログラムを実行できます。
Enjoy!

## 1. はじめに

この記事では、`Code Runner`のインストールと、`Racket`プログラムを実行するための設定について詳しく説明します。

### 1.1. Code Runnerとは

`Code Runner`は、`Visual Studio Code`内でさまざまなプログラムのコードを実行する拡張機能です。
対応言語は Python、JavaScript、Java、C#、PHP、Ruby など多数にのぼり、Racket もその 1つです。

`Code Runner`を実行すると、指定したコマンドを実行して実行結果を出力 Window に出力します。
たとえば、プログラムが`Racket`のプログラムなら`racket <ソースファイル>`となります。

## 2. Code Runnerのインストール

`VS Code`に`Code Runner`をインストールする方法は`VS Code`上で\[拡張機能\]メニューを使う方法と、コマンドラインから行なう方法の 2つがあります。
ここでは、それぞれの方法について説明します。

### 2.1. VS Code上でのCode Runnerのインストール

まず、`VS Code`上で`Code Runner`をインストールする手順を説明します。

1. 拡張機能の選択:
   左側のメニューから\[`拡張機能`\]アイコンをクリックする (または、`Ctrl+Shift+X`を押す)
   ![拡張機能](https://i.imgur.com/4JIrBTs.png)

2. `Code Runner`の検索:
   検索バーに`Code Runner`を入力し、検索結果から該当の拡張機能を選択する
   ![Code Runner](https://i.imgur.com/bdYaeL0.png)

3. `Code Runner`のインストール:
  \[`インストール`\]をクリックして、`Code Runner`をインストールする
  ![インストール](https://i.imgur.com/uWyBHCe.png)

以上で、`VS Code`上での`Code Runner`のインストールは完了です。

### 2.2. コマンドラインからのCode Runnerのインストール

`VS Code`では、コマンドラインから拡張機能をインストールできます。
次の手順で、コマンドラインから`Code Runner`をインストールします。

1. `PowerShell`を開く:
   ![PowerShell](https://i.imgur.com/2YbB7lj.png)

2. 以下のコマンドを実行:

   ```powershell
   code --install-extension formulahendry.code-runner
   ```

以上で、コマンドラインでの`Code Runner`のインストールは完了です。

## 3. Code Runnerの設定

`Code Runner`は言語ごとに実行するコマンドを設定できます。
そのためには、"VS Code"の設定ファイル"`settings.json`"に"Executor Map"を追加する必要があります。

### 3.1. Executor Mapの追加

次の手順で、`Racket`プログラムを動作させるための`Executor Map`を追加します。

1. ユーザー設定を開く:
   `Ctrl+Shift+P`を押し、コマンドパレットで\[ユーザー設定を開く\]を選ぶ
   ![ユーザー設定](https://i.imgur.com/y94dSHr.png)

2. 設定を追加:
   "settings.json"に以下の設定を追加する。これにより、Racket で Racket/Scheme/LISPプログラムが実行できる

   ```json : settings.json
   "code-runner.customCommand": "echo hello",
   "code-runner.executorMap": {
      "racket": "racket $fullFileName",
      "scheme": "racket $fullFileName",
      "lisp": "racket $fullFileName",
   },
   ```

   上記のように`$fullFileName`を使うと、ソースファイルをフルパスで指定できます。
   そのため、ソースファイルがどのディレクトリにあるかに関係なく実行できます。

3. 設定の保存
   `Ctrl+S`とし設定ファイルを保存し、`Ctrl+W`で閉じる

以上で、`Executor Map`の設定は完了です。

## 4. Code Runnerの動作確認

### 4.1 "Hello World"で動作確認

[3.1](#31-executor-mapの追加)で`Racket`プログラムを動作させる設定を追加しました。
この設定が正しく行われていることを確認するために、"Hello World"プログラムを作成して実行します。
次の手順で、行います。

1. `Hello World`の作成:
   `VS Code`で次のプログラムを作成する

   ```racket: hello.rkt
   #lang racket

   (display "Hello, my first racket!")
   ```

2. プログラムの実行:
   作成したソースファイル上で`Ctrl+Alt+N`を押す、または右クリック+\[Run Code\]として、作成した"`hello.rkt`"プログラムを実行する

3. 出力の確認:
   \[出力\]ウィンドウで以下のメッセージが表示されていることを確認する

   ```output
   Hello, my first racket!
   ```

上記のように、作成したメッセージが出力されていれば、`Code Runner`は正常に動作しています。

## さいごに

この記事では、`Visual Studio Code`に`Code Runner`をインストールして、Racketプログラムを実行させる方法を紹介しました。
これにより、Racketプログラムの動作確認がより簡単になります。
この新たな知識を活用して、Racket プログラミングの世界をお楽しみください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`VS Code CLI`](https://code.visualstudio.com/docs/editor/command-line): `VS Code`のコマンドラインについての公式ドキュメント
- [`Code Runner`](https://github.com/formulahendry/vscode-code-runner): `Code Runner`の公式 GitHub リポジトリ
