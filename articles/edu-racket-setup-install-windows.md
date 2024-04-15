---
title: "Racket: WindowsへのRacketのインストールと設定方法"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`Windows`に`Racket`をインストールし、基本的な設定を行なう方法を説明します。
設定後、ターミナルから`Racket`を起動し、すぐに関数型プログラミングの学習をはじめられます。

## 1. Racketについて

### 1.1 目的

このセクションでは、`Racket`の特徴を解説します。

### 1.2 特徴

- 関数型プログラミング言語
- プログラム内で新しい言語機能を定義できる強力なマクロシステム
- 公式による統合開発環境`DrRacket`のサポート
- コマンドラインツール`raco`による開発タスクのサポート

## 2. 前提条件

### 2.1 インストールディレクトリ

通常、`Racket`は`C:\Program Files\Racket`にインストールされますが、空白を含む`Path`を避けるため、この記事では`c:\lang\racket`にインストールします。

### 2.2 設定ディレクトリ

環境設定用のディレクトリは、`XDG Base Directory`仕様にしたがって配置します。
通常、初期設定ファイルは`$USERPROFILE` (`C:\Users\<ユーザー名>`)下に保存しますが、ここには`Windows`用のさまざまなフォルダやアプリケーションの設定用フォルダが存在しています。
これらのフォルダとの混乱を避けるために`XDG Base Directory`仕様に従い、`~\.config\racket`にファイルを配置します。

