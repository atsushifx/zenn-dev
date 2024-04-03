---
title: "Racket: WSL上でRacketをセットアップする方法"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "WSL", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

WSL（Windows Subsystem for Linux）を用いることで、Windows上でも Linux環境を手軽に利用できます。
この記事では、WSL上に関数型プログラミング言語`Racket`をセットアップし、関数型プログラミングの魅力に触れる方法を紹介します。

`XREPL`の導入により、`Racket`の機能を拡張し、よりインタラクティブにできます。
`Racket`をインストールし、関数型プログラミングをはじめましょう。
Enjoy!

## 1. Racket のセットアップ

### 1.1 `brew` を使用した Racket のインストール

WSL上で`Homebrew`を使用して、`Racket`をインストールする方法を紹介します。
`Homebrew`は`Linux`環境に対応しており、WSL上でも同じように利用可能です。

`Racket`をインストールする前に、`Homebrew`が正しくセットアップされていることを確認してください。
詳しいことは、[Homebrewのセットアップ](https://zenn.dev/atsushifx/articles/wsl2-brew-install)を参照してください。

`Homebrew`では、基本的な機能のみを含む`Minimal Racket`をインストールできます。
次のコマンドで、`Minimal Racket`をインストールします。

```bash
brew update
brew install minimal-racket

```

Racket が正常にインストールできたかどうかの確認は、次のようにします:

```bash
racket --version
Welcome to Racket v8.11.1 [cs].

```

バージョンが表示されれば、インストールに成功しています。

### 1.2 開発環境の設定

`XDG Base Directory`仕様にしたがって、Racket は設定ファイルやデータファイルを管理します。
`XDG Base Directory`については、[技術用語と注釈](#技術用語と注釈)を参照してください。

### 1.3 `.gitignore`の設定

Racket では、`$XDG_CONFIG_HOME/racket`下に設定ファイルを保存します。
同様に、ユーザー設定ファイルやロックファイルも上記ディレクトリに保存しますが、これらはリポジトリで共有する必要がないため、`.gitignore`ファイルに追加します。

次のように、`.gitignore`を設定します:

```plaintext
# Racket
_lock*
racket-prefs.rktd

```

これで、Racket が生成するロックファイルや状態ファイルが Git の追跡対象から除外されます。
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

Racket を起動するには、ターミナルで次のコマンドを実行します:

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

Racket を終了する方法は、次の通りです。

- `EOF`の入力
- `exit`関数の実行
- `,exit`コマンド (`XREPL`がインストールされている場合)

それぞれの終了方法は、次のようになります。

- `EOF` (`Ctrl+D`)の入力:
  `EOF`は、`Ctrl+D`で入力できます。

  ```racket
  Welcome to Racket v8.11.1 [cs].
  > ← [Ctrl+D]キー押下

  $
  ```

- `exit`関数の実行:
  関数として呼びだすため、`()`でくくる必要があります。

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
Racket は関数型プログラミングを学ぶのに理想的な言語であり、関数型プログラミングの基礎から応用まで、幅広く学んでいくことができます。

下記の参考資料も活用して、関数型プログラミングの力を身につけましょう。
それでは、Happy Hacking!

## 技術用語と注釈

- **`WSL` (`Windows Subsystem for Linux`)**:
  Windows上で Linux環境を実行可能にするツール。開発環境のセットアップや Linux 固有のアプリケーションの実行に利用される

- **`関数型プログラミング`**:
  数学的関数の概念に基づき、状態変化やデータ変更を避けるプログラミング手法。コードの可読性と再利用性の向上に寄与

- **`REPL` (`Read-Eval-Print Loop`)**:
  コードを入力し、その評価結果を即座に得られる対話型のプログラミング環境。試行錯誤や学習に最適

- **`Racket`**:
  多様なプログラミングスタイルをサポートする関数型プログラミング言語。言語設計や言語教育にも広く用いられる

- **`Minimal Racket`**:
  Racket言語の基本的な実行環境と開発ツールのみを提供する軽量版。シンプルなプロジェクトや学習用途に適している

- **`raco`**:
  Racket のパッケージマネージャー。ライブラリやツールのインストール、プロジェクト管理に使用される

- **`Homebrew`**:
  `macOS`および`Linux`で使用されるパッケージマネージャー。WSL を含むさまざまな環境で利用可能

- **`XREPL` (`eXtended REPL`)**:
  Racket の`REPL`機能を強化する拡張機能。編集、ヒストリー、タブ補完などの機能を追加し、開発体験を向上させる

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/):
  Racket の公式サイト。Racket に関する全般的な情報を提供し、Racket の配布もしている。
- [Racket Documentation](https://docs.racket-lang.org/):
  Racket の公式ドキュメント。Racket の使用方法、言語の特徴、開発ツールの詳細情報が掲載されている。初心者から上級者までが参照できる豊富なガイドが含まれる。
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/):
  Racket で使われている拡張`REPL`のドキュメント。より強化された REPL環境の設定方法や利用可能な追加機能について説明されている。
- [Racketの環境設定ファイル／ディレクトリまとめ](https://zenn.dev/atsushifx/articles/edu-racket-setup-environment):
  Racket の環境設定に関するガイド。設定ファイル、ディレクトリ構造、環境変数について詳しく解説され、Racket のカスタマイズや管理に役立つ情報が提供される。

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html):
  Racket の基本的な概念と使い方を解説したガイドブック。Racket 初心者が言語の基礎を学ぶのに最適な資料。
- [How to Design Programs](https://htdp.org/):
  プログラム設計の原理と方法を学ぶための教科書。関数型プログラミングを中心に、段階的なプログラム設計技法を体系的に説明している。
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html):
  ンピュータサイエンスの基礎とプログラミングの原則を扱った古典的なテキスト。深い洞察と理論的背景に基づき、プログラミングとは何か、どのように考えるべきかを探求する。
- [Beautiful Racket](https://beautifulracket.com/):
  Racket を使用して独自のプログラミング言語を設計し、実装する方法を学ぶことができる実践的なガイド。初心者から中級者に向けて、言語の作成プロセスを段階的に解説する。
