---
title: "wingetでのちょっとdeepなアプリのインストール方法"
emoji: "🪆"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["SCM","Windows","wiget","構成管理"]
published: false
---
# 【Windows】wingetで、アプリをインストールする



## はじめに

wingetでは、パッケージを指定してアプリをインストールします。この記事では、パッケージのさまざまな指定方法を紹介します。







## helpとversion

まず、コマンドの使い方が分からないときはhelpとversionを試すと良いでしょう。helpは、コマンドの簡単な使い方を教えてくれます。versionはコマンドがキチンと動いていることを確認できます。

wingetでは、次のように入力します。

- version

  `winget --version` wingetのバージョンを表示します

  `einget --info` バージョン以外に、Copyrightやドキュメントへのリンクなど、もう少し詳細な情報を表示します。

  ``` powershell
  /workspaces > winget --version
  v1.0.11694
  
  /workspaces > winget --info
  Windows Package Manager v1.0.11694
  Copyright (c) Microsoft Corporation. All rights reserved.
  
  Windows: Windows.Desktop v10.0.22000.51
  パッケージ: Microsoft.DesktopAppInstaller v1.15.11694.0
  
  ログ: %LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir
  
  リンク
  ----------------------------------------------------------------
  プライバシーに関する声明    https://aka.ms/winget-privacy
  使用許諾契約                https://aka.ms/winget-license
  サード パーティに関する通知 https://aka.ms/winget-3rdPartyNotice
  ホーム ページ               https://aka.ms/winget
  
  ```

- help

  `winget --help`  wingetで使えるサブコマンドを一覧で表示します。*`winget`のみでも同じ結果を表示します*

  ```powershell
  /workspaces > winget --help
  Windows Package Manager v1.0.11694
  Copyright (c) Microsoft Corporation. All rights reserved.
  
  WinGet コマンド ライン ユーティリティを使用すると、コマンド ラインからアプリケーションやその他のパッケージをインストールできます。
  
  使用状況: winget [<コマンド>] [<オプション>]
  
  使用できるコマンドは次のとおりです:
    install    指定されたパッケージをインストール
    show       パッケージに関する情報を表示します
    source     パッケージのソースの管理
    search     アプリの基本情報を見つけて表示
    list       インストール済みパッケージを表示する
    upgrade    指定されたパッケージをアップグレードします
    uninstall  指定されたパッケージをアンインストール
    hash       インストーラー ファイルをハッシュするヘルパー
    validate   マニフェスト ファイルを検証
    settings   設定を開く
    features   試験的な機能の状態を表示
    export     インストールされているパッケージのリストをエクスポート
    import     ファイル中のすべてのパッケージをインストール
  
  特定のコマンドの詳細については、そのコマンドにヘルプ引数を渡します。 [-?]
  
  次のオプションを使用できます。
    -v,--version  ツールのバージョンを表示
    --info        ツールの一般情報を表示
  
  詳細については、次を参照してください。 https://aka.ms/winget-command-help
  
  ```

  



## アプリのインストール

アプリをインストールするには、パッケージを指定してinstallコマンドを実行します。

`winget install <package>`で指定したパッケージをインストールします。



### 基本的なインストール

- パッケージを指定してインストール

  パッケージの指定方法には、名前、id、モニカーの3種類があります。オプションで指定しない場合は、名前、id、モニカーのいずれかが合致したパッケージをインストールします。

``` powershell
/workspaces > winget install python
見つかりました Python 3 [Python.Python.3]
このアプリケーションは所有者からライセンス供与されます。
Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
Downloading https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
  ██████████████████████████████  24.8 MB / 24.8 MB
インストーラーハッシュが正常に検証されました
パッケージのインストールを開始しています...
インストールが完了しました

```

- パッケージが見つからない

  指定した名前*あるいはid,モニカー*に合致するパッケージが見つからない場合は、エラーメッセージを出力して終了します。

  ``` powershell
  /workspaces > winget install python4
  入力条件に一致するパッケージが見つかりませんでした。
  
  ```

  

  - 複数のパッケージが見つかった

    名前を入力した場合、入力した名前を含むパッケージを検索します。2つ以上のパッケージが見つかった場合は**パッケージが見つからなかった**こととし、エラーメッセージを出力して終了します。

    ``` powershell
    /workspaces > winget install --name python
    入力条件に一致するパッケージが見つかりませんでした。
    ```

    

    
