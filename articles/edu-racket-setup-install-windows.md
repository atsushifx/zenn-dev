---
title: "Racket: WindowsへのRacketのインストールと設定"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`Windows`に関数型プログラミング言語`Racket`をインストールし、設定する方法を説明します。
その結果、ターミナルから`Racket`を起動できるようになり、`Racket`で関数型プログラミングが学習できます。

## 1. Racketについて

`Racket`は`Scheme`に基づくマルチパラダイムなプログラミング言語です。
関数型プログラミングが基本であり、オブジェクト指向プログラミングもサポートしています。

`Racket`の特徴として:

- 関数型プログラミング:
  `Racket`は関数型プログラミング言語であり、関数が第一級オブジェクトとして扱われます。
- マクロシステム:
  `Racket`には強力なマクロシステムが搭載されています。
- 統合開発環境のサポート:
  `Racket`には統合開発環境(IDE) `DrRacket`が組み込まれており、手軽に`Racket`のプログラミングが始められます。
- ツールによるサポート:
  `Racket`にはコマンドラインツールである`raco`があり、さまざまな開発タスクをサポートします。

が挙げられます。

## 2. 前提条件

### 2.1 インストールディレクトリ

この記事では、`Racket`を`c:\lang\Racket`下にインストールします。
通常は`C:\Program Files\Racket`にインストールされますが、ディレクトリが空白を含むため`c:\lang\racket`に変更しています。

### 2.2 設定ディレクトリ

環境設定用のディレクトリは、`XDG Base Directory`仕様にしたがって配置します。
通常では、初期設定ファイルが`C:\Users\<ユーザー名>`下に保存されます。
このディレクトリ下にはファイルを保存したくないため、`XDG Base Directory`仕様にしたがって`~\.config\racket`下にファイルを配置します。

