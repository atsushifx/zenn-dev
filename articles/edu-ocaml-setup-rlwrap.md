---
title: "OCaml: rlwrapでOCamlのREPLを強化する"
emoji: "🐪"
type: "tech"
topics: [ "WSL", "OCaml", "環境構築", "rlwrap", "関数型プログラミング", ]
published: false
---

## はじめに

本記事では、`rlwrap`を使用して`OCaml`の`REPL`の機能を強化する方法を詳しく説明します。
`rlwrap`を活用することで、`OCaml`の`REPL`に編集機能、履歴機能、タブ補完機能を追加し、効率的かつ快適な開発体験を実現します。

## 1. `rlwrap`とは

### 1.1 `rlwrap`の概要

`rlwrap` (`readline wrapper`)は、任意のアプリケーションの`REPL`に対して編集機能や履歴管理機能を提供するツールです。

### 1.2 `rlwrap`の基本的な使い方

`rlwrap`を使用するには、`rlwrap <app>`の形式でコマンドを実行します。
たとえば、`OCaml`の場合は`rlwrap ocaml`と入力します。

## 2. `rlwrap`のセットアップ

### 2.1 環境変数の設定

環境変数`RLWRAP_HOME`は、`rlwrap`の設定ファイルやデータファイルを保存するディレクトリを指定します。
ここでは、`XDG Base Directory`仕様にしたがって`RLWRAP_HOME`に`$XDG_DATA_HOME/rlwrap`を設定し、設定やデータファイルを整理します。

環境変数を設定するには、`~/.config/envrc`に次を追加します:

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

### 3.1 タブ補完ファイルの設定

`rlwrap`は、`$RLWRAP_HOME`下のタブ補完ファイル(`completions`)を自動的に読み込み、ファイル内のキーワードを補完対象にします。
タブ補完ファイルの名前は、`<app>_completions`となります。`OCaml`の場合、このファイルは`ocaml_completions`となり、`OCaml`のモジュール、関数、型などが補完対象となります。

タブ補完ファイル`ocaml_completions`を [GitHubのGist](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e)に公開しています。

`Gist`の`ocaml_completions`は、次のようになります。

@[gist](https://gist.github.com/atsushifx/b72b101a4339223a2a8e9e8b779dae8e?file=ocaml_completions)

### 3.2 ヒストリーファイルの作成

`rlwrap`は、`-f`オプションで`.`を指定すると、ヒストリーファイルをタブ補完に利用します。
このとき、ヒストリーファイルが存在しないとエラーで`rlwrap`が終了してしまいます。
そのため、あらかじめ、ヒストリーファイルを作成しておきます。

次の手順で、ヒストリーファイルを作成します:

```bash
touch $RLWRAP_HOME/ocaml_history

```

### 3.3 エイリアスの設定

エイリアスを設定し、`ocaml`コマンドを実行する際に`rlwrap`を介して`ocaml`を起動させます。
次のコマンドをエイリアス設定ファイルに追加します:

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

## おわりに

`rlwrap`の導入により、`OCaml`の`REPL`操作がより快適になりました。
これにより、`OCaml`を使った関数型プログラミングの学習も、より効率的になるでしょう。

関数型プログラミングの学習を進め、プログラマーとしてのスキルアップを目指しましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語について解説します。

- `rlwrap`:
  コマンドラインの入力行に対して編集機能や履歴管理、タブによる補完機能を提供するユーティリティ

- `RLWRAP_HOME`:
  `rlwrap`が設定ファイルやデータファイルを保存するディレクトリを決める環境変数

- タブ補完ファイル:
  `rlwrap`がタブ補完に使用するコマンドや関数名などが記載されたファイル

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
