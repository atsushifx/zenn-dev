---
title: "開発環境: Visual Studio Build Toolsのインストール手順ガイド"
emoji: "🦾"
type: "tech"
topics: ["開発環境", "BuildTools", "cpp", "winget", "vsconfig"]
published: false
---

## はじめに

`Visual Studio Build Tools`を使用して、C++/C#/F#の開発環境を構築する方法を解説します。

### 対象読者

Windows でプログラミングをしている ITエンジニアを対象としています。

### 重要なキーワード

この記事であつかう重要なキーワードと注釈を掲載します:

- Visual Studio Build Tools: プログラムのコンパイルをコマンドラインから行なうツールセット
- Visual Studio Installer: `Build Tools`を構成する各種コンポーネントのインストール／アンインストールを行なうツール。
- 構成ファイル: `Visual Studio Installer`が使用するインストールするコンポーネント一覧のファイル
- JSON形式: データの記述に使われる軽量なデータ形式、設定ファイルなどの記述にも使われる
- コンポーネント: `Visual Studio Build Tools`の各機能を構成する部品の単位。
- Roslyn コンパイラ:　Microsoft がオープンソースで提供している C#コンパイラ
- Developer PowerShell: 起動時に各言語のコンパイルに必要な環境変数を設定した`PowerShell
- "Hello, World": プログラミング言語において、最初に書かれる簡単なプログラム。開発環境やプログラミング学習の際の基準としてよく使用される

## 1. Visual Studio Build Toolsとは

`Visual Studio Build Tools`は、コマンドラインでプログラムのコンパイルやビルドを行なうためのツールです。
通常の`Visual Studio`では、GUI上から簡単にコンパイルやビルドができますが、`Build Tools`ではコマンドラインからの操作が必要となります。

`Build Tools`の各コマンドは、コマンドラインから実行します。このため、自動化スクリプトやビルドツールで使用できます。

なお、`Build Tools`を利用するには、[マイクロソフトのライセンス](https://visualstudio.microsoft.com/ja/license-terms/vs2022-ga-diagnosticbuildtools/)に同意する必要がありますので、注意してください。

**注意:**

- [マイクロソフト ソフトウェア ライセンス条項](https://visualstudio.microsoft.com/ja/license-terms/vs2022-ga-diagnosticbuildtools/)に同意する必要がある

## 2. Build Toolsのインストール手順

`Build Tools`は`Visual Studio Installer`からインストールします。
インストールするコンポーネントは、通常インストーラーの GUI で選択します。
また、`xx.config`という構成ファイルを使ってもインストールできます。

### 2.1. 構成ファイルを使用したBuild Toolsのインストール

`Visual Studio Installer`に`--config`オプションを指定すると、指定した構成ファイルに基づいて`Build Tools`をインストールします。
このオプションを使用すると、一度作成した`Build Tools`の構成を詳細かつ正確に再現できます。

i 下の例では、構成ファイル`minimum.vsconfig`を使って`Build Tools`をインストールします。

``` powershell
vs_BuildTools.exe --config minimum.vsconfig

```

**注意事項:**

- 構成ファイル`minimum.config`については、[2.2](#22-使用する構成ファイル)を参照のこと。

### 2.2. 使用する構成ファイル

構成ファイルは、インストールするコンポーネントの一覧を記載した`JSON`形式のファイルです。
`Visual Stuido Installer`の GUI では`C++デスクトップ`などのパッケージや個別のコンポーネントを選択します。
このときに選択した各コンポーネントが、Vsconfig ファイルに記載されます。
たとえば、`Microsoft.VisualStudio.Component.Roslyn.Compiler`は Roslyn というコンパイラで、C#プログラムのコンパイルに使います。

今回使用する構成ファイルは、以下の通りです。

```json: minimum.vsconfig
{
  "version": "1.0",
  "components": [
    "Microsoft.VisualStudio.Component.Roslyn.Compiler",
    "Microsoft.Component.MSBuild",
    "Microsoft.VisualStudio.Component.CoreBuildTools",
    "Microsoft.VisualStudio.Workload.MSBuildTools",
    "Microsoft.VisualStudio.Component.VC.CoreBuildTools",
    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
    "Microsoft.VisualStudio.Component.VC.Redist.14.Latest",
    "Microsoft.VisualStudio.Component.TextTemplating",
    "Microsoft.VisualStudio.Component.VC.CoreIde",
    "Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core",
    "Microsoft.VisualStudio.Workload.VCTools",
    "Microsoft.VisualStudio.Component.Windows11SDK.22621",
    "Microsoft.VisualStudio.Component.FSharp.MSBuild",
    "Microsoft.VisualStudio.Component.Roslyn.LanguageServices"
  ]
}

