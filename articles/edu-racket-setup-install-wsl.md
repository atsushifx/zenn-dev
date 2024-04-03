---
title: "Racket: WSL上でRacketをセットアップする方法"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "WSL", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

WSL（Windows Subsystem for Linux）は、Windows上で Linux環境を実行できるツールです。
この記事では、WSL に関数型プログラミング言語`Racket`をセットアップし、関数型プログラミングの魅力に触れる方法を紹介します。

`XREPL`をインストールすることで、Racket にインタラクティブな機能が拡張されます。
Racket をインストールして、関数型プログラミングの世界を体験してみましょう。
Enjoy!

## 1. Racket のセットアップ

### 1.1 `brew` を使用した Racket のインストール

このセクションでは、WSL に`Homebrew`がセットアップ済みであることを前提とします。
`Homebrew`の設定方法は、[Homebrewのセットアップ](https://zenn.dev/atsushifx/articles/wsl2-brew-install)を参照してください。

`Homebrew`では、基本的な機能のみを含む`minimal-racket`をインストールできます。

次のコマンドで、`minimal-racket`をインストールします。

```bash
brew install minimal-racket

```

Racket が正常にインストールできたかどうかの確認は、次のようにします:

```bash
$ racket --version
Welcome to Racket v8.11.1 [cs].

```

バージョンが表示されれば、インストールに成功しています。

### 1.2 開発環境の設定

Racket は、`XDG Base Directory`仕様にしたがって設定ファイルやデータファイルを管理します。
`XDG Base Directory`については、[技術用語と注釈](#技術用語と注釈)を参照してください。

### 1.3 `.gitignore`の設定

Racket では、`$XDG_CONFIG_HOME/racket`下に設定ファイルを保存します。
同様に、ユーザー設定ファイルやロックファイルも上記ディレクトリに保存しますが、これらはリポジトリで共有する必要がないため、`.gitignore`ファイルに追加します。

次のように、`.gitignore`を設定します:

```:$XDG_CONFIG_HOME/.gitignore
# Racket
_lock*
racket-prefs.rktd

```

これにより、Racket が生成するロックファイルや状態ファイルが Git の追跡対象から除外されます。
以上で、`.gitignore`の設定は完了です。

### 1.4 `XREPL`のインストール

`Minimal Racket`には`REPL`という対話式インターフェイスがあります。
`REPL`によりコマンドラインから打ち込んだプログラムの結果が、即座に確認でき、インタレクティブな開発が可能です。
ただし、`Minimal Racket`の`REPL`に基本的な入力機能しかなく、プログラムの編集などができません。

そのため、`XREPL`拡張機能をインストールし、`REPL`に編集、ヒストリー、タブ補完機能を追加します。

`XREPL`をインストールするには、WSL に`pango`、`cairo`などのテキストレンダリングライブラリが必要です。
これらのライブラリをインストール後に、`XREPL`をインストールします。

次の手順で、`XREPL`拡張機能をインストールします。

1. 必須ライブラリのインストール
   次のコマンドで、`pango`,`cairo`などの必須ライブラリをインストールします:

   ```bash
   sudo apt install libpango-1.0-0 libcairo2 libpangocairo-1.0-0
   ```

2. `XREPL`のインストール
  `XREPL`はシステムとして使うため、`installation`スコープでインストールします。
   次のコマンドで、拡張機能をインストールします:

   ```bash
   raco pkg install --auto --scope installation xrepl
   ```

以上で、拡張機能のインストールは完了です。

## 2. Racketの起動と終了

### 2.1 Racket を起動する

Racket を起動するには、ターミナルからコマンドを実行します。

次のコマンドを実行します:

```bash
racket

```

起動に成功すると、次のようにメッセージとプロンプトが表示されます:

```bash
$ racket
Welcome to Racket v8.11.1 [cs].
>

```

### 2.2 Racketを終了する

以下の方法で Racket を終了できます。
`XREPL`をインストールしたため、`,`+コマンドで Racket が終了できます。

- `EOF` (`Ctrl+D`)の入力:
  `REPL`は`EOF`が入力されると終了します。`EOF`は、`Ctrl+D`で入力できます。

  ```racket
  Welcome to Racket v8.11.1 [cs].
  > [Ctrl+D]キー押下

  $
  ```

- `exit`関数の実行:
  `exit`関数を実行して Racket を終了します。関数として呼びだすため、`()`でくくる必要があります。

  ```racket
  Welcome to Racket v8.11.1 [cs].
  > (exit)

  $
  ```

- `exit`コマンドの実行:
  `XREPL`では`,<コマンド>`形式でコマンドを実行できます。終了コマンドは、`,exit`です。

  ```racket
  Welcome to Racket v8.11.1 [cs].
  > ,exit

  $
  ```

## おわりに

以上で、WSL に Racket をインストールし、基本的な設定を行なう方法を紹介しました。
Racket を通じて、関数型プログラミングの基礎から応用まで、幅広く学んでいくことができます。

下記の参考資料も活用して、学習を進めてください。
それでは、Happy Hacking!

## 技術用語と注釈

- **`WSL` (`Windows Subsystem for Linux`)**:
  Windows上で Linux環境を実行できるツール

- **`関数型プログラミング`**:
  プログラムの実行を数学的関数の評価として扱い、状態変化やデータ変更を避けるプログラミングパラダイム

- **`REPL` (`Read-Eval-Print Loop`)**:
  プログラムのコードを入力し、その評価結果を即座に得ることができる対話型の環境

- **`Racket`**:
  多様なプログラミングスタイルをサポートする関数型プログラミング言語

- **`Minimal Racket`**:
  Racket言語の基本的な実行環境と開発ツールのみを含み、最小限の機能を提供する軽量版 Racket パッケージ

- **`raco`**:
  Racket のパッケージマネージャーおよびコマンドラインツール

- **`Homebrew`**:
  `macOS`/`Linux`で使用できるパッケージマネージャーで、WSL にも対応している

- **`XREPL` (`eXtended REPL`)**:
   Racket の`REPL`を強化する拡張機能

- **`Expeditor` (`Expression Editor`)**:
  Racket の対話的インターフェイスで、入力中の式(=プログラム)を編集するエディタ

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/):
  Racket の公式サイト。Racket に関する全般的な情報を提供し、Racket の配布もしている。
- [Racket Documentation](https://docs.racket-lang.org/):
  Racket の公式ドキュメント。Racket の使い方、言語の特徴、開発ツールに関する詳細が載っている。
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/):
  Racket で使われている拡張`REPL`のドキュメント
- [Racketの環境設定ファイル／ディレクトリまとめ](https://zenn.dev/atsushifx/articles/edu-racket-setup-environment):
  Racket の環境設定用のファイル、ディレクトリ、環境変数のまとめ

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html)
- [How to Design Programs](https://htdp.org/)
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)
- [Beautiful Racket](https://beautifulracket.com/)
