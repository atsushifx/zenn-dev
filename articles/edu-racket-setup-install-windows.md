---
title: "Windowsに関数型プログラミング言語「Racket」をインストールする"
emoji: "🎾"
type: "tech"
topics: ["プログラミング言語", "Racket", "関数型プログラミング", "環境構築", ]
published: true
---

## はじめに

この記事では、Windows に関数型プログラミング言語「Racket」をインストールする手順について紹介します。

以下の手順で Windows に Racket をインストールすれば、どこからでも Racket を起動し、終了できるようになります。
これにより、Racket言語での関数型プログラミング学習を開始できます。

## 重要キーワードと注釈

- 関数型プログラミング言語:
  関数を第一級オブジェクトとして扱い、不変性や副作用の少ないプログラミングスタイルを実現する言語。

- マクロシステム:
  Racket において、開発者が言語の構文を拡張し、新しい構文をできる機能。

- `XDG Base Directory`:
  UNIX/Linux システムで使用される、ユーザーの設定ファイルやデータファイルを整理し保存するためのディレクトリ構造の規格。Windows ではこの規格に準じた管理を行なうために、`XDG`環境変数を設定します。

- `Dr Racket`:
  Racket プログラミング言語専用の統合開発環境。コードの編集、実行、デバッグを 1つのアプリケーション内で行なうことができ、プログラミング学習者からプロフェッショナルまで幅広くサポートします。

- `raco`:
  Racket のコマンドラインツールで、パッケージ管理やプロジェクトのビルド、プログラムの実行など、開発に関連する多様なタスクをサポートします。

- `winget`:
  Windows の公式パッケージマネージャー。コマンドラインからソフトウェアを直接インストールできるツールです。

## 1. Racketについて

Racket は Scheme に基づくマルチパラダイムなプログラミング言語です。
関数型プログラミングを基本にしていますが、オブジェクト指向プログラミングもサポートしています。

Racket の特徴としては:

- 関数型プログラミング: Racket は関数型プログラミング言語であり、関数が第一級オブジェクトとして扱われます。
- マクロシステム: Racket は強力なマクロシステムを持ちます。
- 統合開発環境のサポート: Racket には統合開発環境(IDE)`Dr Racket`が組み込まれており、手軽に Racket のプログラミングが始められます。
- ツールによるサポート: Racket にはコマンドラインツールである`raco`があり、さまざまな開発タスクをサポートします。

が上げられます。

## 2. Racketのインストール

Windows 環境に`Racket`をインストールする方法を解説します。

### 2.1 `winget`を使ったRacketのインストール

`winget`は Windows の公式パッケージマネージャーで、コマンドラインから直接ソフトウェアをインストールできるツールです。
Racket にも対応しており、`winget`を使用して Racket をインストールできます。

今回は、`--location`オプションを付加して`c:\lang\racket`下に Racket をインストールします。

PowerShell上で、以下のコマンドを実行します:

```powershell
winget install Racket.Racket --location C:\lang\racket
```

このコマンドは、`winget`を使用して`c:\lang\racket`に Racket をインストールします。

Racket が正常にインストールできたかどうかの確認は、次のようにします。

```powershell
$ racket --version
Welcome to Racket v8.11.1 [cs].

```

以上のようにバージョンが表示されれば、正常にインストールされています。

### 2.2 環境変数の設定

環境変数`PLTUSERHOME`,`PLTADDONDIR`を設定することで、Racket の設定とアドオンを`XDG Base Directory`規格のディレクトリに保存します。
Racket の設定を`XDG Base Directory`で管理すると、設定ファイルを Git/GitHub で管理できるようになります。
これにより、Racket プログラミングにおける可搬性が向上します。

設定には、以下のコマンドを実行します:

```powershell
[System.Environment]::SetEnvironmentVariable("PLTUSERHOME", $env:XDG_CONFIG_HOME, "User")
[System.Environment]::SetEnvironmentVariable("PLTADDONDIR", $env:XDG_DATA_HOME+"/Racket", "User")

```

これにより、`PLTUSERHOME`は`XDG_BASE_DIRECTORY`のホームディレクトリ(`XDG_CONFIG_HOME`)に設定します。
同様に`PLTADDONDIR`はデータディレクトリ下の`addon`ディレクトリ (`$XDG_DATA_HOME/racket/addon`)に設定します。

以上で、環境変数の設定は完了です。

### 2.3 `config.rkd`の設定

Racket では、ライブラリや機能拡張をパッケージという形で提供しています。
パッケージ関連の設定は、`c:/lang/racket/etc/config.rkd`にハッシュとして保存されているので、次のように書き換えます。

```racket:c:/lang/racket/etc/config.rkd
#hash(
  (build-stamp . "")
  (catalogs . ("https://download.racket-lang.org/releases/8.11.1/catalog/" #f))
  (default-scope . "user")
  (doc-search-url . "https://download.racket-lang.org/releases/8.11.1/doc/local-redirect/index.html")
  (download-cache-dir . "C:/Users/atsushifx/.local/cache/racket/download-cache")
)

```

以上で、`config.rkd`の設定は終了です。

### 2.4 `.gitignore`の設定