```

下記に、インストールする主要なコンポーネントとその説明を載せておきます:

| コンポーネント |  概要 | 備考 |
| --- | --- | --- |
| `Microsoft.VisualStudio.Component.Roslyn.Compiler` | Roslyn  コンパイラ | C#コンパイラ |
| `Microsoft.Component.MSBuild` | MS 製ビルドツール | 必須 (今回は使用しない) |
| `Microsoft.VisualStudio.Component.VC.CoreBuildTools` | `VC Core Build Tools` | C++コンパイラコア |
| `Microsoft.VisualStudio.Component.VC.Tools.x86.x64` |  `Visual C++ Tools` | Windows用C++コンパイラ |
| `Microsoft.VisualStudio.Component.Windows11SDK.22621` | `WIndows 11 SDK` | C/C++用標準ライブラリを含む |
| `Microsoft.VisualStudio.Component.FSharp.MSBuild` | `F# MS Build` | F# コンパイラ |

### 2.3. 構成ファイルの作成

以下の手順で、構成ファイルを作成します。

1. `VIsual Studio Installer`のを起動:
    スタートメニューで`Visual Studio Installer`を選び、インストーラーを起動します

2. 構成ファイルのエクスポート:
    `[その他]`-`[構成ファイルのエクスポート]`を選び、構成ファイルを出力します

### 2.4. 構成ファイルによる`Build Tools`のインストール

`VIsual Studio Build Tools`は、インストーラーに`--config <vsconfigファイル>`オプションをつけることで、構成ファイルに指定したコンポーネントをインストールします。
また、winget を使って`Build Tools`をインストールできます。

以下の手順で、winget を使って`Build Tools`をインストールします。

1. 以下のコマンドを実行:
  コマンドラインで`winget`を実行します。このとき`--override`オプションで`Visual Studio Installer`に`--config`オプションを指定します。

   ```powershell
   winget install Microsoft.VisualStudio.2022.BuildTools --override "--passive --config minimum.vsconfig"
   ```

