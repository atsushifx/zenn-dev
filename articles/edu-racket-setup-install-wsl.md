---
title: "WSL上のDebianに関数型プログラミング言語「Racket」をインストールする"
emoji: "🎾"
type: "tech"
published: true
topics: [ "WSL", "Racket", "環境構築", "関数型プログラミング", ]
published: true
---

## はじめに

この記事では、WSL (Windows Subsystem for Linux) 上の Debian に関数型プログラミング言語「Racket」をインストールする方法を紹介します。
Racket のインストールには、パッケージマネージャー`Homebrew`を使用します。
`Homebrew`のセットアップ方法については、[こちらの記事](https://zenn.dev/atsushifx/articles/wsl2-brew-install)を参照してください。

`Homebrew`を使用するとパッケージをユーザー権限でインストールするため、OS への影響を最小限に抑えることができます。
また、リポジトリの更新が迅速なため、最新バージョンの Racket を利用できるのが大きなメリットです。

## 重要キーワードと注釈

- **`WSL` (`Windows Subsystem for Linux`)**:
  Windows上で Linux のバイナリ実行ファイルを直接実行できるようにする互換層。

- **`関数型プログラミング`**:
  プログラムの実行を数学的関数の評価として扱い、状態変化やデータ変更を避けるプログラミングパラダイム

- **`REPL` (`Read-Eval-Print Loop`)**:
  プログラムのコードを入力し、その評価結果を即座に得ることができる対話型の環境

- **`Racket`**:
  多様なプログラミングスタイルをサポートする関数型プログラミング言語

- **`minimal Racket`**:
  Racket言語の基本的な実行環境と開発ツールのみを含み、最小限の機能を提供する軽量版 Racket パッケージ

- **`raco`**:
  Racket のパッケージマネージャーおよびコマンドラインツール

- **`Homebrew`**:
  `macOS`/`Linux`で使用できるパッケージマネージャーで、WSL にも対応している

- **`config.rktd`**:
  Racket の設定ファイル

- **`XREPL` (`eXtended REPL`)**:
   Racket の`REPL`を強化する拡張機能

- **`Expeditor` (`Expression Editor`)**:
  Racket の対話的インタフェースで、入力中の式(=プログラム)を編集するエディタ

## 1. Racket のインストール

### 1.1 `brew` を使用した Racket のインストール

`Homebrew`は、`macOS`/`Linux`で利用可能なパッケージマネージャーであり、WSL上でも使用できます。
`brew`では、リポジトリに Racket の最小実行環境である`minimal Racket`が登録されています。
この記事では、`brew`を使って上記の`minimal Racket`をインストールします。
統合開発環境`Dr Racket`を含めた完全版 Racket を使いたい場合は、`minimal Racket`をインストールしたあとに追加のパッケージをインストールします。

以下のコマンドを実行し、Racket をインストールします:

```shell
brew install racket
```

上記コマンドで、`minimal Racket`をインストールします。

Racket が正常にインストールできたかどうかの確認は、次のようにします:

```shell
$ racket --version
Welcome to Racket v8.11.1 [cs].

```

上記のようにバージョンが表示されれば、インストールに成功しています。

### 1.2 `config.rktd`の設定

Racket の設定は、`config.rktd`ファイルに保存されます。
この設定ファイルは、Racket および Racket 用開発ツールである`raco`の動作をカスタマイズするために使用されます。

今回は、`raco`用にダウンロードキャッシュを`XDG_CACHE_HOME`下にダウンロードするように設定します。
あわせて、インストールするパッケージをユーザー用にインストールさせます。

`config.rktd`に、次の設定を追加します。

```racket: /home/linuxbrew/.linuxbrew/Cellar/minimal-racket/<version>/.bottle/etc/racket/config.rktd
  (default-scope . "user")
  (download-cache-dir . "/home/<user>/.local/cache/racket/download-cache")

```

**注意**:

- `brew`を使用してインストールしたため、上記のディレクトリとなります。
- `<version>`は、インストールした Racket のバージョン番号です。
- `<user>`は、Racket をインストールしたユーザーアカウントです。

以上で、`config.rktd`の設定は完了です。

### 1.3 `.gitignore`の設定

Racket が使用する設定ファイルや状態ファイルは、`XDG_CONFIG_HOME`下に保存されます。
この中の状態ファイルは、Racket によって毎回書き換えられるため、リポジトリに保存しません。
そのため、`.gitignore`で明示的に除外し、リポジトリをクリーンに保ちます。

以下のように、`.gitignore`を設定します:

```git:$XDG_CONFIG_HOME/.gitignore
# Racket
_lock*
racket-prefs.rktd

```

これにより、Racket が生成するロックファイルや状態ファイルが Git の追跡対象から除外されます。
以上で、`.gitignore`の設定は完了です。

### 1.4 拡張機能のインストール

Racket には、対話的にプログラムを入力して結果を表示する`REPL`機能があります。
ただし、`minimal Racket`の`REPL`では、入力しているプログラムの編集ができません。
そのため、`REPL`に編集機能や拡張コマンドなどの機能拡張をするパッケージをインストールします。

次の手順で、拡張機能をインストールします。

1. 必須ライブラリのインストール
   拡張機能を動かすためには、テキストレンダリングなどのライブラリが必要です。
   次のコマンドで、ライブラリをインストールします:

   ```shell
   sudo apt install libpango-1.0-0 libcairo2 libpangocairo-1.0-0
   ```

2. 拡張機能のインストール
   編集機能用のパッケージ`expeditor`と、`REPL`の機能拡張パッケージ`xrepl`をインストールします。
   次のコマンドで、拡張機能をインストールします:

   ```shell
   raco pkg install --auto --scope installation expeditor xrepl
   ```

以上で、拡張機能のインストールは完了です。

## 2. Racketの起動と終了

### 2.1 Racket を起動する

次の手順で、Racket を起動します。
ターミナルで、次のコマンドを実行します:

```shell
racket
```

起動に成功すると、次のようにメッセージとプロンプトが表示されます:

```shell
$ racket
Welcome to Racket v8.11.1 [cs].
>

```

上記のように表示されれば、Racket のインストールは完了です。

### 2.2 Racketを終了する

インストールした Racket は、以下の方法で Racket を終了できます。
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

以上で、Racket の終了ができます。

## おわりに

WSL上で、Racket をインストールし、基本的な設定を行なう方法を紹介しました。
これにより、Racket を使って関数型プログラミングを行なうことができます。

これから、Racket を使用して関数型プログラミングの学習を進めていきましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/) :  Racket の公式サイト。Racket に関する全般的な情報を提供し、Racket の配布もしている。
- [Racket Documentation](https://docs.racket-lang.org/) : Racket の公式ドキュメント。Racket の使い方、言語の特徴、開発ツールに関する詳細が載っている。
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/) : Racket で使われている拡張`REPL`のドキュメント

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html)
- [How to Design Programs](https://htdp.org/)
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)
- [Beautiful Racket](https://beautifulracket.com/)
