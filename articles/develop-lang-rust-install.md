---
title: "開発環境: WindowsにRust(MSVC)をインストールする　(2023年版)"
emoji: "🦾"
type: "tech"
topics: ["Windows", "開発環境", "Rust" ]
published: false
---

## tl;dr

- `Rust`[^1]をインストールする前に、`Visual Studio Build Tools`[^2]をインストールする必要がある
- 環境変数を設定することで、指定したディレクトリに`Rust`をインストールできる
- `Rust`のインストールには、`winget`コマンドを使用できる

以上。

[^1]: 高速で安全性が高く、並行性と実用性を兼ね備えたシステムプログラミング言語。メモリ安全性の維持と高速性を両立したプログラミング言語として知られている。
[^2]: マイクロソフトが提供するクロスプラットフォーム用のソフトウェア開発ツール。Rust のインストールにはこれが必要となる。

## はじめに

プログラミング言語`Rust`では、ソースのコンパイル／ビルドに`C++`のコンパイラが必須です。
Windows版Rust では Microsoft の`Visual C++`が GNU の`GNU C++`が求められます。
このため、Rust をインストールする前に C++の開発環境をセットアップする必要があります。

この記事では、`Visual C++`コンパイラを含む Microsoft`のソフトウェア開発ツール、`Visual Studio Build Tools`を事前にインストールしておきます。

`Rust`および`Visual Studio Build Tools`のインストールは、`winget`[^3]コマンドで簡単に行えます。
この記事では、`Rust`と`Visual Studio Build Tools`のインストール方法を説明します。

[^3]: WIndows 公式のパッケージマネージャー

## 1. Rustのインストール

### 1.1. Visual Studio Build Toolsのインストール

Rust が正常に動作するためには、C++コンパイラが必要です。`Rust`を使うため、事前に、C++コンパイラを含む Microsoft のソフトウェア開発ツール、`Visual Studio Build Tools`をインストールしておきます。

詳しい説明は、"[Visual Studio Build Toolsのインストール手順ガイド](winhack-develop-buildtools-install.md)"を見てください。

#### Visual Studio Build Toolsをインストールする

次の手順で、`Visual Studio Build Tools`をインストールします。

1. `Visual Studio Installer`の起動:
   下記のコマンドを実行し、`Visual Studio Installer`を起動する

   ```powershell
   winget install Microsoft.VisualStudio.2022.BuildTools
   ```

2. コンポーネントの選択:
    \[コンポーネントの選択\]画面で、[C++によるデスクトップ開発]を選択する
    ![インストーラー:コンポーネントの選択](https://i.imgur.com/xb0GWdD.png)

3. `Build Tools`のインストール:
   \[インストール\]ボタンをクリックし、選択したコンポーネントをインストールする
   ![インストール](https://i.imgur.com/cbjlNHM.png)

4. `Visual Studio Installer`の終了:
    右上の\[×\]をクリックし、インストーラーを終了する

以上で、`Visual Studio Build Tools`のインストールは終了です。
次に、`Path`を設定して、`Rust`コンパイラが`C++`コンパイラを実行できるようにします。

#### Pathを設定する

次の手順で、`Path`を設定します。

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
    \[環境変数名の編集\]ダイアログが表示される
    ![Pathの編集](https://i.imgur.com/ujPkIoU.png)

4. `C++`コンパイラのパスを追加:

    [新規]をクリックし、以下の Path を追加する
    | Path | 概要 |
    | --- | --- |
    |`C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.36.32532/bin/HostX64/x64` | `C++`コンパイラ |

5. 各ダイアログを閉じる:
    \[OK\]をクリックし、各ダイアログを閉じる

6. PC の再起動
    設定した`Path`を環境に反映させるため、PC を再起動する

以上で、`Visual Studio Build Tools`のインストールは終了です。

### 1.2 環境変数の設定

`Rust`は以下の環境変数を使用します。これらの変数を、`Rust`をインストールする前に設定することで`Rust`のインストール先などをかえることができます。
以下に、Rust が使用する環境変数とその設定を載せておきます。

  | 環境変数 | 概要 | 備考 |
  |-- |-- |-- |
  | `CARGO_HOME` | `Rust`のインストール先 | `Rust`の各種`crate`やコンパイラなどはこのディレクトリ下に保存する |
  |  `Path` |`Rust`ツールパス | `Rust`の各種ツールを実行するために、`Rust`用のパスを追加 |
  | `RUSTUP_HOME` |  `Rust`用各種データ保存先 | `Rust`コンパイラの実体や、C用のヘッダーなどの保存先 |

#### 環境変数を設定する

次の手順で、環境変数を設定します。

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

3. [システム環境変数]の編集:
   "システム環境変数"に以下の環境変数を設定する
    | 環境変数 | 設定 | 備考 |
    | --- | --- | --- |
    | `CARGO_HOME` | `c:\lang\rust` | 自分の環境では、`c:\lang`下に各種言語が入る |
    | `Path` | `%CARGO_HOME%\bin` | Pathに左記の設定を追加

4. [ユーザー環境変数]の編集:
   "システム環境変数"に以下の環境変数を設定する
    | 環境変数 | 設定 | 備考 |
    | --- | --- | --- |
    | `RUSTUP_HOME` | `%XDG_DATA_HOME%\rustup` | `XDG Base Directory`に対応 |

5. ダイアログを閉じる:
    \[OK\]をクリックし、各ダイアログを閉じる

6. PC の再起動
    設定した`Path`を環境に反映させるため、PC を再起動する

以上で、環境変数の設定は終了です。

### 1.3.  Rustのインストール

`Rust`を公式サイトからインストールするさいには、`Rust toolchain`のインストーラーである`Rustup`[^4]を使用します。

`winget`のパッケージには`Rust`言語そのもののージのほかに、`Rustup`のものも含まれています。

今回は、`Rustup`を使用するために`rustup`パッケージをインストールします。

下記に、`winget`内の`Rust`言語関連のパッケージをまとめておきます。

| `パッケージID` | 説明 | 備考 |
| --- | --- | --- |
| `Rustlang.Rustup` | `The Rust toolchain installer` | `Rustup`のインストーラー。Rust はインストールされた`rustup`によって、自動的にインストールされる |
| `Rustlang.Rust.MSVC`| `Rust (MSVC)` | Rust言語、C/C++モジュールに `VIsual C++` を使用する版 |
| `Rustlang.Rust.GNU` | `Rust (GNU)` | Rust言語、C/C++モジュールに`GNU C++`を使用する版 |

[^4]: Rust開発環境を構築、管理する公式のツール。Rust言語の開発環境を構築する際には、`rustup` の使用が推奨されている。

#### Rustをインストールする

次の手順で、Rust をインストールします。

1. `rustup` のインストール:
    `Windows Terminal`で次のコマンドを実行し、`Rustup`をインストールする

    ```powershell
    winget install rustlang.rustup
    ```

2. rust のインストール:
    自動的に`rustup`が実行され、`rust`をインストールする

    ``` PowerShell: rustup
    info: profile set to 'default'
    info: default host triple is x86_64-pc-windows-msvc
    info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
     .
     .
     ,
    ```

以上で、rust のインストールは終了です。

#### Rustの動作チェック

インストールが正常に終了していれば、`Rust`コンパイラ`rustc`が使えます。
次の手順で、`rustc`の動作をチェックします。

1. `rustc`の起動;
    `Windows Terminal`で次のコマンドを実行する

    ```powershell
    rustc -V
    ```

2. バージョンのチェック:
    `Terminal`に次のようなバージョン番号が表示されるかチェック

    ```powershell
    rustc 1.71.0 (8ede3aae2 2023-07-12)
    ```

上記のようにバージョン番号が表示されれば、`Rust`は正常にインストールされています。

## 2. 開発環境の確認

Rust を正常にインストールしてプログラミングできることを確認するために、簡単なプログラム(`Hello, world`)を作成して実行します。

### 2.1. Rustで`Hello, World`

次の手順で、Rust の開発環境を確認します。

1. 作業用ディレクトリに移動:
    `PowerShell`を開き、プログラミング用の適当な作業用ディレクトリに移動する

    ```powershell
    cd ~/workspacies/temp/rust
    ```

2. `hello.rs`の作成:
    下記の`helllo.rs`のソースを作成する

    ```rust ;hello.rs
     fn main()
     {
        println!("Hello, rust World!")
    }
    ```

3. `hello.exe`の作成:
    `hello.rs`をコンパイルして`hello.exe`を作成する

    ```powershell
     rustc hello.rs
     ```

4. `hello.exe` の実行:
    `hello.exe`を実行し、正常に動作するかを確認する

    ```powershell
    Hello, rust World!
    ```

上記のように、`Hello, rust World!`が出力されていれば正常に動作しています。

## さいごに

以上の手順で、Windows 環境に MSVC版Rust をインストールできます。
まとめると、以下の主要なステップで Rust のインストールが可能です。

1. `Rust`のインストール前に、C++コンパイラを含む"Visual Studio Build Tools"をインストールします
2. 環境変数を事前に設定することで、Rust のインストール先などを自由に設定します
3. `winget`コマンドを使うことで、簡単に Rust をインストールします

これらのステップを実行すれば、スムーズに`Rust`の開発環境が構築できます。

是非、この新たな環境を活用し、プログラミングの世界を楽しんでください。

それでは、Happy hacking!

## 参考資料

### Webサイト

- [Rust公式Web](https://www.rust-lang.org/ja)
- [Rust日本語ドキュメント](https://doc.rust-jp.rs/)
- [Visual Studio Build Toolsのインストール手順ガイド](https://zenn.dev/atsushifx/articles/winhack-develop-buildtools-install)
