---
title: "開発環境: WindowsにRust(MSVC)の開発環境を構築する (2023年版)"
emoji: "🦾"
type: "tech"
topics: ["Windows", "開発環境", "Rust" ]
published: false
---

## tl;dr

- `Rust`[^1]開発のためには、`Visual Studio Build Tools`[^2]をインストールが必要
- 環境変数を設定し、それに基づいて`Rust`をインストールする
- これらの手順は、`winget`コマンドを用いて効率的に行える

[^1]: Rust: 高速で安全性が高く、並行性と実用性を兼ね備えたシステムプログラミング言語。その特徴として、メモリ安全性の維持と高速性を両立した設計があげられる。
[^2]: `Visual Studio Build Tools`: マイクロソフトが提供するクロスプラットフォーム用のソフトウェア開発ツール。Rust のインストールにはこれが必要となる。

## はじめに

プログラミング言語`Rust`を使用するためには、ソースのコンパイル／ビルド用に`C++`コンパイラが必須です。
Windows版Rust では`Visual C++`か、もしくは`GNU C++`が求められます。
このため、Rust をインストールする前に C++の開発環境をセットアップする必要があります。

この記事では、`Visual C++`コンパイラを含む Microsoft`のソフトウェア開発ツール、`Visual Studio Build Tools`をあらかじめインストールしておきます。

`Rust` および   `Visual Studio Build Tools` のインストールは、`winget`[^3] コマンドで簡単に行えます。
`winget`は Windows の公式パッケージマネージャーで、ソフトウェアのインストールをコマンドラインから一括で行えます。
この記事では、`Rust`と`Visual Studio Build Tools`のインストール方法をステップバイステップで説明します。

[^3]: `winget`: WIndows 公式のパッケージマネージャー

## 1. Visual Studio Build Toolsのインストール

Rust が正常に動作するためには、C++コンパイラが必要です。`Rust`を使うため、事前に、C++コンパイラを含む Microsoft のソフトウェア開発ツール、`Visual Studio Build Tools`をインストールしておきます。

詳しい説明は、"[Visual Studio Build Toolsのインストール手順ガイド](winhack-develop-buildtools-install.md)"を見てください。

### 1.1. Visual Studio Build Toolsをインストールする

次の手順で、`Visual Studio Build Tools`をインストールします。

1. `Visual Studio Installer`の起動:
   下記のコマンドを実行し、`Visual Studio Installer`を起動する

   ```powershell
   winget install Microsoft.VisualStudio.2022.BuildTools
   ```

2. コンポーネントの選択:
    \[コンポーネントの選択\]画面で、\[C++によるデスクトップ開発\]を選択する
    ![インストーラー:コンポーネントの選択](https://i.imgur.com/xb0GWdD.png)

3. `Build Tools`のインストール:
   \[インストール\]ボタンをクリックし、選択したコンポーネントをインストールする
   ![インストール](https://i.imgur.com/cbjlNHM.png)

4. `Visual Studio Installer`の終了:
    右上の\[×]をクリックし、インストーラーを終了する

これで`Visual Studio Build Tools`のインストールは完了です。
次に、`Visual Studio Build Tools`の`Path`を設定します。

### 1.2. Pathを設定する

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
    \[システムの環境変数\]ダイアログが表示される
    ![Pathの編集](https://i.imgur.com/ujPkIoU.png)

4. `C++`コンパイラのパスを追加:

    [新規]をクリックし、以下の`Path`を追加する
    | Path | 概要 |
    | --- | --- |
    |`C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.36.32532/bin/HostX64/x64` | `C++`コンパイラ |

5. ダイアログの終了:
    \[OK\]をクリックし、すべてのダイアログを終了する

6. PC の再起動
    設定した`Path`を環境に反映させるため、PC を再起動する

以上で、`Visual Studio Build Tools`のセットアップは完了です。

## 2. Rust のインストール

### 2.1. 環境変数の設定

以下に、`Rust`のインストールおよび動作に関する環境変数をしめします。これらの変数をインストール前に設定することで、インストール先などを指定できます。
以下に、`Rust`が使用する環境変数とその設定を載せておきます。

  | 環境変数 | 概要 | 備考 |
  |--- |--- |--- |
  | `CARGO_HOME` | `Cargo`のインストール先 | `Rust`のパッケージマネージャー`Cargo`のインストール先。`Rust`コンパイラなども、このディレクトリ下に保存する |
  | `Path` |`Rust`ツールパス | `Rust`の各種ツールを実行するための`Path`を追加する |
  | `RUSTUP_HOME` |  `Rust`用各種データ保存先 | Rustのツールチェーン、コンパイラの実体や、C用のヘッダー、ライブラリなど各種データを保存する |

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
    | `Path` | `%CARGO_HOME%\bin` | `Path`に左記の設定を追加する |

4. [ユーザー環境変数]の編集:
   "システム環境変数"に以下の環境変数を設定する
    | 環境変数 | 設定 | 備考 |
    | --- | --- | --- |
    | `RUSTUP_HOME` | `%XDG_DATA_HOME%\rustup` | `XDG Base Directory`[^4]に対応 |

5. ダイアログの終了:
    すべてのダイアログの\[OK\]をクリックし、ダイアログを終了する

6. PC の再起動:
    設定した`Path`を環境全体に反映させるため、PC を再起動する

以上で、環境変数の設定は完了です。

[^4]:`XDG Base DIrectory`: Linux/UNIX で設定ファイルを保存するときに用いられる標準的なディレクトリ仕様

### 2.2.  Rustをインストールする

`Rust`を公式サイトからインストールする際には、`Rust toolchain`のインストーラーである`Rustup`[^5]を使用します。
`Rustup`は`cargo`やそのほかの Rust でのソフトウェア開発に必要なツールチェーンも一緒にインストールします。
`Rust`開発環境全体の管理・構築・アップデートができるツールです。

`winget`のパッケージには`Rust`言語とそのインストーラー`Rustup`のパッケージが含まれています。
今回は、`Rustup`を使用するために`rustup`パッケージをインストールします。

下記に、`winget`内の`Rust`言語関連のパッケージをまとめています。

| `パッケージID` | 説明 | 備考 |
| --- | --- | --- |
| `Rustlang.Rustup` | `The Rust toolchain installer` | `Rustup`のインストーラー。Rust はインストールされた`rustup`によって、自動的にインストールされる |
| `Rustlang.Rust.MSVC`| `Rust (MSVC)` | Rust言語、C/C++モジュールに `VIsual C++` を使用する版 |
| `Rustlang.Rust.GNU` | `Rust (GNU)` | Rust言語、C/C++モジュールに`GNU C++`を使用する版 |

[^5]: `Rustup`: Rust開発環境を構築、管理する公式のツール。Rust言語の開発環境を構築する際には、`rustup` の使用が推奨されている。

次の手順で、`Rust`をインストールします。

1. `rustup` のインストール:
    `Windows Terminal`で次のコマンドを実行し、`Rustup`をインストールする

    ```powershell
    winget install rustlang.rustup
    ```

2. `Rust` のインストール:
    `rustup`が自動的に実行され、`rust`をインストールする

    ``` PowerShell: rustup
    info: profile set to 'default'
    info: default host triple is x86_64-pc-windows-msvc
    info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
     .
     .
     ,
    ```

以上で、rust のインストールは完了です。

### 2.3. Rustの動作チェック

インストールが正常に終了していれば、`Rust`コンパイラ`rustc`が使用可能です。
次の手順で、`rustc`の動作をチェックします。

1. `rustc`のバージョン  ;
    `Windows Terminal`で次のコマンドを実行する

    ```powershell
    rustc --version
    ```

2. バージョンのチェック:
    `Terminal`に次のようなバージョン番号が表示されるかチェック

    ```powershell
    rustc 1.71.0 (8ede3aae2 2023-07-12)
    ```

( `rustc 1.71.0  ...`) のようなバージョン番号が表示されれば、`Rust`は正常にインストールされています。

## 3. 開発環境の確認

`Rust`を正常にインストールし、`Rust` によるプログラミングができることを確認するために`Hello,World`を出力する簡単なプログラムを作成します。

### 3.1. Rustで`Hello, World`

次の手順で、`Rust` の開発環境を確認します。

1. 作業用ディレクトリに移動:
    `PowerShell`を開き、プログラミング用の適当な作業用ディレクトリに移動する

    ```powershell
    cd ~/workspacies/temp/rust
    ```

2. `hello.rs`の作成:
    `hello.rs`ファイルを作成し、ファイルに以下の`Rust`コードを記述する

    ```rust
    // hello.rs
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

    ```txt
    Hello, rust World!
    ```

上記のように"`Hello, rust World!`"が出力されていれば、`Rust`は正常に動作しています。

## さいごに

以上の手順で、Windows 環境に MSVC版Rust をインストールできます。
まとめると、以下の主要なステップで Rust のインストールが可能です。

1. `Rust`のインストール前に、C++コンパイラを含む"`Visual Studio Build Tools`"をインストールします
2. 環境変数を事前に設定すれば、`Rust` のインストール先などを自由に変更できます
3. `winget`コマンドを使うことで、簡単に `Rust`をインストールします

これらのステップを実行すれば、スムーズに`Rust`の開発環境が構築できます。

今回の記事を参考に、Rust の開発環境構築を進めてみてください。そして新たに手にした Rust の力を活用し、あなたのエンジニアリングの世界をさらに広げてみてください。

それでは、Happy hacking!

## 参考資料

### Webサイト

- [Rust公式Web](https://www.rust-lang.org/ja)
- [Rust日本語ドキュメント](https://doc.rust-lang.org/book/ja/)
- [Visual Studio Build Toolsのインストール手順ガイド](https://zenn.dev/atsushifx/articles/winhack-develop-buildtools-install)
- [`XDG Base Directory`](https://wiki.archlinux.jp/index.php/XDG_Base_Directory)
