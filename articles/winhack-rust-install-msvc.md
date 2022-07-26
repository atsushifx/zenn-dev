---
title: "WindowsにMSVC版Rustをインストールする"
emoji: "🦾"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Windows", "開発環境", "Rust", "Tips" ]
published: false
---

## tl;dr

* `Rust`をインストールする前に、ビルドツールをインストールする必要がある
* `Rust`のインストールは、`winget`で一発
* 環境変数を登録しておけば、好きなディレクトリに`Rust`をインストールできる

以上

## はじめに

tl;dr で説明したとおりなんですが、さすがにもっと詳しく説明します。
Windows では、Rust (MSVC版) をインストールするために`Visual Studio Build Tool`^(以下、ビルドツール)^をインストールする必要があります。
このビルドツールをインストールする部分で、ちょっとはまったので後々のためにメモしておきます。
そのほかに、Rust を~/.cargo 意外にインストールするための Tips も載せておきます。

## 環境設定

### 環境変数の設定

Rust では次の環境変数を設定すると、Rust のインストール先を変えることができます。
`CARGO_HOME`には、Rust そのもののインストール先を指定します。
`RUSTUP_HOME`には、Rust のインストーラー・パッケージマネージャー`rustup`が扱うデータの保存先を指定します。
自分の場合は、次のようになりました。

  | 環境変数 | 値 | メモ
  |-- |-- |-- |
  | CARGO_HOME | c:\lang\rust | c:\lang\下に各プログラミング言語をまとめる |
  | RUSTUP_HOME | %XDG_DATA_HOME%/rustup | rustupが扱うデータは、XDG DATA HOME下に作成 |

## ビルドツールのインストール

### Build Toolsのインストール

Rust のコンパイル、リンクに必要なため、Microsoft Visual Studio の Build Tools をインストールします。
インストールの手順は、次の通り

  1. ビルドツールのダウンロード
    [Visual Studioのダウンロード](https://visualstudio.microsoft.com/ja/downloads/)ページにアクセスし、下の方の"Visual Studio 2022用のツール"のところにある[Build Tools for Visual Studio 2022](https://aka.ms/vs/17/release/vs_BuildTools.exe)をダウンロードします。

  2. ビルドツールのインストール
    ダウンロードしたインストーラを実行し、ビルドツールをインストールします。
    最低限、`C++ Build Tools コア機能`と`Windows 10 SDK`が必要です。

以上で、ビルドツールのインストールは終了です。

### Team Explorerのインストール

Rust には関係ないのですが、ビルドツールには Team Explorer が含まれていません。そのため、`Developer PowerShell`などのツールを実行するとエラーが発生します。
エラーを回避するために、次の手順で`Team Explorer`をインストールします。

  1. `Team Explorer`インストーラーのダウンロード
    [Visual Studioのダウンロード](https://visualstudio.microsoft.com/ja/downloads/)ページにアクセスし、[Visual Studio Team Explorer](https://aka.ms/vs/17/release/vs_TeamExplorer.exe)をダウンロードします。

  2. `Team Explorer`のインストール
  ダウンロードしたインストーラーを実行し、Team Explorer をインストールします。

以上で、Team Explorer のインストールは終了です。

## Rustのインストール

### Rustをインストールする

Rust は winget~(Windows 公式パッケージマネージャー)~に登録されているので、winget を使って Rust をインストールします。
次の手順で、Rust をインストールします。

1. winget で rustup をインストール。
`Windows Terminal`で次のコマンドを実行します。

``` :Windows Terminal
> winget install rustlang.rustup

```

2. rust のインストール
rustup が実行され、rust をインストールします。

``` PowerShell: rustup
info: profile set to 'default'
info: default host triple is x86_64-pc-windows-msvc
info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
info: latest update on 2022-07-19, rust version 1.62.1 (e092d0b6b 2022-07-16)
info: downloading component 'cargo'
info: downloading component 'clippy'
info: downloading component 'rust-docs'
info: downloading component 'rust-std'
info: downloading component 'rustc'
info: downloading component 'rustfmt'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
info: installing component 'rust-std'
info: installing component 'rustc'

```

3. Path の設定
インストールされた rust のツールを使うため、環境変数`Path`に`%CARGO_HOME%/bin`を追加します。
その後、設定を反映させるために PC を再起動します。

4. `rustc`の動作チェック
`rustc --version`とし、`rustc`が動くかチェックします。

``` PowerShell:
> rustc --version
rustc 1.62.1 (e092d0b6b 2022-07-16)

```

以上で、Rust のインストールは終了です。

## まとめ

自分がちょっとつまったところなどもメモしながら、Rust のインストール方法をまとめてみました。
これで Windows 上でも Rust の開発ができます。
Windows 上でも Rusy を使った便利ツールが出てくるといいですね。

それでは、Happy hacking.
