---
title: "開発環境: Visual Studio Build Toolsをインストールして、C++/C#/F#の開発環境をつくる"
emoji: "🦾"
type: "tech"
topics: ["開発環境", "BuildTools", "cpp", "winget", "vsconfig"]
published: false
---

## はじめに

Windows 環境では、多くの場合 Visual Studio を使って C++,C#といったプログラミング言語の開発環境が構築されます。
通常、`Visual Studio Community` などの統合開発環境(IDE)をインストールし、その IDE上で開発を行なうことが一般的です。

本記事では、コマンドラインからコンパイルだけを行なうための開発環境を構築します。
そのために用いるのが、Visual Studio Build Tools です。
とくに Rust のような C/C++のコンパイルが必要になるプログラミング言語を導入する際に、本記事は役立つでしょう。

## 1. Build Tools について

`Visual Studio Build Tools`は、コマンドラインからプログラムのコンパイル／ビルドをする機能を提供するツールです。
そのほかの`Visual Studio`ファミリーでは GUI上からの操作で簡単にコンパイルやビルドができますが、`Build Tools`はコマンドラインからの操作が必要です。

なお、`Build Tools`を使用するには、[マイクロソフトのライセンス](https://visualstudio.microsoft.com/ja/license-terms/vs2022-ga-diagnosticbuildtools/)に同意する必要があります。
注意してください。

## 2. Build Toolsのインストール

次の手順で、`Visual Studio Build Tools`をインストールします。

### 2.1. 構成ファイルを使ったBuild Toolsのインストール

`Build Tools`は`Visual Studio Installer`から C/C++コンパイラなどの必要なコンポーネントを選んでインストールします。
通常は、インストーラーの GUI上でインストール／アンインストールするコンポーネントを選択します。

その代わり、`xx.vsconfig`という構成ファイルでインストールするコンポーネントを指定できます。
この場合、コンポーネントのアンインストールはできません。

### 2.2. 構成ファイルの作成

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
|  `MSBuild  Tools` | MS 製ビルドツール | 必須 (今回は使用しない) |
|  C++ デスクトップ開発 | C/C++用コンパイルコアツール | |
|  `VS2022 C++ x64/x86`  ビルド | WIndows 用 C++コンパイラ  | Windows 用 C++コンパイラ本体 |
| `Windows 11 SDK` |Windows Software Development Kit | C/C++用の標準ライブラリ |
|  F#コンパイラ |  F#コンパイル環境  | F＃言語用 |
| C#および Visual Basic | C# コンパイル環境 | C# 言語用 |

### 2.3. wingetを使って`Build Tools`をインストールする

`Visual Studio Build Tools`は、Windows パッケージマネージャー`winget`を使ってインストールできます。
次の手順で、`VIsual Studio Build Tools`をインストールします。

1. コマンドラインで次のコマンドを実行:
   ``` PowerShell
   winget install Microsoft.VisualStudio.2022.BuildTools --override "--passive --config minimum.vsconfig"
   ```

2. インストール画面の表示
    正常に実行されれば、下記のインストール画面が表示されます
    ![インストール画面](https://i.imgur.com/b3OAuZ4.png)

以上で、`Build Tools`のインストールは終了です。

## 3. 開発環境の設定

### 3.1. Pathの設定

環境変数`Path`に以下のパスを追加します。PC を再起動すると、各言語のコンパイラが使えるようになります。

| Path | 内容 |
| --- | --- |
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.36.32532\bin\HostX64\x64` | C/C++用コンパイラ |
| `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn` | C#用コンパイラ |
|`C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools` |  F#用コンパイラ |

### 3.2. 開発環境コンソールの設定

インストールに成功すると、`Windows Terminal`に`Developer PowerShell for VS 2022`という項目が追加されます。
旧来の`PowerShell` を呼び出しているので、`PowerShell 7`に書き換えます。

次の手順で、`PowerShell`を書き換えます。

1. `Windows Terminal`で`Ctrl+,`を入力し、`[設定]`を開く
    ![設定](https://i.imgur.com/D7GBrd3.png)

2. `[Developer PowerShell]`を選択する
    ![設定-Developer PowerShell](https://i.imgur.com/dV1kmPn.png)

3. `[コマンドライン]`を書き換える
    コマンドラインの`powershell.exe`を`pwsh.exe`書き換えて、`[保存]`をクリックします。
    ![設定 - コマンドライン書き換え](https://i.imgur.com/fQpcxbo.png)

以後、`Developer PowerShell`で、自分好みにカスタマイズした`PowerShell`が使えます。

## 4. 開発環境の確認

`Build Tools`が正常に動いているか、各言語で"Hello, World"プログラムを作成して確認します。

**注意**:
以下は、`Developer PowerShell`で動作確認しています。

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

3.  上記プログラムをコンパイル:
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

    **注意**:
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

### 4.3. F#でHello, World

## さいごに

## 参考資料

### Webサイト
