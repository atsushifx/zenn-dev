---
title: "Windowsに関数型プログラミング言語「Racket」をインストールする方法"
emoji: "🎾"
type: "tech"
topics: ["プログラミング言語", "Racket", "関数型プログラミング", "環境構築", ]
published: false
---

## はじめに

この記事では、Windows 環境に関数型プログラミング言語「Racket」をインストールする手順を紹介します。
Racket はその柔軟性と強力な機能で知られ、関数型プログラミングの学習に適しています。

この記事に従えば、Windows に Racket をインストールし、どのディレクトリからでも Racket を起動、終了できるようになります。
これにより、Racket言語を使って関数型プログラミングを学習する準備が整います。

## 1. Racketについて

Racket は Scheme に基づく多機能な関数型プログラミング言語です。
さらに、オブジェクト指向プログラミングもサポートしているマルチパラダイムな言語です。

Racket の特徴としては:

- 関数型プログラミング: Racket は関数型プログラミング言語であり、関数が第一級オブジェクトとして扱われます。
- マクロシステム: Racket は強力なマクロシステムを持ちます。
- 統合開発環境のサポート: Racket には統合開発環境(IDE)`Dr Racket`が組み込まれており、手軽に Racket のプログラミングが始められます。
- ツールによるサポート: Racket にはコマンドラインツールである`raco`があり、さまざまな開発タスクをサポートします。

が上げられます。

## 2. Racketのインストール

Windows 環境に`Racket`をインストールする方法を解説します。

### 2.1 `winget`を使ったRacketのインストール

Racket は、Windows 公式パッケージマネージャー`winget`でインストールできます。
ここでは、`--location`オプションを使用して指定したディレクトリ (`c:\lang\racket`) にインストールします。

PowerShell で、以下のコマンドを実行します:

```powershell
winget install Racket.Racket --location C:\lang\racket
```

以上で、Racket のインストールは完了です。

### 2.2 環境変数の設定

環境変数`PLTUSERHOME`,`PLTADDONDIR`を設定することで、Racket の設定とアドオンを`XDG Base Directory`規格のディレクトリに保存します。
これにより、Racket の設定は Git で管理できるようになります。

設定には、以下のコマンドを実行します:

```powershell
[System.Environment]::SetEnvironmentVariable("PLTUSERHOME", $env:XDG_CONFIG_HOME, "User")
[System.Environment]::SetEnvironmentVariable("PLTADDONDIR", $env:XDG_DATA_HOME+"/Racket/addon", "User")

```

これにより、`PLTUSERHOME`は`XDG_BASE_DIRECTORY`のホームディレクトリ(`XDG_CONFIG_HOME`)に設定します。
同様に`PLTADDONDIR`はデータディレクトリ下の`addon`ディレクトリ (`$XDG_DATA_HOME/racket/addon`)に設定します。

以上で、環境変数の設定は完了です。

### 2.3 `.gitignore`の設定

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

### 2.4 Pathの設定

Racket を動かすために、Path に Racket 動作用のパスを追加します。
次の手順で、Path を追加します。

1. [システムのプロパティ]ダイアログを開く:
    下記のコマンドを実行する

    ```powershell
    systempropertiesadvanced.exe
    ```

    [システムのプロパティ]ダイアログが表示される
    ![システムのプロパティ](https://i.imgur.com/zfaLYCw.png)

2. [環境変数]ダイアログを開く:
    \[環境変数\]ボタンをクリックする。[環境変数]ダイアログが表示される
    ![環境変数](https://i.imgur.com/r75yAaY.png)

3. [システム環境変数]の`Path`を編集:
    "システム環境変数"の`Path`を選び、[編集(I)]をクリックする。
    \[システムの環境変数\]ダイアログが表示される
    ![Pathの編集](https://i.imgur.com/ujPkIoU.png)

4. パスを追加:
    \[新規\]をクリックし、Racket をインストールしたディレクトリ (`C:\lang\racket`) を追加する

5. [ユーザー環境変数]の`Path`を編集:
    "ユーザー環境変数"の`Path`を選び、[編集(E)]をクリックする。
    \[ユーザーの環境変数\]ダイアログが表示される
    ![Pathの編集](https://i.imgur.com/ey9OT8O.png)

6. パスを追加:
    \[新規\]をクリックし、パッケージバイナリ用のディレクトリ (`%PLTADDONDIR%\<version>`) を追加する。
    **注意**:
    パスの`<version>`は、実際にインストールした Racket のバージョン番号に書き換えてください。
    Racket のバージョンは、`racket --version`で確認できます。

7. ダイアログの終了:
    \[OK\]をクリックし、すべてのダイアログを終了する

以上で、Path の設定は完了です。

### 2.5 Windowsの再起動

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

インストールした Racket には、`XREPL`と呼ばれる機能拡張した`REPL`が使われています。
そのため、以下の方法で Racket を終了できます。

- `EOF` (`Ctrl+D`)の入力:
  `REPL`は`EOF`が入力されると終了します。`EOF`は、`Ctrl+D`で入力できます。

  ```powershell
  Welcome to Racket v8.11.1 [cs].
  > # \[Ctrl+D]キー押下

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
Racket を学習することで、新たなプログラミングパラダイムである関数型プログラミングへの造詣を深めることができるでしょう。

強力な`REPL`機能は、Racket プログラミングの強力さを体感させてくれます。
`raco`による機能拡張は、既存の開発環境においても Racket の開発をサポートします。

Racket の学習を通じて、関数型プログラミングの深い理解を得ることができるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/) :  Racket の公式サイト
- [Racket Documentation](https://docs.racket-lang.org/) : Racket の公式ドキュメント
- [`XREPL`: `eXtended REPL`](https://docs.racket-lang.org/xrepl/) : Racket で使われている拡張`REPL`のドキュメント

### 本

- [Racket Guide](https://docs.racket-lang.org/guide/index.html)
- [How to Design Programs](https://htdp.org/)
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.htmll)
- [Beautiful Racket](https://beautifulracket.com/)
