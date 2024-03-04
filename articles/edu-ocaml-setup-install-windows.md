---
title: "OCaml: WindowsでOCamlを設定する方法"
emoji: "🐪"
type: "tech"
topics: [ "学習", "関数型プログラミング", "環境構築", "Windows", ]
published: false
---

## はじめに

この記事では、Windows 環境で関数型プログラミング言語`OCaml`をインストールして設定する方法について解説します。
`OCaml`は UNIX/Linux系OS に最適化されているため、Windows 向けのインストーラーである`DkML`を使用します。

このプロセスを通じて、Windows に`OCaml`をインストールし、関数型プログラミングの世界を楽しみましょう。
Enjoy!

## 技術用語

この記事で取り上げる重要な技術用語を以下に解説します。

- `OCaml`: ML言語ファミリーに属し、型推論、強力なパターンマッチング、モジュールシステムを特徴とする関数型プログラミング言語
- `DkML`: Windows に`OCaml`を簡単にインストールするためのインストーラー
- `opam`: `OCaml`のパッケージを管理するためのパワフルなツールで、ライブラリやツールのインストール、バージョン管理を容易にする
- `XDG Base Directory`: UNIX系OS のディレクトリ標準仕様で、設定やデータファイルはこの仕様にしたがって整理する

## 前提条件

この記事では、以下の前提で`OCaml`をインストールします。

`OCaml`は、`c:\lang\ocaml`下にインストールします。
`OCaml`のパッケージマネージャー`opam`は、ここでは`XDG Base`ディレクトリ仕様にしたがい、`$XDG_DATA_HOME/opam`下にキャッシュなどの各種ファイルを配置します。

**注意**:
`XDG Base`仕様の環境変数は、[Windowsに`XDG Base Directory`を導入する](https://zenn.dev/atsushifx/articles/winhack-environ-xdg-base)で設定してあるものとします。

## 初期設定

`OCaml`をインストールする前に、`Path`や環境変数など、必要な設定をしておきます。

### `Path`の設定

環境変数`Path`に`OCaml`の実行ディレクトリ`c:\lang\ocaml\bin`を追加します。
これにより、どのディレクトリにいてもインストールした`opam`、`DkML`が実行できます。

次の手順で、`Path`を設定します。

1. システムのプロパティを開く:

   ```powershell
   SystemPropertiesAdvanced.exe
   ```

    上記のコマンドを実行し、\[システムのプロパティ]を開く。
   ![システムのプロパティ](https://i.imgur.com/zfaLYCw.png)
   *システムのプロパティ*

2. \[環境変数]ダイアログを開く:
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

### `OPAMROOT`の設定

パッケージマネージャー`opam`によって管理されるパッケージの保存先を指定するために、環境変数`OPAMROOT`を設定します。
次のようにして、`OPAMROOT`を設定します。

```powershell
[System.Environment]::SetEnvironmentVariable("OPAMROOT", $env:XDG_DATA_HOME+"/opam", "User")

```

以上で、`OPAMROOT`の設定は完了です。

### `Terminal`の再起動

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

## `OCaml`のインストール

この記事では、`DkML`をインストールし、それを利用して Windows版`OCaml`をインストールします。
`OCaml`のビルドに、`Visual Studio BuildTools`も必要なため、あわせて`BuildTools`もインストールします。

### `DkML`のインストール

次の手順で、`DkML`をインストールします:

```powershell
winget install Diskuv.OCaml --location c:\lang\ocaml
```

以上で、`DkML`のインストールは完了です。

### `Visual Studio BuildTools`のインストール

`DkML`は、`Visual Studio BuildTools`を使って`OCaml`やパッケージをビルドします。
次のコマンドで、`BuildTools`をインストールします:

<!-- markdownlint-disable line-length -->
```powershell
 winget install Microsoft.VisualStudio.2019.BuildTools --override "--wait --passive --installPath C:\VS --addProductLang Ja-jp --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
```
<!-- markdownlint-enable -->

### `DkML`の初期設定

次のコマンドで、`DkML`を初期設定します:

```powershell
dkml init --disable-sandboxing --system

```

以上で、`DkML`の初期設定は完了です。

### `opam`の初期設定

`DkML`に続いて`opam`を初期設定します。
次のコマンドを実行します:

```powershell
opam init --disable-sandboxing --bare --switch=playground --shell=pwsh  -a

```

以上で、`opam`の初期設定は完了です。

### 初期設定スクリプトの設定

`OCaml`を実行するためには、いくつかの環境変数を設定しておく必要があります。
そのため、PowerShell の初期設定スクリプトに以下の行を追加します。

```powershell:$profile
(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }

```

`opam env`コマンドは、環境変数設定スクリプトを出力します。上記コマンドでは、出力された環境変数ごとに`Invoke-Expression`を実行して環境変数を設定しています。

以上で、初期設定スクリプトの設定は完了です。

### `Terminal`の再起動

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

### `utop`のインストール

`utop`は、`OCaml`の`REPL`各種の拡張機能を追加するパッケージです。

次のコマンドで、`utop`をインストールします。

```powershell
opam install utop -y

```

## `OCaml`の起動、終了

`OCaml`を正常にインストールしたか確認するために、`OCaml`を起動、終了します。

### `OCaml`の起動

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

**注意**:
<!-- textlint-disable ja-technical-writing/no-doubled-joshi -->
  `OCaml`と入力したとき、"アプリを選択してください"ダイアログが表示されることがあります。
  これは、`opam`パッケージの実行ディレクトリ`$OPAMROOT/playground/bin`下に、Linux 用の起動スクリプト`ocaml`があるためです。
  Windows 環境では使わないので、上記のスクリプトを削除してください。
  ![アプリを選択してください](https://i.imgur.com/nU3ShKm.jpg)
<!-- textlint-enable -->

### `OCaml`の終了

`OCaml`を終了して、`PowerShell`に戻ります。
以下の 2つの方法があります。

- `#quit`ディレクティブを使う:
  `#quit;;`とディレクティブと終端記号を入力します

  ```OCaml
  # #quit;;

  >
  ```

  上記のように、`powershell`のプロンプトに戻ります。

- `Clrl+Z` (`EOF`)を入力する:
  プロンプトの先頭で、`Ctrl+Z` (`EOF`) を入力します
  **注意**:
  Windows 環境では、`EOF`は`Ctrl+Z`で入力します。

  ```OCaml
  # ^Z [`Ctrl+Z`を入力]

  >
  ```

  上記のように、`powershell`のプロンプトに戻ります。

以上で、`OCaml`の終了は完了です。

### `utop`の起動

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

### `utop`の終了

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

次は、実際に`OCaml`を使って関数型プログラミングについて学習しましょう。
参考資料に、大学の講義資料や関数型プログラミングの本があるので、学習の助けになるでしょう。

関数型プログラミングを学び、プログラマーとしてステップアップしてください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`OCaml`公式](https://Ocaml.org/)
- [`Windows版OCaml` `DkML`](https://github.com/diskuv/dkml-installer-Ocaml)
- [Windowsに`XDG Base Directory`を導入する](https://zenn.dev/atsushifx/articles/winhack-environ-xdg-base)

### Webリソース

- [京都大学工学部専門科目「プログラミング言語処理系」講義資料](https://kuis-isle3sw.github.io/IoPLMaterials/)
- [`OCaml`入門](https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-09w/mltext.pdf)

### 本

- [プログラミングの基礎](https://www.saiensu.co.jp/search/?isbn=978-4-7819-9932-6&y=2018)
- [関数型言語で学ぶプログラミングの基本](https://tatsu-zine.com/books/programming-basics-with-ocaml)
