---
title: "Windowsに関数型言語'Racket'をインストールする方法"
emoji: "🎾"
type: "tech"
topics: ["プログラミング言語", "Racket", "環境構築", "勉強" ]
published:  false
---

## tl;dr

以下の手順で、`Racket`が使えるようになります。

1. `Racket`のインストール
    Windows 公式パッケージマネージャー`winget`を使って、指定ディレクトリに`Racket`をインストールします。

2. 環境変数`PLTUSERHOME`を設定
    環境変数を設定して、`Racket`の環境設定を`XDG Base`下にします。

3. `Path`の設定
    `Racket`の実行パスを Windows の Path に追加します。

4. Windows の再起動
    Path の設定を Windows に反映させるため、Windows を再起動します。

以上で、`PowerShell`から`Racket`がつかえるようになります。

Enjoy!

## はじめに

この記事では、Racket のインストール方法について説明します。
この記事を読めば、Racket をインストールし起動して、REPL を使うところまでできます。

Racket の基本的な使い方まで説明するので、開発環境をきちんと構築できます。

### Racketについて

Racket は、LISP 派生言語である Scheme をもとにした多機能な関数型言語です。Racket の特徴としては、以下の点が挙げられます。

- 関数型プログラミング: Racket は関数型言語であり、関数が第一級オブジェクトとして扱われます。
- マクロシステム: Racket は強力なマクロシステムを持ち、ドメイン固有の抽象化をサポートします。
- IDE のサポート: Racket には統合開発環境(IDE)である`Dr Racket`が組み込まれており、手軽に Racket のプログラミングが始められます。
- ツールによるサポート: Racket にはコマンドラインツールである`Raco`があり、さまざまな開発タスクをサポートします。

### 技術用語

この記事にでてくる技術用語について説明しておきます。
詳しい説明は、参考資料を見てください。

- Racket: Scheme をもとにした多機能な関数型言語
- Scheme: シンプルな文法と拡張性を両立させた関数型言語
- 関数型言語: プログラミング言語の分類の 1つ、プログラミングの処理を関数というかたちで記述する言語
- REPL: Read-Eval-Print-Loop のこと。プログラミング言語で対話的にプログラミングするインターフェイス型式
- `XDG Base DIrectory`: さまざまなツールの設定ファイルをディレクトリ上のどこに保存するかを決めている仕様
- winget: Windows の公式波けっけー時マネージャー。コマンドライン上でコマンドを実行することでアプリをインストールできる
- `PLTUSERHOME`: Racket の設定ファイル、パッケージを保存するディレクトリを指定する環境変数

## 1, Racketのインストール

Windows 環境に`Racket`をインストールする方法を解説します。

### 1.1 `winget`を使ったRacketのインストール

`Racket`は、Windows パッケージマネージャー"winget"でインストールできます。
今回は、Racket を"c:\lang\racket"ディレクトリにインストールします。
以下のコマンドを実行します:

```powershell
winget install Racket.Racket --location C:\lang\racket
```

これで、winget のインストールは完了です。

## 2. Racketの環境設定

### 2.1. 環境変数の設定

Racket の設定ファイルを`XDG Base DIrectory`下に置くため、環境変数"`PLTUSERHOME`"を設定します。
以下の手順で、"`PLTUSERHOME`"を設定します。

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

3. [ユーザー環境変数]の"`PLTUSERHOME`"を編集:
    "ユーザー環境変数"の"`PLTUSERHOME`"を選び、[編集(I)]をクリックする  
    \[ユーザーの環境変数\]ダイアログが表示されるので、"`%XDG_DATA_HOME%\racket`"を設定する
    ![ユーザー環境変数の編集](https://i.imgur.com/5dDeHCQ.png)

4. 全ダイアログを閉じる:
   それぞれのダイアログの\[OK\]をクリックし、すべてのダイアログを閉じる

以上で、環境変数の設定は完了です。

### 2.2. Pathの設定

Racket を動かすために、Path に Racket のインストールパスを追加します。
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
    \[新規\]をクリックし、Racket をインストールしたディレクトリ __("C:\lang\racket")__ を追加する

5. ダイアログの終了:
    \[OK\]をクリックし、すべてのダイアログを終了する

6. PC の再起動
    設定した`Path`を環境に反映させるため、PC を再起動する

以上で、Path の設定は完了です。

## 3. Racketの起動

インストール、環境設定が終われば`Racket`が動きます。
この章では、`Racket`を起動して実際に Racket を使う方法を説明します。

### 3.1. Racketを起動、終了する

Racket は、引数なしで起動すると REPL という対話型でプログラムを実行するモードに入ります。
Racket を終了するには、"Ctrl+D"というキーを押すか、"(exit)"と入力します。

実際にやってみましょう。
Racket を実行して、Racket の REPL に入ります。

```PowerShell
racket
Welcome to Racket v8.9 [cs].
>
```

上記のように、Racket のプロンプトが表示されます。

Racket を終了するには、`(exit)`と入力します。

```racket
(exit)
C: /zenn-cli >
```

`(exit)`を入力すると、Racket が終了して`PowerShell`のプロンプトを表示します。

### 3.2. 簡単なプログラミング

Racket の REPL上では、簡単なプログラムを実行できます。

1. 数字を入れると、その数字が返ります:

   ```racket
   > 4
   4
   > -2
   -2
   >
   ```

2. 文字列は、`"`でくくります。たとえば、`Hello, World`は"Hello, World"になります:

   ``` racket
   > "Hello, World"
   "Hello, World"
   ```

   `"`で括らない場合は、文字列を関数や変数として評価しようとします。まだ、何も定義していないため"undefined"エラーがかえります。

   ```racket

   >Hello
   Hello: undefined;
   cannot reference an identifier before its definition
   in module: top-level
   
   >
   ```

3. 四則演算は、式を"()"でくくり、一番左に`+`,`-`などの演算子を書きます:

  ```racket
  > (+ 2 4)
  6
  
  > (/ 3 4)
  3/4

  ```

## おわりに

本記事では、Racket を Windows 環境にインストールし、REPL を用いて簡単なプログラミングをするまでを、詳細に解説しました。
この記事にしたがえば、無理なく Racket でプログラミングする環境を構築できるはずです。

ここから Racket でのプログラミングを学びましょう。
関数型言語の考え方を身につけることで、プログラマとしても一歩先にいけるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Racket公式Web](https://racket-lang.org/) :  Racket の公式サイト
- [Racket Documentation](https://docs.racket-lang.org/) : Racket の公式ドキュメント
