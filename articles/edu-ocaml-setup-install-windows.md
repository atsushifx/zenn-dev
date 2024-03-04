---
title: "OCaml: Windows環境でOCamlをセットアップする"
emoji: "🐪"
type: "tech"
topics: [ "学習", "関数型プログラミング", "環境構築", "Windows", ]
published: false
---

## はじめに

この記事では、Windows 環境で関数型プログラミング言語`OCaml`を容易にセットアップする方法を紹介します。
`DkML`インストーラーを使用することで、`OCaml`のビルドとインストールを手軽に自動化できます。

`OCaml`は、ML ファミリーに属する関数型プログラミング言語で、型推論、パターンマッチング、モジュールシステムなどを特徴とし、型安全性と高パフォーマンスを提供します。

## 技術用語

この記事で取り上げる重要な技術用語を以下に解説します。

- `OCaml`: 型推論、パターンマッチング、モジュールシステムを特徴とする関数型プログラミング言語であり、型安全性と高いパフォーマンスを提供している
- `DkML`: `OCaml` のインストールを Windows 環境で自動化するツール
- `opam`: `OCaml` のパッケージ管理ツールで、ライブラリやツールのインストールやバージョン管理を簡単に行える
- `XDG Base Directory`: UNIX 系 OS のディレクトリ標準仕様で、設定やデータファイルを統一的に配置する
- `Visual Studio BuildTools`: コマンドラインで使用する開発ツールセット、`OCaml` のビルドに使用される
- `utop`: `OCaml`の`REPL`拡張パッケージで、高度な編集機能や補完機能を提供する

## 1. 前提条件

この記事を実行する際には、以下の条件を満たしていることが必要です。

- `winget`コマンドが使用可能であること
- `OCaml`は、`c:\lang\ocaml`以下にインストールされること
- 設定ファイルやデータファイルは`XDG Base Directory`仕様に従うこと
  `XDG Base Directory`: UNIX 系 OS のディレクトリ標準仕様。Windows でも、この仕様に従うことで設定ファイルを統一的に管理できる
- `XDG Base Directory`の仕様にしたがった各環境変数が設定されていること。
- `opam`のファイルは、`$XDG_DATA_HOME/opam`以下に配置されること。

以上です。

## 2. 初期設定

<!-- textlint-disable ja-technical-writing/ja-no-redundant-expression -->
`OCaml`をインストールする前に、あらかじめ必要な設定を行います。
<!-- textlint-enable -->

**注意**:
この記事では`PowerShell`を使用しています。他のシェルを使用している場合は、適宜コマンドを調整してください。

### 2.1 `Path`の設定

環境変数`Path`に`OCaml`の実行ディレクトリ`c:\lang\ocaml\bin`を追加します。
このためには、システムの環境設定画面を開いてシステム環境変数`Path`に`c:\lang\ocaml\bin`を追加します。

次の手順で、`Path`を設定します。

