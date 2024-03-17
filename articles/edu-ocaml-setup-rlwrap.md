---
title: "OCaml: rlwrapでOCamlのREPLを強化する"
emoji: "🐪"
type: "tech"
topics: [ "WSL", "OCaml", "環境構築", "rlwrap", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`rlwrap`を使用して`OCaml`の`REPL`に編集機能やタブ補完機能を追加する方法を紹介します。
`rlwrap`は行入力に、編集機能やヒストリー機能、タブ補完機能を追加するツールです。
素の`OCaml`では`REPL`に原始的な編集機能しかありませんが、`rlwrap`により十分な編集機能が使えます。

## `rlwrap`とは

### `rlwrap`の概要

`rlwrap` (`readline wrapper`)は、アプリの`REPL`に編集機能やヒストリー機能などの機能拡張を行なうツールです。

### `rlwrap`の基本的な使い方

`rlwrap`の使い方は簡単です。`rlwrap <app>`のように、`rlwrap`に続けて、使用したいアプリを入力します。
今回は、`OCaml`を動かしたいので`rlwrap ocaml`のように使用します。

## `rlwrap`のセットアップ

### 環境変数の設定

`rlwrap`は環境変数`RLWRAP_HOME`で指定したディレクトリにヒストリーファイルなどを保存します。
`XDG Base Directory`にしたがい、`RLWRAP_HOME`に`$XDG_DATA_HOME/rlwrap`を設定します。

環境変数設定スクリプト`$XDG_CONFIG_HOME/envrc`に次の行を追加します:

```bash: $XDG_CONFIG_HOME/envrc
#  rlwrap
export RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"

```

以上で、環境変数の設定は終了です。

### `rlwrap`のインストール

`rlwrap`は、パッケージマネージャー`brew`からインストールできます。
次のコマンドで、`rlwrap`をインストールします:

```bash
brew install rlwrap

```

以上で、`rlwrap`のインストールは終了です。

## `OCaml`用の設定

### タブ補完ファイルの設定

`rlwrap`は、`$RLWRAP_HOME`下の`タブ補完ファイル(`completions`)を自動的に読み込み、ファイル内のキーワードをタブ補完します。

タブ保管ファイルのファイル名は、`<app>_completions`となります。
`OCaml`のコマンドは`ocaml`なので、タブ補完ファイルは`ocaml_completions`となります。

タブ補完ファイル`ocaml_completions`を gist に保全しました。下記に、`ocaml_completions`を載せますので利用してください。

@[gist](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e?file=ocaml_completions)

### ヒストリーファイルの作成

`rlwrap`は、`-f`オプションで`.`を指定することで、ヒストリーをもとにタブ補完します。
このとき、ヒストリーファイルが存在しないとエラーで`rlwrsap`が終了してしまいます。
そのため、あらかじめ、ヒストリーファイルを作成しておきます。

次の手順で、ヒストリーファイルを作成します:

```bash
touch $RLWRAP_HOME/ocaml_history

```

以上で、ヒストリーファイルの作成は終了です。

### エイリアスの設定

以上で、`rlwrap`を使って`ocaml`を動かせるようになりました。
次に alias を設定して、自動的に編集機能やヒストリー機能つきの`ocaml`が起動するようにします。

次の行を、エイリアス設定ファイル`aliases`に追加します:

```bash:$XDG_CONFIG_HOME/akuases
alias ocaml="rlwrap -f . ocaml "

```

以上で、エイリアスの設定は終了です。

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

以上で、WSL の再起動は完了です。

## おわりに

`rlwrap`を使って`OCaml`に編集機能を追加する方法を紹介しました。
`rlwrap`を使うことで、`OCaml`の`REPL`は実用に耐えるものとなりました。

今後、`OCaml`で関数型プログラミングの勉強をするうえで力になるでしょう。
それでは、Happy Hacking!
