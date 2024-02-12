---
title: "WSL上に関数型プログラミング言語「Racket」をインストールする"
emoji: "☕"
type: "tech"
topics: [ "WSL", "Racket", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

## Racket のインストール

### `brew` を使用した Racket のインストール

`Homebrew`は、`macOS`/`Linux`に対応したパッケージマネージャーで WSL でも使用できます。
Racket も`brew`のリポジトリに登録されているので、`brew`コマンドでインストールできます。

次のコマンドで、Racket をインストールします:

```bash
brew install racket
```

以上で、Racket のインストールは終了です。

Racket が正常にインストールできたかどうかの確認は、次のようにします。

```bash
$ racket --version
Welcome to Racket v8.11.1 [cs].

$
```

上記のようにバージョンが表示されれば、インストールに成功しています。

### `config.rkd`の設定

Racket では、ライブラリ、拡張機能をパッケージとして提供しています。
パッケージ関連の設定は、`minimal-racket/<version1>/.bottle/etc/racket/config.rktd`にハッシュとして保存されているので、次のように書き換えます。

```racket:minimal-racket/<version>/.bottle/etc/racket/config.rktd
  (default-scope . "user")
  (download-cache-dir . "/home/<user>/.local/cache/racket/download-cache")

```

**注意**:
`<version>`は、インストールした Racket のバージョン番号です。
`<user>`は、Racket をインストールしたユーザーアカウントです。

### `.gitignore`の設定

Git が管理しないディレクトリやファイルを指定します。
Racket では、状態ファイル、一時ファイルなどを、Git リポジトリから除外します。

```git:$XDG_CONFIG_HOME/.gitignore
# Racket
_lock*
racket-prefs.rktd

```

以上で、`.gitignore`の設定は完了です。

### `XREPL`のインストール

`XREPL`は、Racket の`REPL`にヒストリーや行編集機能を追加する機能拡張パッケージです。
次の手順で、`XREPL`をインストールします。

1. 必須ライブラリのインストール
   パッケージをインストールするときに、`pango`,`cairo`というライブラリを使用します。
   次のコマンドで、ライブラリをインストールします:

   ```bash
   sudo apt install libpango-1.0-0 libcairo2 libpangocairo-1.0-0
   ```

2. `XREPL`のインストール:
   次のコマンドで、`XREPL`をインストールします:

   ```bash
   raco pkg install --auto --scope installation xrepl
   ```

以上で、`XREPL`のインストールは終了です。

## 3. Racketの起動と終了

インストールに成功すると、Racket を動かすことができます。

### 3.1 Racket を起動する

次の手順で、Racket を起動します。
ターミナルで、次のコマンドを実行します:

```bash
racket
```

起動に成功すると、次のようにメッセージとプロンプトが表示されます:

```bash
$ racket
Welcome to Racket v8.11.1 [cs].
>

```

上記のように表示されれば、Racket のインストールは完了です。

### 3.2 Racketを終了する

インストールした Racket は、以下の方法で Racket を終了できます。
`XREPL`をインストールしたため、`,`+コマンドで Racket が終了できます。

- `EOF` (`Ctrl+D`)の入力:
  `REPL`は`EOF`が入力されると終了します。`EOF`は、`Ctrl+D`で入力できます。

  ```bash
  Welcome to Racket v8.11.1 [cs].
  > [Ctrl+D]キー押下

  $
  ```

- `exit`関数の実行:
  `exit`関数を実行して Racket を終了します。関数として呼びだすため、`()`でくくる必要があります。

  ```bash
  Welcome to Racket v8.11.1 [cs].
  > (exit)

  $
  ```

- `exit`コマンドの実行:
  `XREPL`では`,<コマンド>`形式でコマンドを実行できます。終了コマンドは、`,exit`です。

  ```bash
  Welcome to Racket v8.11.1 [cs].
  > ,exit

  $
  ```

以上で、Racket の終了ができます。

## おわりに
