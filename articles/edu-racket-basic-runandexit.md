---
title: "Racket: Windows/WSL上でのRacketの起動と終了"
emoji: "🎾"
type: "tech"
topics: ["プログラミング言語", "関数型プログラミング", "Racket", "REPL", ]
published: false
---

## はじめに

この記事では、`Windows`および`WSL` (`Windows Subsystem for Linux`)上で`Racket`を起動および終了する方法について説明します。
`Windows`、`WSL`で共通のコマンドライン操作を中心に、プログラマーがより効率的に作業できるようサポートします。

この記事を読めば、`Racket`によるプログラミングがはじめられます。
`Racket`を用いて関数型プログラミングの学習をすすめ、プログラミングスキルを向上させましょう。
Enjoy!

## 1. 前提

### 1.1 OS環境 (Windows & WSL)

`Racket`は複数の`OS`に対応しており、`Windows`と`WSL`の両方の環境で`Racket`を使用できます。

この記事では、`Windows`、`WSL`共通の操作を説明します。

#### 1.2 `Racket`処理系

`Windows`、`WSL`とも、`Racket`はインストール済みであることを前提とします。

まだインストールしていない場合、下記の記事を参照して`Racket`をインストールしてください。

- `Windows`: [WindowsへのRacketのインストールと設定方法](https://zenn.dev/atsushifx/articles/edu-racket-setup-install-windows)
- `WSL`: [WSL上でRacketをセットアップする方法](https://zenn.dev/atsushifx/articles/edu-racket-setup-install-wsl)

### 1.3 `CLI`環境

`Windows`、`WSL`とも、`Racket`を端末上の`CLI` (`コマンドラインインターフェイス`)から起動します。

`Windows`版`Racket`には、`DrRacket`という統合開発環境がありますが、`WSL`版にはありません。
そのため、基本的な操作方法であるコマンドラインからの起動、終了方法を説明します。

## 2. `Windows Terminal`の使い方

`Windows`、`WSL`上で`CLI`を使うために、`Windows Terminal`を使用しています。
この章では、`Windows Terminal`の起動および終了方法について説明します。

### 2.1. `Windows Terminal`の起動、終了

`Windows Terminal`は`wt`コマンドで簡単に起動します。
次の手順で、`Windows Terminal`を起動、終了します。

1. `Windows Terminal`の起動
  \[`Win+R`]→\[`wt`]と入力し、`Windows Terminal`を起動する。

   ![Windows Terminal](https://i.imgur.com/3zmz5A6.png)
   *図1: Windows Terminalの起動*

2. `Windows Terminal`の終了
   コマンドラインに`exit`と入力して、`Windows Terminal`を終了する。

   **注意**:
   `Windows Terminal`が複数のタブが開いている場合、現在のタブを閉じても他のタブは開いたままになります。

   ```powershell
   exit
   ```

### 2.2 `Windows Terminal`の起動、終了 (`WSL`)

｀WSL`用プロファイルを指定して｀Windows Terminal`を起動することで、｀WSL`用コンソールを使用できます。
次の手順で、`Windows Terminal`を起動、終了します:

1. `Windows Terminal`の起動
  \[`Win+R`]→\[`wt debian`]と入力し、プロファイル`debian`で`Windows Terminal`を起動する。

   **注意**:
   プロファイル`debian`は、自分の`WSL`のプロファイルに置き換える必要があります。

   ![Windows Terminal](https://i.imgur.com/rWEGpZn.png)
   *図2: Windows Terminal (WSL)起動*

2. `Windows Terminal`の終了
  コマンドラインに`exit`と入力して、`Windows Terminal`を終了する。

   **注意**:
   `Windows Terminal`が複数のタブが開いている場合、現在のタブを閉じても他のタブは開いたままになります。

   ```bash
   exit
   ```

## 3. `Racket`の起動と終了

`Racket`の起動と終了の手順について詳しく説明します。

### 3.1 `Racket`の起動

コマンドラインで、`racket`と入力することで`Racket`が起動します。
プログラムファイルを指定していない場合は、`Racket`の対話的インタフェイスである`REPL`が起動します。

次の手順で、`Racket`を起動します。

1. `Racket`の起動
   コマンドラインに`racket`と入力する。

   ```bash
   racket`
   ```

2. プロンプトの表示
   `REPL`が起動し、プロンプトが表示される。

   ```bash
   Welcome to Racket v8.11.1 [cs].
   >

   ```

### 3.2 `Racket REPL`の終了

`Racket`を起動して`REPL`が動作している場合は、`REPL`が終了すると`Racket`も終了します。

`REPL`を終了させるには、次の方法があります。

| 終了方法 | 説明 | 備考 |
| --- | --- | --- |
| `EOF`入力 | 標準入力に`EOF`を入力する。`Windows`は`Ctrl+Z`、`WSL`は`Ctrl+D`で`EOF`を入力できる。| |
| `exit`関数 | `(exit)`と入力し、`exit`関数を実行する。 | |
| `exit`コマンド | `,exit`と入力し、`exit`コマンドを実行する。 | `XREPL`のみ実行可能。 |

### 3.3 `Racket REPL`

`Racket`を引数なしで実行すると、`REPL` (`Read-Eval-Print-Loop`)という対話型インタフェイスが起動します。
`REPL`実行時には、コマンドラインに`Racket`プログラムを入力できます。
`REPL`は、入力された`Racket`プログラムを評価して、即座に結果を返します。

これにより、`Racket`ではコマンドラインでインタラクティブにプログラミングができます。

### 3.4 `XREPL`

`XREPL` (`eXtended REPL`) は、通常の`REPL`を拡張した対話型インタフェイスです。
ヘルプ、シェル、終了などの基本機能から、外部ファイルのロード、エディタでの編集、デバッグ機能など、多岐にわたるメタコマンドによる機能拡張が特徴です。
`XREPL`を使いこなすことで、`Racket`プログラミングにおける生産性が向上します。

## 4. `XREPL`の基本操作

この章では、`XREPL`の簡単な操作方法を紹介します。

### 4.1 `EOF`による終了

`EOF`を入力して、`XREPL`を終了します。
次の手順で、`XREPL`を終了します:

1. 通常の`EOF`入力
  `Ctrl+D` (`Windows`では、`Ctrl+Z`)を入力する。

   ```bash
   Welcome to Racket v8.11 [cs].
   > [Ctrl+D]

   $
   ```

2. 入力途中での`EOF`入力
   入力途中の場合は、`Ctrl+C`で中断後に`EOF`を入力する。

   ```bash
   Welcome to Racket v8.11 [cs].
   > Hell [`Ctrl+C`]
   ; user break [,bt for context]
   > [`Ctrl+D`]

   $
   ```

3. `Ctrl+Z`によるサスペンド時の`EOF`入力
   `WSL`環境で`Ctrl+Z`を入力すると、`Racket`がサスペンドします。
   この場合は、`fg`コマンドで`Racket`に復帰後、`EOF`を入力します。

   ```bash
   Welcome to Racket v8.11 [cs].
   > [`Ctrl+Z`]

   [1]+  停止                  racket

   $ fg
   racket

   [`Ctrl+D`]

   $
   ```

### 4.2 基本的なメタコマンド

`XREPL`は、メタコマンドで拡張機能を使用できます。
主なメタコマンドは、次の通りです。

| メタコマンド | 説明 | 内容 |
| --- | --- | --- |
|,help | ヘルプ | 使用できるメタコマンドの一覧を表示します |
| ,exit | 終了 | Racket を終了し、コマンドラインに戻ります |
| ,shell | シェル | 指定したシェルコマンドを実行します。 ディレクトリの移動、表示などに使われます |
| ,edit | 編集 | 指定したファイルを OS 指定のエディタで編集します |

これ以外にも、さまざまなメタコマンドが用意されています。
詳細は、[`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/index.html)を参照してください。

### 4.3 過去の値の参照

`XREPL`では、過去の式の結果を`^`で参照できます。
`^`で 1つ前、`^^`で 2つ前の結果を参照でき、`^`をふやすごとにもう 1つ前の値が参照できます。
たとえば、次のように使用します:

```racket
> "こんにちは "
"こんにちは "

> (string-append ^ ^ "世界")
"こんにちは こんにちは 世界"

```

## おわりに

以上で、`Racket`の基本的な操作を説明しました。
ここまでの記事で、`Racket REPL`による簡単なプログラミング、および`Racket`の終了ができるようになりました。

参考資料を読むことで、`Racket`での拡張された`REPL`である`XREPL`を使いこなすこともできるでしょう。
`Racket`に親しみ、関数型プログラミングの学習を続けましょう。

それでは、Happy Hacking!

## 技術用語と注釈

- `Racket`:
  `Scheme`言語に基づいて開発された、教育および研究向けの関数型プログラミング言語。

- `WSL` (`Windows Subsystem for Linux`):
  `Windows`上で`Linux`のバイナリ実行ファイルをネイティブに実行できるようにする互換層。

- `REPL` (`Read-Eval-Print Loop`):
  プログラムのコードを一行ごとに入力し、それぞれの実行結果を即座に得られる対話型のプログラミング環境。

- `XREPL` (`eXtended REPL`):
  標準の`REPL`にエラートレース、外部ファイルの編集機能などを追加した強化版`REPL`

- `CLI` (`Command Line Interface`):
  コマンドラインや端末を通じてコンピューターを操作するためのテキストベースのユーザーインタフェイス。

- `Windows Terminal`:
  複数のコマンドラインツールやシェルをタブで管理できる`Windows`用のターミナルアプリケーション

## 参考資料

### Webサイト

- [`The Racket Guide`](https://docs.racket-lang.org/guide/):
  `Racket`の基本概念およびチュートリアルを提供するガイド。
- [`XREPL: eXtended REPL`](https://docs.racket-lang.org/xrepl/):
  機能拡張された`REPL`に関する詳細情報を提供する資料。
- [`Racket 公式ドキュメント`](https://docs.racket-lang.org/):
  `Racket`言語に関する包括的な情報を提供する公式ドキュメント。