2. インストール画面の表示:
    正常に実行されれば、下記のインストール画面が表示されます
    ![インストール画面](https://i.imgur.com/b3OAuZ4.png)

以上で、`Build Tools`のインストールは終了です。

## 3. 開発環境の構築

### 3.1. パスの設定

環境変数`Path`に以下のパスを追加します。PC を再起動すると、各言語のコンパイラが使えるようになります。

| パス | 対象言語 |
| --- | --- |
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64` | C/C++ コンパイラ `(Windows x64)`|
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn` | C#コンパイラ |
|`C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools` |  F# コンパイラ |

### 3.2. 開発環境コンソールの設定

`Build Tools`のインストールに成功すると、`Windows Terminal`に`Developer PowerShell for  ...'という項目が追加されます。

この項目の PowerShell は、旧来の`Windows PowerShell`を使用していて使い勝手がよくありません。
代わりに、自分用にカスタマイズ済みの`PowerShell Core`を使って起動するように、設定を書き換えます。

次の手順で、`Windows Terminal`を書き換えます。

  1. [設定]を開く:
    `Windows Terminal`で`Ctrl+,`を入力し、[設定]を開く
    ![設定](https://i.imgur.com/D7GBrd3.png)

  2. [Developer PowerShell]を選択する
    ![設定-Developer PowerShell](https://i.imgur.com/dV1kmPn.png)

  3. [コマンドライン]を書き換える
    コマンドラインの`powershell.exe`を`pwsh.exe`書き換えて、[保存]をクリックします。
    ![設定 - コマンドライン書き換え](https://i.imgur.com/fQpcxbo.png)

以上で、`Build Tools`のインストールと開発環境の構築は終了です。

## 4. 開発環境の確認

`Build Tools`が正常に動いているか、各言語で"Hello, World"プログラムを作成して確認します。

### 4.1  "Hello,World"による開発環境の確認

[#3. 開発環境の構築](#3-開発環境の構築)までの操作が正常に終了していれば、C++/C#/F#の各プログラミング言語でプログラムのコンパイル／実行ができます。
この章では、動作確認用に各プログラミング言語で"Hello, World"プログラムを作成し、正常にコンパイルできるかを確認します。

**注意事項:**
以下は、`Developer PowerShell`上で動作確認しています。

### 4.2. C++での動作確認

次の手順で、C++の開発環境を確認します。

1. 作業用ディレクトリに移動:
  `Developer PowerShell`を開き、プログラミング用の適当な作業用ディレクトリに移動する。

    ```powershell
    > cd ~\workspaces\temp\src\cpp
    ```

2. `hello.cpp` の作成:
   下記の`hello.cpp`プログラムを作成:

    ```cpp: hello.cpp
    #include <iostream>

    using namespace std;

    void main()
    {
        cout << "Hello, I'm C++." << endl;
    }
    ```

3. `hello.exe`の作成
   C++コンパイラ (`cl`)で、上記`hello.cpp`プログラムをコンパイルする
  
   ```powershell
   cl hello.cpp
   Microsoft(R) C/C++ Optimizing Compiler Version 19.36.32535 for x64
   Copyright (C) Microsoft Corporation.  All rights reserved.
   hello.cpp
   
   Microsoft (R) Incremental Linker Version 14.36.32535.0
   Copyright (C) Microsoft Corporation.  All rights reserved.
   /out:hello.exe
   hello.obj
   
   ```

    **注意:**
    `warning`がでていても、`/out:hello.exe`が表示されていればコンパイルは成功しています。

4. `hello.exe` の実行:
    `hello.exe`を実行し、正常に動作するかを確認します。

    ```powershell
    Hello, I'm C++.
     ```

上記のように、`Hello, I'm C++.`と出れば正常です。

### 4.3. C#での動作確認

次の手順で、C#の開発環境を確認します。

1. 作業用ディレクトリに移動:
  `Developer PowerShell`を開き、プログラミング用の適当な作業用ディレクトリに移動する。
  
    ```powershell
    > cd ~\workspaces\temp\src\c#
    ```

2. `hello.cs`の作成:
    下記の`hello.cs`プログラムを作成する

    ```csharp: hello.cs
    using System;

    namespace hello
    {
        public class hello
        {
            public static void Main(string[] args)
            {
                Console.WriteLine("Hello, I'm C#");
            }
        }
    }
    ```

3. hello.exe の作成:
   C#コンパイラ(`csc`)で、上記"hello.cs"プログラムをコンパイルする

    ```powershell
    csc .\hello.cs
    Microsoft (R) Visual C# Compiler バージョン 4.6.0-3.23259.8 (c3cc1d0c)
    Copyright (C) Microsoft Corporation. All rights reserved.
    
    >
    ```

4. hello.exe の実行確認:
    hello.exe を実行し、出力を確認する

    ```powershell
    Hello, I'm C#
    ```

上記のように、`Hello, I`m C#`と出れば正常です。

### 4.4. F#での動作確認

次の手順で、F#の開発環境を確認します。

1. 作業用ディレクトリに移動:
  `Developer PowerShell`を開き、一時時作業用ディレクトリに移動する。

    ```powershell
    > cd ~\workspaces\temp\src\f#
    ```

2. `hello.fs`の作成:
    下記の`hello.fs`プログラムを作成:

    ```fsharp: hello.fs
    printf "Hello, I'm F#"

    ```

3. `hello.exe`の作成:
    F#コンパイラを実行し、hello.exe を作成

    ```powershell
   fsc hello.fs
   Microsoft (R) F# Compiler バージョン F# 7.0 のための 12.5.0.0
   Copyright (C) Microsoft Corporation. All rights reserved.
   
   >
   ```

4. hello.exe の実行確認:
    hello.exe を実行し、出力を確認する

   ```powershell
   Hello, I'm F#
   ```

上記のように、`Hello, I`m F#`と出れば正常です。

## さいごに

以上で、`Visual Studio Build Tools`のインストールと動作確認が終了しました。
これからは、C++/C#/F#でのプログラミングができます。

make などの開発ツールと併用することで大規模ソフトウェアの開発もできますし、`Rust`のようなソフトウェア開発に C++のコンパイルが必須なプログラミング言語も利用できます。

これを機会に、プログラミングの世界に飛び込んでみてください。

それでは、Happy  hacking!

## 参考資料

### Webサイト

- [Visual Studio](https://visualstudio.microsoft.com/ja/)
- [コマンド ライン パラメーターを使用した、Visual Studio のインストール、更新、管理](https://learn.microsoft.com/ja-jp/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022)
- [Roslyn GitHubリポジトリ](https://github.com/dotnet/roslyn)