上記の設定に合わせ、ほかの環境設定ディレクトリも変更します。
どのディレクトリを変更するかの詳細は、[Racketの環境設定ファイル／ディレクトリまとめ](https://zenn.dev/atsushifx/articles/edu-racket-setup-environment)を参照してください。

## 3. Racketのインストール

### 3.1 `winget`を使ったRacketのインストール

`winget`は、`Windows`の公式パッケージマネージャーで、コマンドラインから`Racket`をインストールできます。
`Racket`を`c:\lang\racket`下にインストールするため、`--location`オプションでインストール先ディレクトリを指定します。

次のコマンドを実行して、`Racket`をインストールします:

```powershell
winget install Racket.Racket --location C:\lang\racket
```

`racket --version`を実行して、正常にインストールできたかを確認します。
次のコマンドを実行します:

```powershell
c:\lang\racket\racket --version

```

次のように `Racket`のバージョンが表示されれば、正常にインストールされています。

```powershell
Welcome to Racket v8.12 [cs].

```

### 3.2 Pathの設定

どのディレクトリからでも`Racket`を起動できるように、環境変数`Path`に`c:\lang\racket`を追加します。

`PowerShell`で次のコマンドを実行します:

<!-- markdownlint-disable line_length -->
```powershell
[System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "Machine")+";c:\lang\racket", "Machine")

```
<!-- markdownlint-enable -->

## 4. Racketの環境設定

### 4.1 環境変数の設定

`Racket`の設定ファイルを`XDG Base Directory`に準拠させるため、環境変数を設定します。

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

`Racket`は、各種ディレクトリやコマンドラインツール`raco`用の設定をコンフィグファイル`config.rktd`で設定しています。
パッケージ用ダウンロードキャッシュディレクトリを`XDG`Base Directory`準拠にするため、config.rktd`で設定します。

`config.rktd`は、Racket インストールディレクトリ下の`etc`ディレクトリにあります。
この記事では、`c:\lang\racket\etc\config.rktd`となります。

`config.rktd`を次のように書き換えます。

```racket:c:/lang/racket/etc/config.rkd
#hash(
  (build-stamp . "")
  (catalogs . ("https://download.racket-lang.org/releases/8.12/catalog/" #f))
  (doc-search-url . "https://download.racket-lang.org/releases/8.12/doc/local-redirect/index.html")
  (default-scope . "user")
  (download-cache-dir . "C:/Users/atsushifx/.local/cache/racket/download-cache") ;; ← 追加
 )

```

**注意**:

<!-- textlint-disable japanese/sentence-length, ja-technical-writing/sentence-length -->
- `downloadc-cache-dir`はフルパスで書く必要があるため、`C:/Users/<ユーザー名>/.local/cache`と`XDG_CACHE_HOME`を展開して、そのあとに`/racket/download-cache`を追加しています。
- 設定には`Racket`のバージョン番号が含まれているため、`Racket`がバージョンアップした場合には`config.rktd`を書き換える必要があります。

<!-- textlint-enable -->

### 4.3 `.gitignore`の設定

`Racket`ホームディレクトリは、`GitHub`の`dotfiles`リポジトリでの管理下にあります。
`Racket`のセッションを保存しているユーザー設定ファイル、一時ファイルを保存するダウンロードキャッシュなどは、`.gitignore`により git の管理から外します。

次の内容を、`$XDG_CONFIG_HOME`下の`.gitignore`に追加します。

``` :.gitignore
# Racket
_lock*
**/download-cache/
racket-prefs.rktd

```

### 4.4 アドオン用Pathの設定

アドオンによっては、実行用にランチャーを作成するものがあります。
ユーザーアドオンの場合は、アドオンディレクトリ+`Racket`バージョン番号下にランチャーを作成します。
この記事では、`Racket 8.12`をインストールしたので、`$PLTADDONDIR+"/8.12"`となります。

次のコマンドで`アドオン用Path`を環境変数`Path`に追加します:

<!-- markdownlint-disable line_length -->
```powershell
[System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User")+";"+$env:PLTADDONDIR+"/8.12", "User")

```
<!-- markdownlint-enable -->

### 4.5 ターミナルの再起動

設定した`Path`や環境変数は、現在の`PowerShell`セッションでは使用できません。
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
ターミナルで、次のコマンドを実行します:

```powershell
racket
```

`Racket`の起動に成功すると、`REPL`が起動して次のメッセージとプロンプトが表示されます:

```powershell
> racket
Welcome to Racket v8.12 [cs].
>

```

### 5.2 Racketの終了

`Racket`をファイルを指定せずに起動すると、`REPL`が起動します。
起動した`REPL`は、次の方法で終了できます。

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
これにより `Windows`上で基本的な`Racket`プログラミングができるようになりました。

`Racket`の`REPL`を使えば、コマンドラインで`Racket`プログラムを実行でき、インタラクティブなプログラミングを体験できます。
次は、実際に`Racket`でプログラミングをしてみましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語を解説します:

- `Racket`:
  `Scheme`に基づく関数型プログラミング言語で、学術、教育、実験的プログラムなどの広範に使用
- 関数型プログラミング:
  数学における関数をもとにプログラミングを行なうプログラミングパラダイム
- `DrRacket`:
  `Racket`における初心者から研究者まで使える公式の統合開発環境(`IDE`)
- `raco`:
  `Racket`においてパッケージの管理やプロジェクト管理をサポートするコマンドラインツール
- `XDG Base Directory`:
  `UNIX`/`Linux`において設定ファイル、データファイルを保存するディレクトリを定める仕様
- マクロシステム:
  コンパイル時にコードの生成などを行い、言語の構文を柔軟に拡張するシステム
- `winget`:
  `Windows`でコマンドライン上でアプリケーションの管理が行える公式パッケージマネージャー

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/) :  Racket の公式サイト
- [Racket Documentation](https://docs.racket-lang.org/) : Racket の公式ドキュメント
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/) : Racket で使われている拡張`REPL`のドキュメント

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html)
- [How to Design Programs](https://htdp.org/)
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)
- [Beautiful Racket](https://beautifulracket.com/)