上記の設定に合わせ、ほかの環境設定ディレクトリも変更します。
どのディレクトリを変更するかの詳細は、[Racketの環境設定ファイル／ディレクトリまとめ](https://zenn.dev/atsushifx/articles/edu-racket-setup-environment)を参照してください。

## 3. Racketのインストール

`Windows`公式パッケージマネージャー`winget`を用い、`Racket`をインストールします。
そのためには、`Windows Package Manager`ツールがシステムにインストールされている必要があります。

### 3.1 `winget`を使ったRacketのインストール

`winget`は、`Windows`の公式パッケージマネージャーで、コマンドラインから`Racket`をインストールできます。
`c:\lang\racket`下にインストールするため、`--location`オプションでインストール先ディレクトリを指定します。

次のコマンドで`Racket`をインストールします:

```powershell
winget install Racket.Racket --location C:\lang\racket
```

インストール後に`racket --version`で、正常にインストールされたかを確認します:

```powershell
c:\lang\racket\racket --version

```

次のように `Racket`のバージョンが表示されれば、正常にインストールされています。

```powershell
Welcome to Racket v8.12 [cs].

```

### 3.2 Pathの設定

すべてのディレクトリから`Racket`を起動できるように、`環境変数Path`に`c:\lang\racket`を追加します。
`PowerShell`で次のコマンドを実行します:

<!-- markdownlint-disable line_length -->
```powershell
[System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "Machine")+";c:\lang\racket", "Machine")

```
<!-- markdownlint-enable -->

## 4. Racketの環境設定

### 4.1 環境変数の設定

`Racket`の設定ファイルを`XDG Base Directory`に準拠させるため、関連する環境変数を設定します。

環境変数の設定は、次のようになります。

| 環境変数 | 変数説明 | 設定値| 説明 |
| --- | --- | --- | --- |
| `PLTUSERHOME` | Racket用ホームディレクトリ | `$XDG_CONFIG_HOME+"/racket"` | 初期設定ファイルなどを保存 |
| `PLTADDONDIR` | ユーザーアドオンディレクトリ | `$XDG_DATA_HOME+"/racket"` |  ユーザー用にダウンロードしたアドオンを保存 |

次のコマンドで環境変数を設定します:

```powershell
[System.Environment]::SetEnvironmentVariable("PLTUSERHOME", $env:XDG_CONFIG_HOME+"/racket", "User")
[System.Environment]::SetEnvironmentVariable("PLTADDONDIR", $env:XDG_DATA_HOME+"/racket", "User")

```

### 4.2 `config.rktd`の設定

`Racket`には`config.rktd`という設定ファイルがあり、`Racket`のさまざまな設定を管理できます。
ここでは、アドオンをダウンロードしたときにファイルをキャッシュするディレクトリを`XDG Base Directory`に準拠するように設定します。

コンフィグファイル `config.rktd`の場所: `c:\lang\racket\etc\config.rktd`
次のように、`config.rktd`を編集します:

```racket: c:/lang/racket/etc/config.rkd
#hash(
  (build-stamp . "")
  (catalogs . ("https://download.racket-lang.org/releases/8.12/catalog/" #f))
  (doc-search-url . "https://download.racket-lang.org/releases/8.12/doc/local-redirect/index.html")
  (default-scope . "user")
  (download-cache-dir . "C:/Users/atsushifx/.local/cache/racket/download-cache") ;; ← 追加
 )

```

上記のようにすることで、キャッシュファイルが`~/.config`ディレクトリ下に保存されることを防ぎ、システムをきれいなまま保ちます。

**注意**:

<!-- textlint-disable japanese/sentence-length, ja-technical-writing/sentence-length -->
- `downloadc-cache-dir`はフルパスで書く必要があるため、`C:/Users/<ユーザー名>/.local/cache`と`XDG_CACHE_HOME`を展開して、そのあとに`/racket/download-cache`を追加しています。
- 設定には`Racket`のバージョン番号が含まれているため、`Racket`がバージョンアップした場合には`config.rktd`を書き換える必要があります。

<!-- textlint-enable -->

### 4.3 `.gitignore`の設定

`Racket`ホームディレクトリは、`GitHub`の`dotfiles`リポジトリでの管理下にあります。
`Racket`ホームディレクトリ上には、初期設定ファイル、ユーザー設定ファイル、アドオン用のダウンロードキャッシュが存在します。
これらのうち、`Racket`のセッション情報を含むユーザー設定ファイル、および一時ファイルを含むダウンロードキャッシュは`Git`の管理下から外す必要があります。
これを実現するため、`$XDG_CONFIG_HOME`下の`.gitignore`に上記ファイルを除外する設定を追加します。

次の内容を`.gitignore`に追加します:

``` : .gitignore
# Racket
_lock*
**/download-cache/
racket-prefs.rktd

```

### 4.4 アドオン用Pathの設定

`アドオン`によっては、実行用に`ランチャー`を作成するものがあります。
ユーザーアドオンの場合は、アドオンディレクトリ+`Racket`バージョン番号下にランチャーを作成します。
この記事では、`Racket 8.12`をインストールしたので、`$PLTADDONDIR+"/8.12"`となります。

次のコマンドで`アドオン用Path`を環境変数`Path`に追加します:

<!-- markdownlint-disable line_length -->
```powershell
[System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User")+";"+$env:PLTADDONDIR+"/8.12", "User")

```
<!-- markdownlint-enable -->

### 4.5 ターミナルの再起動

設定した`Path`や環境変数は、現在の`PowerShell`セッションに即座には反映されません。
新しくターミナルを起動して、設定が反映された`PowerShell`セッションを使う必要があります。

次の手順で、ターミナルを再起動します:

1. `powershell`の終了:
   次のコマンドを実行して、`powershell`を終了します。

   ```powershell
   exit
   ```

2. `ターミナル`の起動:
  [Windows+R]として[ファイル名を指定して実行]ダイアログを開き、`wt`と入力してターミナルを起動します。

   ```windows
   wt
   ```

## 5. WindowsでのRacketの起動と終了

### 5.1 Racket の起動

次の手順で、`Racket`を起動します。
ターミナルに次のコマンドを入力して、`Racket`を起動します:

```powershell
racket
```

`Racket`の起動に成功すると、`REPL`が開始されて次のメッセージとプロンプトが表示されます:

```powershell
> racket
Welcome to Racket v8.12 [cs].
>

```

### 5.2 Racketの終了

`Racket`をファイルを指定せずに起動すると、`REPL`が開始します。
`REPL`は、次の方法で終了できます。

- `EOF` (`Ctrl+D`)の入力:
  `REPL`は`EOF`が入力されると終了します。`EOF`は、`Ctrl+D`で入力できます。

  ```powershell
  Welcome to Racket v8.12 [cs].
  > [Ctrl+D]キー押下

  $
  ```

- `exit`関数の実行:
  `exit`関数を実行して`Racket`を終了します。関数として呼びだすため、`()`でくくる必要があります。

  ```powershell
  Welcome to Racket v8.12 [cs].
  > (exit)

  $
  ```

- `exit`コマンドの実行:
  `XREPL`では`,<コマンド>`形式でコマンドを実行できます。終了コマンドは、`,exit`です。

  ```powershell
  Welcome to Racket v8.12 [cs].
  > ,exit

  $
  ```

## おわりに

ここまでで、`Racket`のインストールおよび環境設定、起動と終了まで説明しました。
結果、`Windows`上で基本的な`Racket`プログラミングができるようになりました。

`Racket`の`REPL`を使えば、コマンドラインで`Racket`プログラムを実行し、インタラクティブなプログラミングを楽しめます
次は、実際に`Racket`でプログラミングをしてみましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語を解説します:

- `Racket`:
  `Scheme`に基づいていて、教育、研究、実験的なプロジェクトに適しているく関数型プログラミング言語
- `REPL` (`Read-Eval-Print-Loop`):
  コマンドラインからコードを入力し、即座に結果を得られる対話的プログラミングを実現する環境
- 関数型プログラミング:
  関数を中心に構築され、データの不変性と副作用の最小化を特徴とするプログラミングパラダイム
- `DrRacket`:
  プログラミングの基本から上級テクニックまで学べる`Racket`公式の統合開発環境(`IDE`)
- `raco`:
  `Racket`のパッケージの管理やプロジェクトのビルドなどをサポートするコマンドラインツール
- `XDG Base Directory`:
  `UNIX`/`Linux`において設定ファイル、データファイルを保存先ディレクトリを定め、システムの整理と管理を容易にする標準ディレクトリ仕様
- マクロシステム:
  コンパイルがコード生成や構文拡張をし、プログラミング言語の柔軟性と機能性を強化するシステム
- `winget`:
  `Windows`でコマンドラインからアプリケーションのインストールや管理が行える公式パッケージマネージャー

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/):
  `Racket`の特徴、使用法、ダウンロード情報を提供する公式サイト。
- [Racket Documentation](https://docs.racket-lang.org/):
  `Racket`の全機能について詳細に説明する公式ドキュメント。初心者から専門家まで参考になる。
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/):
  `Racket`の拡張`REPL`に関するガイド。機能拡張やカスタマイズ方法を詳解。
- [Racketの環境設定ファイル／ディレクトリまとめ](https://zenn.dev/atsushifx/articles/edu-racket-setup-environment):
  設定ファイル、環境変数、ディレクトリ構造などの`Racket`用環境設定の解説。

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html):
  `Racket`の基礎から応用までを分かりやすく解説した初心者向けのガイドブック。
- [How to Design Programs](https://htdp.org/):
  関数型プログラミングを核としたプログラム設計の技法を、初級から上級まで段階的に学べる教科書。
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html):
  コンピュータサイエンスとプログラミングの原則に関する深い理解を提供する古典的なテキスト。論理的な思考とプログラミングスキルの向上に役立つ。
- [Beautiful Racket](https://beautifulracket.com/)
  `Racket`を用いて自分だけのプログラミング言語を設計・実装するための実践的なガイド。初心者も中級者も、プログラミング言語の作り方を段階的に学べる。
