---
title: "開発環境: Visual Studio Build Toolsをインストールする方法"
emoji: "🦾"
type: "tech"
topics: ["開発環境", "BuildTools", "cpp", "winget", "vsconfig"]
published: false
---

## はじめに

`Visual Studio Build Tools`をインストールして、C++/C#/F#の開発環境を構築する方法について紹介します。

### 対象読者

Windows でプログラミングをしている ITエンジニア、プログラマーを対象としています。

## 1. Visual Studio Build Toolsとは

`Visual Studio Build Tools`は、コマンドラインでプログラムのコンパイルやビルドを行なうためのツールです。
通常の`Visual Studio`では、GUI上から簡単にコンパイルやビルドができますが、`Build Tools`ではコマンドラインからの操作が必要となります。

なお、`Build Tools`を利用するには、[マイクロソフトのライセンス](https://visualstudio.microsoft.com/ja/license-terms/vs2022-ga-diagnosticbuildtools/)に同意する必要がありますので、注意してください。

**注意事項:**

- [マイクロソフト ソフトウェア ライセンス条項 ](https://visualstudio.microsoft.com/ja/license-terms/vs2022-ga-diagnosticbuildtools/)に同意する必要がある

## 2. Build Toolsのインストール手順

`Build Tools`は`Visual Studio Installer`からインストールします。
インストールするコンポーネントは、通常インストーラーの GUI で選択します。
また、`xx.config`という構成ファイルを使ってもインストールできます。

### 2.1. 構成ファイルを使用したBuild Toolsのインストール

構成ファイルを使ったインストールには、`--config`オプションを使って構成ファイルを指定します。

以下のようにして、構成ファイルを使って`Build Tools`をインストールします。

``` PowerShell
vs_BuildTools.exe --config minimum.vsconfig

```

**注意事項:**

- 構成ファイル`minimum.config`については、[2.2](#22-使用する構成ファイル)を参照のこと。

### 2.2. 使用する構成ファイル

`Build Tools`の構成ファイルは、インストールするコンポーネントを列挙した`json`形式のファイルです。
構成ファイルは、`Visual Studio Installer`の GUI上で`[その他]`-`[構成のエクスポート]`を選ぶと作成できます。
このときにインストール済みの`Build Tools`のコンポーネント一覧が、構成ファイルに出力されます。

今回、使用する構成ファイルは次のようになります。

``` json: minimum.vsconfig
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
    "Microsoft.VisualStudio.Component.Roslyn.LanguageServices",
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
| `Microsoft.VisualStudio.Component.FSharp.MSBuild` | F# MS Build | F# コンパイラ |

### 2.3. 構成ファイルの作成

以下の手順で、構成ファイルを作成します。

1. `VIsual Studio Installer`のを起動:
    スタートメニューで`Visual Studio Installer`を選び、インストーラーを起動します。

2. 構成ファイルのエクスポート:
    `[その他]`-`[構成ファイルのエクスポート]`を選び、構成ファイルを出力します。

### 2.4. 構成ファイルによる`Build Tools`のインストール

`VIsual Studio Build Tools`は、インストーラーに`--config <vsconfigファイル>`オプションをつけることで、構成ファイルに指定したコンポーネントをインストールします。
また、winget を使って`Build Tools`をインストールできます。

以下の手順で、winget を使って`Build Tools`をインストールします。

1. 以下のコマンドを実行:
  コマンドラインで`winget`を実行します。このとき`--override`オプションで`Visual Studio Installer`に`--config`オプションを指定します。

   ``` PowerShell
   winget install Microsoft.VisualStudio.2022.BuildTools --override "--passive --config minimum.vsconfig"
   ```

2. インストール画面の表示:
    正常に実行されれば、下記のインストール画面が表示されます
    ![インストール画面](https://i.imgur.com/b3OAuZ4.png)

以上で、`Build Tools`のインストールは終了です。

## 3. 開発環境の設定

### 3.1. Pathの設定

環境変数`Path`に以下のパスを追加します。PC を再起動すると、各言語のコンパイラが使えるようになります。

| Path | 内容 |
| --- | --- |
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64` | C/C++ コンパイラ (Windows x64)|
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn` | C#コンパイラ |
|`C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools` |  F# コンパイラ |

### 3.2. 開発環境コンソールの設定

`Build Tools`のインストールに成功すると、`Windows Terminal`に`Developer PowerShell for VS 2022'という項目が追加されます。

この項目の PowerShell は、旧来の`Windows PowerShell`を使用していて使い勝手がよくありません。
`WIndows PowerShell`ではなく`PowerShell Core`を使用するように、設定を書き換えます。

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

**注意事項:**
以下は、`Developer PowerShell`上で動作確認しています。

### 4.1. C++でHello, World

次の手順で、C++の開発環境を確認します。

1. `Developer PowerShell`で一時作業用ディレクトリに移動:

    ``` PowerShell
    > cd ~\workspaces\temp\src
    ```

2. 下記の`hello.cpp`プログラムを作成:

    ``` hello.cpp
    #include <iostream>

    using namespace std;

    void main()
    {
        cout << "Hello, I'm C++." << endl;
    }
    ```

3. 上記プログラムをコンパイル:
    `Build Tools`では、C++コンパイラは`cl.exe`です。
    `cl`を使って、上記`hello.cpp`をコンパイルします。

    ``` PowerShell
    cl hello.cpp
    Microsoft(R) C/C++ Optimizing Compiler Version 19.36.32535 for x64
    Copyright (C) Microsoft Corporation.  All rights reserved.
    hello.cpp
    C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.36.32532\include\ostream(774): warning C4530: C++ 例外処理を使っていますが、アンワインド セマンティクスは有効にはなりません。/EHsc を指定してください。
    hello.cpp(7): note: コンパイル対象の関数 テンプレート インスタンス化 'std::basic_ostream<char,std::char_traits<char>> &std::operator <<<std::char_traits<char>>(std::basic_ostream<char,std::char_traits<char>> &,const char *)' のリファレンス を確認してください
    Microsoft (R) Incremental Linker Version 14.36.32535.0
    Copyright (C) Microsoft Corporation.  All rights reserved.

    /out:hello.exe
    hello.obj
    ```

    **注意:**
    `warning`がでていても、`/out:hello.exe`が表示されていればコンパイルは成功しています。

4. `hello.exe` の実行確認:
    `hello.exe`を実行し、正常に動作するかを確認します。

    ``` PowerShell
    > .\hello.exe
    Hello, I'm C++.
    >
    ```

    上記のように、`Hello, I'm C++.`と出れば正常です。

### 4.2. C#でHello, World

次の手順で、C#の開発環境を確認します。

1. `Developer PowerShell`で一時作業用ディレクトリに移動:

    ``` PowerShell
    > cd ~\workspaces\temp\src
    ```

2. 下記の`hello.cs`プログラムを作成:

    ``` hello.cs
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

3. C#コンパイラを実行し、hello.exe を作成

    ``` PowerShell
    csc .\hello.cs
    Microsoft (R) Visual C# Compiler バージョン 4.6.0-3.23259.8 (c3cc1d0c)
    Copyright (C) Microsoft Corporation. All rights reserved.
    
    >
    ```

4. hello.exe の実行確認:
    hello.exe を実行し、出力を確認する

   ``` PowerShell
    > .\hello.exe
    Hello, I'm C#
    >
    ```

上記のように、`Hello, I`m C#`と出れば正常です。

### 4.3. F#でHello, World

次の手順で、C#の開発環境を確認します。

1. `Developer PowerShell`で一時作業用ディレクトリに移動:

    ``` PowerShell
    > cd ~\workspaces\temp\src
    ```

2. 下記の`hello.cs`プログラムを作成:

    ``` hello.fs
    printf "Hello, I'm F#"

    ```

3. C#コンパイラを実行し、hello.exe を作成

    ``` PowerShell
   fsc hello.fs
   Microsoft (R) F# Compiler バージョン F# 7.0 のための 12.5.0.0
   Copyright (C) Microsoft Corporation. All rights reserved.
   
   >
   ```

4. hello.exe の実行確認:
    hello.exe を実行し、出力を確認する

  ```PowerShell
    > .\hello.exe
    Hello, I'm F#
    >
    ```

上記のように、`Hello, I`m F#`と出れば正常です。

## さいごに

以上で、`Visual Studio Build Tools`のインストールと開発環境の設定が完了しました。
これで、コマンドラインから`C++`,`C#`,`F#`の各プログラムのコンパイルが行えます。

`make`などのビルドツールを使うことで、大規模ソフトウェアの作成もできますし、`Rust`のようなC++コンパイラが必要なプログラミング言語のインストールもできます。

これを機会に、プログラミングの世界に飛び込んでみてください。

それでは、Happy hacking!

## 参考資料

### Webサイト

- [Visual Studio](https://visualstudio.microsoft.com/ja/)
- [コマンド ライン パラメーターを使用した、Visual Studio のインストール、更新、管理](https://learn.microsoft.com/ja-jp/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022)
- [Roslyn GitHubリポジトリ](https://github.com/dotnet/roslyn)