1. システムのプロパティを開く:
  [設定]＞[システム > バージョン情報]＞\[システムの詳細設定]して、\[システムのプロパティ]を開く。

   あるいは、`[Win]+R`かコマンドラインから、次のコマンドを実行する。

   ```powershell
   SystemPropertiesAdvanced.exe
   ```

   以上で、\[システムのプロパティ]を開く。

   ![システムのプロパティ](https://i.imgur.com/zfaLYCw.png)
   *システムのプロパティ*

2. \[環境変数]ダイアログを開く:]
   \[環境変数]ボタンをクリックして、\[環境変数]ダイアログを開く
   ![環境変数](https://i.imgur.com/r75yAaY.png)
   *環境変数*

3. \[システム環境変数]の`Path`を編集する:
   "システム環境変数"の`Path`を選び、[編集(I)]をクリックする。

    ![Pathの編集](https://i.imgur.com/ujPkIoU.png)
   *環境変数: システムPath*

4. 実行ディレクトリを追加する:
   \[新規\]をクリックし、`C:\lang\ocaml\bin` を追加する。

   ![Pathの編集](https://i.imgur.com/ujPkIoU.png)
   *環境変数: システムPath*

5. ダイアログを閉じる:
   各ダイアログの\[OK]をクリックし、各ダイアログを閉じる。

以上で、環境変数の設定は完了です。

### 2.2 `OPAMROOT`の設定

`OPAMROOT`は`opam`がパッケージを管理する場所を指定する環境変数です。
`OPAMROOT`を指定しない場合は、Windows は、`＄USERPROFILE/.opam`でパッケージを管理します。

この記事では、`XDG Base Direcory`に準じた`OPAMROOT`を設定することで、環境をクリーンに保ちます。
次の手順で、`OPAMROOT`を設定します。

1. `powershell`で環境変数設定コマンドを実行する:

   ```powershell
   [System.Environment]::SetEnvironmentVariable("OPAMROOT", $env:XDG_DATA_HOME+"/opam", "User")

   ```

以上で、`OPAMROOT`の設定は完了です。

### 2.3 `Terminal`の再起動

ここまでで設定した`Path`や環境変数を`Windows Terminal`に反映させるため、`Windows Terminal`を再起動します。
この再起動により、新しく設定した環境変数が `Terminal` 環境に適用され、`OCaml` および関連ツールを問題なく使用できるようになります。

次の手順で、`Windows Terminal`を再起動します:

1. `exit`コマンドで`Windows Terminal`を終了する:

   ```powershell
   exit
   ```

2. `wt`コマンドを実行し、`Windows Terminal`を起動する:

   ```powershell
   wt
   ```

以上で、`Windows Terminal`の再起動は完了です。

## 3. `OCaml`のインストール

このセクションでは、まず`DkML`をインストールし、`DkML`を使って Windows版`OCaml`をインストールします。
`DkML`は Windows版`OCaml`のインストーラーです。
これは、`OCaml`がもともと UNIX/Linux系OS用に設計されているためで、`DkML`を使用することで Windows での運用の差異を吸収します。

### 3.1 `DkML`のインストール

`DkML`は`OCaml`を Windows 環境にて機能させてインストールするインストーラーです。
次の手順で、`DkML`をインストールします:

1. `winget`で、`DkML`をインストールする:

   ```powershell
   winget install Diskuv.OCaml --location c:\lang\ocaml
   ```

以上で、`DkML`のインストールは完了です。
次に、インストールした`DkML`を使って`OCaml`をインストールします。

### 3.2 `Visual Studio BuildTools`のインストール

`Visual Studio BuildTools`はコマンドラインでビルドを行なう開発ツールセットです。
`DkML`インストーラーは`BuildTools`を使って`OCaml`をビルドするため、`DkML`を実行する前に`BuildTools`をインストールしておく必要があります。

次の手順で、`BuildTools`をインストールします:

1. `winget`コマンドで、`BuildTools`をインストールする:
   <!-- markdownlint-disable line-length -->
   ```powershell
   winget install Microsoft.VisualStudio.2019.BuildTools --override "--wait --passive --installPath C:\VS --addProductLang Ja-jp --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
   ```
   <!-- markdownlint-enable -->

以上で、`BuildTools`のインストールは完了です。

### 3.3 `DkML`の初期設定

次の手順で、`DkML`を初期設定します:

1. `dkml init`で`DkML`を初期化する:

   ```powershell
   dkml init --disable-sandboxing --system
   ```
   <!-- textlint-disable ja-technical-writing/no-doubled-joshi -->
   **注意**:
   Windows 環境では、標準のサンドボックス機能がうまく機能しない場合があるため、`--disable-sandboxing`オプションを使用しています。
   <!-- textlilnt-enable -->

以上で、`DkML`の初期設定は完了です。
これにより、`opam`コマンドが使えるようになります。

### 3.4 `opam`の初期設定

`DkML`に続いて`opam`を初期設定します。
次の手順で、`opam`を初期設定します:

1. `opam`を初期設定する:

   ```powershell
   opam init --disable-sandboxing --bare --switch=playground --shell=pwsh  -a

   ```

以上で、`opam`の初期設定は完了です。

### 3.5 初期設定スクリプトの設定

`OCaml`を実行するためには、いくつかの環境変数を設定しておく必要があります。
次の手順で、初期設定スクリプトを設定します:

1. エディタで初期設定スクリプト`$profile`を開きます

2. `$profile'の末尾に次の行を追加します:

   ```powershell:$profile
   (& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
   ```

3. `$profile`を保存して、エディタを終了します

以上で、初期設定スクリプトの設定は完了です。

`opam env`コマンドは、環境変数設定スクリプトを出力します。上記コマンドでは、出力された環境変数ごとに`Invoke-Expression`を実行して環境変数を設定しています。

### 3.6 `Terminal`の再起動

ここまでで設定した`Path`や環境変数を`Windows Terminal`に反映させるため、`Windows Terminal`を再起動します。

次の手順で、`Windows Terminal`を再起動します:

1. `exit`コマンドで`Windows Terminal`を終了する:

   ```powershell
   exit
   ```

2. `wt`コマンドを実行し、`Windows Terminal`を起動する:

   ```powershell
   wt
   ```

以上で、`Windows Terminal`の再起動は完了です。

### 3.7 `utop`のインストール

`utop`は、`OCaml`の`REPL`に各種拡張機能を提供するパッケージです。

次の手順で、`utop`をインストールします。

1. `opam`を使って、`utop`パッケージをインストールする:

   ```powershell
   opam install utop -y

   ```

以上で、`utop`のインストールは完了です。

## 4. `OCaml`の起動、終了

`OCaml`を正常にインストールしたか確認します。
そのため、`OCaml`を起動し、そのあと、終了させます。

### 4.1 `OCaml`の起動

次のコマンドで、`OCaml`を起動します。

```powershell
ocaml
```

以下のように、プロンプトが表示されれば成功です。

```OCaml
OCaml version 4.14.0
Enter #help;; for help.

#
```

<!-- textlint-disable ja-technical-writing/no-doubled-joshi -->
**注意**:
`OCaml`を起動する際に、"アプリを選択してください"ダイアログが表示された場合は、`$OPAMROOT/playground/bin`にある Linux用の起動スクリプト`ocaml`が原因です。このスクリプトは Windows 環境では不要なので、削除してください。
<!-- textlint-enable -->

### 4.2 `OCaml`の終了

`OCaml`を終了して、`PowerShell`に戻ります。
以下の 2つの方法があります。

1. `#quit`ディレクティブを使う:
   `#quit;;`とディレクティブと終端記号を入力します

   ```OCaml
   # #quit;;

   >
   ```

   上記のように、`powershell`のプロンプトに戻ります。

2. `Clrl+Z` (`EOF`)を入力する:
   プロンプトの先頭で、`Ctrl+Z` (`EOF`) を入力します

   **注意**:
   Windows 環境では、`EOF`は`Ctrl+Z`で入力します。

   ```OCaml
   # ^Z [`Ctrl+Z`を入力]

   >
   ```

  上記のように、`powershell`のプロンプトに戻ります。

以上で、`OCaml`の終了は完了です。

## 5. `utop`の起動と終了

`OCaml`と同様に、`utop`が起動、終了することを確認します。

### 5.1 `utop`の起動

高度な編集機能を使いたいときは、`OCaml`の拡張`REPL`である`utop`を起動します。

```powershell
utop

─┬────────────────────────────────────┬──
  │ Welcome to utop version 2.13.1 (using OCaml version 4.14!│
  └────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 17:59:00 )─< command 0>─────────────────{ counter: 0 }─
utop #

```

上記のように、プロンプトが出力されます。
以上で、`utop`の起動は終了です。

### 5.2 `utop`の終了

`utop`を終了して、`PowerShell`に戻ります。
以下の 2つの方法があります。

1. `#quit`ディレクティブを使う:
   `#quit;;`とディレクティブと終端記号を入力します

   ```OCaml
   utop # #quit;;

   >
   ```

   上記のように、`powershell`に戻ります。

2. `Ctrl+D` (`EOF`)を入力する:
   プロンプトの先頭で、`Ctrl+D` (`EOF`)を入力します

   ```OCaml
   utop # [`Ctrl+D`を入力]

   >
   ```

   上記のように、`powershell`に戻ります。

以上で、`utop`の終了は完了です。

## おわりに

以上で、Windows 環境に`OCaml`をセットアップし、`OCaml`の起動と終了ができました。
これにより、関数型プログラミングの学習環境が整いました。

次のステップでは、実際に`OCaml`を使って簡単なプログラムを書いてみましょう。
最初は、"Hello, World!"を出力するプログラムを作成し、次はリスト機能や再帰関数について書いてみるなどです。
こうしたプログラミングを通して、`OCaml`の基本的な機能や関数型プログラミングの概念について学んでいきましょう。

また、「[プログラミングの基礎](https://www.saiensu.co.jp/search/?isbn=978-4-7819-9932-6&y=2018)」や「[関数型言語で学ぶプログラミングの基本](https://tatsu-zine.com/books/programming-basics-with-ocaml)」などの教材を通じて、関数型プログラミングのコンセプトを学ぶことも重要です。

継続的な学習と実践を通じて、プログラミングスキルの上昇を目指しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`OCaml`公式](https://ocaml.org/):
  `OCaml`の基本から応用までを網羅的に学べる公式ドキュメント。初心者から上級者まで幅広く対応しています。
- [`Windows版OCaml` `DkML`](https://github.com/diskuv/dkml-installer-Ocaml):
  Windows 環境で`OCaml`を設定する際に役立つ`DkML`インストーラーの詳細情報。
- [Windowsに`XDG Base Directory`を導入する](https://zenn.dev/atsushifx/articles/winhack-environ-xdg-base):
  Windows 環境で`XDG Base Directory`を利用する方法について解説した記事。

### Webリソース

- [京都大学工学部専門科目「プログラミング言語処理系」講義資料](https://kuis-isle3sw.github.io/IoPLMaterials/)
- [`OCaml`入門](https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-09w/mltext.pdf)

### 本

- [プログラミングの基礎](https://www.saiensu.co.jp/search/?isbn=978-4-7819-9932-6&y=2018)
- [関数型言語で学ぶプログラミングの基本](https://tatsu-zine.com/books/programming-basics-with-ocaml)