`.gitignore`に、Racket の状態ファイル、一時ファイル、ダウンロードキャッシュなどを指定します。

Git が管理しないディレクトリやファイルを指定します。
Racket では、状態ファイル、一時ファイル、ダウンロードキャッシュなどを、Git リポジトリから除外します。

```git:$XDG_CONFIG_HOME/.gitignore
# Racket
_lock*
*/download-cache*
racket-prefs.rktd

```

以上で、`.gitignore`の設定は完了です。

### 2.5 Pathの設定

Racket を動かすために、Path に Racket 動作用のパスを追加します。
なお、アドオン用のディレクトリには Racket のバージョン番号が含まれます。
`racket --version`としてバージョンを確認し、それにあわせた path を設定してください。
次の手順で、Path を追加します。

1. [システムのプロパティ]ダイアログを開く:
   下記のコマンドを実行する

   ```powershell
   systempropertiesadvanced.exe
   ```

   [システムのプロパティ]ダイアログが表示される
   ![システムのプロパティ](https://i.imgur.com/zfaLYCw.png)
   *システムのプロパティ*

2. [環境変数]ダイアログを開く:
   \[環境変数\]ボタンをクリックする。[環境変数]ダイアログが表示される
   ![環境変数](https://i.imgur.com/r75yAaY.png)
   *環境変数*

3. [システム環境変数]の`Path`を編集:
   "システム環境変数"の`Path`を選び、[編集(I)]をクリックする。
   \[システムの環境変数\]ダイアログが表示される
   ![Pathの編集](https://i.imgur.com/ujPkIoU.png)
   *環境変数: システムPath*

4. パスを追加:
   \[新規\]をクリックし、Racket をインストールしたディレクトリ (`C:\lang\racket`) を追加する
   ![Pathの編集](https://i.imgur.com/ujPkIoU.png)
   *環境変数: システムPath*

5. [ユーザー環境変数]の`Path`を編集:
   "ユーザー環境変数"の`Path`を選び、[編集(E)]をクリックする。
   \[ユーザーの環境変数\]ダイアログが表示される
   ![Pathの編集](https://i.imgur.com/ey9OT8O.png)
   *環境変数: ユーザーPath*

6. パスを追加:
   \[新規\]をクリックし、パッケージバイナリ用のディレクトリ (`%PLTADDONDIR%\<version>`) を追加する。
   ![Pathの編集](https://i.imgur.com/ey9OT8O.png)
   *環境変数: ユーザーPath*

   **注意**:
   パスの`<version>`は、実際にインストールした Racket のバージョン番号に書き換えてください。
   Racket のバージョンは、`racket --version`で確認できます。

7. ダイアログの終了:
   \[OK\]をクリックし、すべてのダイアログを終了する

以上で、Path の設定は完了です。

### 2.6 Windowsの再起動

環境変数の設定や Path の変更をシステム全体に反映させるためには、Windows の再起動が必要です。
次の手順で、Windows を再起動します。

1. 再起動の選択
   \[スタートメニュー]を開き、\[シャットダウン]メニューで\[再起動]を選択します。

2. Windows の再起動
   Windows が再起動します。

以上で、Windows の再起動は完了です。

## 3. Windows で Racket を動かす

インストールに成功すると、Windows上で Racket を動かすことができます。

**注意**:
Racket の操作は、ターミナルのコマンドラインから行います。
この章では、コマンドラインの基本的な操作に慣れていることを前提とします。

### 3.1 Racket を起動する

次の手順で、Racket を起動します。
ターミナルで、次のコマンドを実行します:

```powershell
racket
```

起動に成功すると、次のようにメッセージとプロンプトが表示されます:

```powershell
$ racket
Welcome to Racket v8.11.1 [cs].
>

```

上記のように表示されれば、Racket のインストールは完了です。

### 3.2 Racketを終了する

インストールした Racket は、以下の方法で Racket を終了できます。
Racket には、`XREPL`という強化された`REPL`機能が含まれているため、`,`+コマンドで Racket が終了できます。

- `EOF` (`Ctrl+D`)の入力:
  `REPL`は`EOF`が入力されると終了します。`EOF`は、`Ctrl+D`で入力できます。

  ```powershell
  Welcome to Racket v8.11.1 [cs].
  > [Ctrl+D]キー押下

  $
  ```

- `exit`関数の実行:
  `exit`関数を実行して Racket を終了します。関数として呼びだすため、`()`でくくる必要があります。

  ```powershell
  Welcome to Racket v8.11.1 [cs].
  > (exit)

  $
  ```

- `exit`コマンドの実行:
  `XREPL`では`,<コマンド>`形式でコマンドを実行できます。終了コマンドは、`,exit`です。

  ```powershell
  Welcome to Racket v8.11.1 [cs].
  > ,exit

  $
  ```

以上で、Racket の終了ができます。

## おわりに

以上で、Windows に Racket をインストールし、起動と終了までできるようになりました。
これで Racket を使用して、関数型プログラミングの学習ができるようになりました。

Racket と関数型プログラミングの学習を通じて、プログラミングの理解を深め、より複雑な問題を効率的に解決できる能力を身につけましょう。

それでは、Happy Hacking!

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
