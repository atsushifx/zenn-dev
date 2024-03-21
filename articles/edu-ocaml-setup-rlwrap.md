---
title: "OCaml: rlwrapでOCamlのREPLを強化する"
emoji: "🐪"
type: "tech"
topics: [ "WSL", "OCaml", "環境構築", "rlwrap", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`rlwrap`を利用して`OCaml`の`REPL`の機能を強化する方法を紹介します。
`rlwrap`により、編集機能、ヒストリー機能、タブ補完機能が`OCaml`の`REPL`に追加され、より快適な開発体験を提供します。

## `rlwrap`とは

### `rlwrap`の概要

`rlwrap` (`readline wrapper`)は、アプリの`REPL`に編集機能やヒストリー機能などの機能拡張を行なうツールです。

### `rlwrap`の基本的な使い方

`rlwrap`の使い方はシンプルです。`rlwrap <app>`と入力するだけで、選択したアプリに対して強化された`REPL`機能を利用できます。
たとえば、`OCaml`を使う場合は`rlwrap ocaml`と入力します。

## `rlwrap`のセットアップ

### 環境変数の設定

環境変数`RLWRAP_HOME`は、`rlwrap`が使用するファイルを保存するディレクトリを指定します。
`XDG Base Directory`仕様にしたがい、`RLWRAP_HOME`に`$XDG_DATA_HOME/rlwrap`を設定します。

環境変数設定スクリプト`$XDG_CONFIG_HOME/envrc`に次の行を追加します:

```bash: $XDG_CONFIG_HOME/envrc
#  rlwrap
export RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"

```

### `rlwrap`のインストール

`rlwrap`のインストールは、パッケージマネージャー`brew`を利用して簡単に行なうことができます。
次のコマンドで、`rlwrap`をインストールします:

```bash
brew install rlwrap

```

## `OCaml`用の設定

### タブ補完ファイルの設定

`rlwrap`は、`$RLWRAP_HOME`下の`タブ補完ファイル(`completions`)を自動的に読み込み、ファイル内のキーワードをタブ補完します。

タブ補完ファイルのファイル名は、`<app>_completions`となります。
`OCaml`のコマンドは`ocaml`なので、タブ補完ファイルは`ocaml_completions`となります。

タブ補完ファイル`ocaml_completions`を gist に保全しました。下記に、`ocaml_completions`を載せますので利用してください。

@[gist](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e?file=ocaml_completions)

### ヒストリーファイルの作成

`rlwrap`は、`-f`オプションで`.`を指定することで、ヒストリーをもとにタブ補完します。
このとき、ヒストリーファイルが存在しないとエラーで`rlwrap`が終了してしまいます。
そのため、あらかじめ、ヒストリーファイルを作成しておきます。

次の手順で、ヒストリーファイルを作成します:

```bash
touch $RLWRAP_HOME/ocaml_history

```

### エイリアスの設定

エイリアスを設定し、`ocaml`コマンドで自動的に`rlwrap`を介して`REPL`を起動できるようにします。
次のコマンドをエイリアス設定ファイルに追加します:

```bash:$XDG_CONFIG_HOME/aliases
alias ocaml="rlwrap -f . ocaml "

```

## ターミナル (WSL)の再起動

ここまでで設定した環境変数を`WSL`に反映させるため、ターミナル`WSL`を再起動します。
次の手順で、ターミナルを再起動します。

1. ターミナルの終了
   `exit`を入力し、ターミナルを終了します:

   ```bash
   exit
   ```

2. WSL の起動
   `Windows Terminal`のプルダウンメニューで、`Debian`を選択します。
   ![Terminal-プルダウンメニュー](https://i.imgur.com/wAW3pvL.jpg)

## おわりに

`rlwrap`を使うことで、`OCaml`の`REPL`はより使いやすくなりました。

今後、`OCaml`で関数型プログラミングの勉強をするうえで力になるでしょう。
それでは、Happy Hacking!

## 技術用語と注釈

この記事で用いる技術用語について解説します。

- `rlwrap`:
  コマンドラインの入力行に対して編集機能や履歴管理、タブによる補完機能を提供するユーティリティ

- `REPL` (`Read-Eval-Print Loop`):
  プログラムを一行ずつ実行してその結果をすぐに見ることができる対話式のプログラミング環境

- `OCaml`:
  高度な型システムと効率的な実行速度を備え、型安全性やパターンマッチングを特徴とする関数型プログラミング言語

- `XDG Base Directory`:
  UNIX/Linux システムで設定ファイルを保存するディレクトリを決める標準的な仕様

- `RLWRAP_HOME`:
  `rlwrap`が設定ファイルやデータファイルを保存するディレクトリを決める環境変数

## 参考資料

### Webサイト

- [公式サイト](https://github.com/hanslub42/rlwrap):
  `rlwrap`の`GitHub`リポジトリ
