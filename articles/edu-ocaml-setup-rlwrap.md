---
title: "OCaml: rlwrapでOCamlのREPLを強化する"
emoji: "🐪"
type: "tech"
topics: [ "WSL", "OCaml", "環境構築", "rlwrap", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`rlwrap`を使用して`OCaml`の`REPL`の機能を強化する方法を説明します。
`rlwrap`を利用することで、コマンドラインの編集機能などが追加でき、`OCaml REPL`の使い勝手を向上させることができ、効率的なコーディングが可能になります。

## 1. `rlwrap`とは

### 1.1 `rlwrap`の概要

`rlwrap` (`readline wrapper`)は、指定したアプリケーションの`REPL` (`Read-Eval-Print Loop`)に編集機能などを追加するツールです。
この`REPL`に`rlwrap`を使用することで、ユーザーは過去に実行したコマンドの履歴を簡単に再利用したり、コマンドライン上での文字列の編集をより直感的に行なうことができます。

### 1.2 `rlwrap`の基本的な使い方

`rlwrap`の使い方はシンプルです。
`rlwrap <app>`のようにアプリケーションを指定して実行します。これで、編集機能やヒストリー機能などの`rlwrap`の機能を利用できます。
`OCaml`の場合は、`rlwrap ocaml`で`OCaml`の`REPL`に編集機能やヒストリー機能を追加します。

## 2. `rlwrap`のセットアップ

### 2.1 環境変数の設定

環境変数`RLWRAP_HOME`を設定し、`rlwrap`の設定ファイルやデータファイルを保存するディレクトリを指定します。
`XDG Base Directory`仕様にしたがい、`$XDG_DATA_HOME/rlwrap`を設定します。
これにより、`rlwrap`が利用する設定ファイルやデータファイルの格納場所を一元管理できます。

この記事の環境では、環境変数の設定は`$XDG_CONFIG_HOME/envrc`スクリプトで行っています。
そのため、`~/.config/envrc`に次を追加します:

```bash: ~/.config/envrc
#  rlwrap
export RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"

```

### 2.2 `rlwrap`のインストール

`rlwrap`のインストールは、パッケージマネージャーを利用して簡単に行なうことができます。
この記事では、Linux にも対応しているパッケージマネージャー`Homebrew`を使って`rlwrap`をインストールします。

次のコマンドで、`rlwrap`をインストールします:

```bash
brew install rlwrap

```

## 3. `OCaml`用の設定

`OCaml`用にタブ補完ファイルを設定することで、`OCaml`の`REPL`で使用するコマンドや型などを迅速に補完できます。
また、ヒストリーファイルを作成し、オプションを指定することで過去に入力したキーワードをタブで補完できるようになります。

### 3.1 タブ補完ファイルの設定

`rlwrap`は、タブ補完ファイル(`completions`)を使用して、コマンドや関数、型などを補完します。
この機能により、`OCaml`の`REPL`で使用するコマンドやコーディング時に使用する型などを迅速に入力できます。

タブ補完ファイルの名前は、`<app>_completions`となります。`OCaml`の場合、このファイルは`ocaml_completions`となり、`OCaml`のモジュール、型などや`Ocaml REPL`用のコマンドが補完対象となります。

`OCaml`用のタブ補完ファイル[`ocaml_completions`](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e)を`GitHub`の`Gist`で公開しています。

`Gist`の`ocaml_completions`は、次のようになります。

@[gist](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e?file=ocaml_completions)

### 3.2 ヒストリーファイルの作成

`rlwrap`は、入力の履歴をヒストリーとして保存します。
`rlweap`に、`-f .`とオプションをつけて起動すると、ヒストリーファイルをタブ補完に利用し、以前に入力したコマンドや関数をタブで補完できるようになります。
ただし、ヒストリーファイルが存在しないとエラーで`rlwrap`が終了してしまいます。
そのため、あらかじめ、ヒストリーファイルを作成しておきます。

次の手順で、ヒストリーファイルを作成します:

```bash
touch $RLWRAP_HOME/ocaml_history

```

### 3.3 エイリアスの設定

`OCaml`をより便利に使用するために、`rlwrap`を介して`OCaml`を起動するエイリアスを設定します。
この設定をすることで、毎回`rlwrap`を手動で入力する手間が省けます。

この記事の環境では、エイリアスの設定は`エイリアス設定スクリプト (`$XDG_CONFIG_HOME/aliases`)で行っています。
次のエイリアスをエイリアス設定スクリプトに追加します:

```bash:$XDG_CONFIG_HOME/aliases
alias ocaml="rlwrap -f . ocaml "

```

## 4. シェルの再起動

ここまでで設定した環境変数を`WSL`に反映させるため、シェルを再起動します。
次の手順で、シェルを再起動します:

1. シェルの終了:
   `exit`を入力し、シェルを終了します:

   ```bash
   exit
   ```

2. 新規 WSL セッションの開始:
   `Windows Terminal`のプルダウンメニューで、`Debian`を選択します。
   ![Terminal-プルダウンメニュー](https://i.imgur.com/wAW3pvL.jpg)

以上で、シェルが再起動します。これにより、環境変数の設定が反映され`rlwrap`によって`OCaml REPL`が強化されます。

## おわりに

`rlwrap`の導入により、`OCaml`の`REPL`操作がより快適になりました。
`rlwrap`を使用した`OCaml`を活用することで、関数型プログラミングの学習もより効率的になります。

関数型プログラミングの学習を進め、プログラマーとして成長しましょう。
それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語について解説します。

- `rlwrap`:
  コマンドラインの入力行に対して編集機能や履歴管理、タブによる補完機能を提供するユーティリティ

- `RLWRAP_HOME`:
  `rlwrap`が設定ファイルやデータファイルを保存するディレクトリを決める環境変数

- タブ補完ファイル:
  `rlwrap`がタブ補完に使用するコマンドや関数名などが記載されたファイル

- `WSL` (`Windows Subsystem for Linux`):
  Windows上で Linux のバイナリ実行ファイルを直接実行できるようにする互換レイヤー

- `Homebrew`:
  `macOS` および Linux で利用可能なパッケージマネージャー

- `REPL` (`Read-Eval-Print Loop`):
  プログラムを一行ずつ実行してその結果をすぐに見ることができる対話式のプログラミング環境

- `OCaml`:
  高度な型システムと効率的な実行速度を備え、型安全性やパターンマッチングを特徴とする関数型プログラミング言語

- `XDG Base Directory`:
  UNIX/Linux システムで設定ファイルを保存するディレクトリを決める標準的な仕様

## 参考資料

### Webサイト

- [公式サイト](https://github.com/hanslub42/rlwrap):
  `rlwrap`の`GitHub`リポジトリ
