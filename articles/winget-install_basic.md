---
title: "Windows: wingetでの基本的なアプリのインストール方法"
emoji: "🪆"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["SCM","Windows","wiget","構成管理"]
published: true
---
# はじめに

wingetでは、パッケージを指定してアプリをインストールします。この記事では、パッケージのさまざまな指定方法を紹介します。

# helpとversion

まず、コマンドの使い方が分からないときはhelpとversionを試すと良いでしょう。helpは、コマンドの簡単な使い方を教えてくれます。versionはコマンドがキチンと動いていることを確認できます。

wingetでは、次のように入力します。

- version
  
  `winget --version`  wingetのバージョンを表示します
  
  ```powershell
  /workspaces > winget --version
  v1.0.11694
  
  ```
  
  
  `winget --info`   バージョン以外に、Copyrightやドキュメントへのリンクなど、もう少し詳細な情報を表示します。
  
  ``` powershell
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

# 基本的なインストール


- パッケージを指定する
  
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

  ```powershell
  /workspaces > winget install python4
  入力条件に一致するパッケージが見つかりませんでした。
  
  ```
  
  


- 複数のパッケージが見つかった

  名前を入力した場合、入力した名前を含むパッケージを検索します。2つ以上のパッケージが見つかった場合は**パッケージが見つからなかった**こととし、エラーメッセージを出力して終了します。

  ```powershell
  /workspaces > winget install --name python
  入力条件に一致するパッケージが見つかりませんでした
  
  ```
  
  


- 空白を含むパッケージ

  パッケージが空白を含む場合は、パッケージを引用符('または")で囲みます

  ``` powershell
  
  /workspaces > winget install 'Python 3'
  見つかりました Python 3 [Python.Python.3]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
    ██████████████████████████████  24.8 MB / 24.8 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  
  ```
  
  
  
  # 名前, id, モニカー



パッケージの指定には、名前<sub>(パッケージ名)</sub>, id , モニカーが使えます。この章では、それぞれの場合のインストール方法を説明します。


- 名前

  名前<sub>(パッケージ名)</sub>は、インストールするアプリに一般的な呼称です。ただし、Pythonのようにバージョン違いが存在する場合、バージョンをふくめたかたちが名前となります。

  名前を指定してパッケージをインストールする場合は、`--name`オプションを使用します

  ``` powershell
  /workspaces > winget install --name "Python 3"
  見つかりました Python 3 [Python.Python.3]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
    ██████████████████████████████  24.8 MB / 24.8 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  
  ```
  
- id

  idは、wingetが各パッケージを識別するためにつけた識別子です。idを使用することで、特定のパッケージを指定指定インストールできます。

  idを指定してインストールする場合は、`--id`オプションを使用します

  ``` powershell
  /workspaces > winget install --id Python.python.3
  見つかりました Python 3 [Python.Python.3]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
    ██████████████████████████████  24.8 MB / 24.8 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  
  ```
  
- モニカー

  モニカーはパッケージの別名です。モニカーは、バージョン違いがあるパッケージで代表するパッケージを指定するときなどに使います。例えば、モニカー*python*はPython 3の別名として定義されています。

  モニカーを指定してインストールする場合は、`--moniker`オプションを使用します

  ``` powershell
  /workspaces > winget install --id Python.python.3
  見つかりました Python 3 [Python.Python.3]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
    ██████████████████████████████  24.8 MB / 24.8 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  
  ```

# まとめ

モニカーがあるおかげで、使う分には普通にアプリ名を入れるだけで問題ありません。うまくいかない場合は、`search`で調べて引用符でパッケージ名を囲めば大抵うまくいきます。

ただ、idで指定すれば確実に自分の欲しいパッケージが指定できます。スクリプトでインストールする場合などを考えると、覚えておいて損はないでしょう。

