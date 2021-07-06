---
title: "wingetでよく使うであろうコマンド一覧"
emoji: "🪆"
type: "tech" 
topics: ["Windows",SCM","winget","構成管理","パッケージマネージャ"]
published: true
---

# 【Windows】wingetでよく使うコマンド

## はじめに

wingetを色々試したので、wingetの各コマンドとオプションを備忘録的に解説します。

## コマンド一覧

### インストール/アンインストール

- install  
  `winget install <package>`  
  指定したパッケージをインストールします。パッケージは、名前、id,モニカーで指定できます


- uninstall  
  `winget uninstall <package>`  
  指定したパッケージをアンインストールします。名称が正しければ、wingetでインストールしていないアプリもアンインストールできます。


- upgrade  
  `winget upgrade`  
  アップグレードできるパッケージの一覧を表示します。

  ```powershell
  winget upgrade
  
  名前           ID             バージョン  利用可能    ソース
  ------------------------------------------------------------
  Microsoft Edge Microsoft.Edge 91.0.864.59 91.0.864.64 winget
  
  ```


- upgrade <package>  
   `winget upgrade <package>`  
   指定したパッケージをアップグレードします。



### パッケージ関連

- search  
  `winget search <query> `  
  指定したqueryに合致するパッケージの一覧を表示します。queryの詳しい書き方は、[wingetでのパッケージ指定方法](/atsushifx/articles/winget-help-query)を参照してください。


- list  
   `winget list <query>`  
   wingetでインストールしたパッケージもふくめ、Windows上にインストールされたアプリの一覧が表示されます。この一覧に表示されているアプリは、wingetでuninstallできます。
   ``` powershell
   /workspaces > winget list
   名前                                     ID                                        バージョン        利用可能    ソース
   -----------------------------------------------------------------------------------------------------------------------
   sMedio TV Suite                          0E3921EB.sMedioTVSuite_agwrg61xdd7p4      1.1.0.29
   Bitwarden                                Bitwarden.Bitwarden                       1.27.0
   Tweeten                                  MehediHassan.Tweeten                      5.3.0
   Doki Doki Mod Manager 4.3.0              383f299c-84d5-5662-9125-2abaa1144a56      4.3.0
   7-Zip 21.00 alpha (x64)                  7-Zip                                     21.00 alpha
    .<
    .
    .
   
   ```


- show  
   `winget show  <package>`  
   指定されたパッケージの情報を出力します
   ``` powershell
   /workspaces > winget show python
   見つかりました Python 3 [Python.Python.3]
   
   Version: 3.9.6150.0
   Publisher: Python Software Foundation
   Author: Python Software Foundation
   Moniker: python3
   Description: Python is a programming language that lets you work more quickly and integrate your systems more effectively.
   Homepage: https://www.python.org
   License: PSF LICENSE AGREEMENT FOR PYTHON
   License Url: https://docs.python.org/3/license.html
   Installer:
     Type: Exe
     Locale: en-US
     Download Url: https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe
     SHA256: 3924caa094f70fd3ea667a27ad494d57941a487aa72d8b6b79ce60e81f1e497c
   
   ```



### インポート／エクスポート

- import  
  `winget import <applistfile>`  
  ファイルに指定されたパッケージをまとめて、Windowsにインストールします。インストール位置などの細かい指定は、選べません。

  ```powershell
  /workspaces > winget import .\winget-apps.json
  適用可能な更新は見つかりませんでした。
  パッケージは既にインストールされています: Google.Chrome
  見つかりました  [vim.vim]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://github.com/vim/vim-win32-installer/releases/download/v8.2.3113/gvim_8.2.3113_x64_signed.exe
    ██████████████████████████████  9.22 MB / 9.22 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  見つかりました  [stack.stack]
  このアプリケーションは所有者からライセンス供与されます。
  Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
  Downloading https://binaries.getstack.app/builds/prod/win/x64/Stack%20Setup%203.30.4-x64.exe
    ██████████████████████████████  57.3 MB / 57.3 MB
  インストーラーハッシュが正常に検証されました
  パッケージのインストールを開始しています...
  インストールが完了しました
  
  ```


- export  
  `winget export <applist>`  
  指定したファイルに、インストールされているアプリの一覧をjson形式で書き出します。wingetからインストールできないアプリ、パッケージについてはアラートメッセージを出力します。
  ``` powershell
  /workspaces > winget export out
  インストールされているパッケージのバージョンは、どのソースからも利用できません: sMedio TV Suite
  インストールされているパッケージのバージョンは、どのソースからも利用できません: Doki Doki Mod Manager 4.3.0
  インストールされているパッケージのバージョンは、どのソースからも利用できません: 7-Zip 21.00 alpha (x64)
  インストールされているパッケージのバージョンは、どのソースからも利用できません: Adobe Photoshop Express : 画像エディター、調整、フィルター、効果、境界線
   .
   .
   .
  ```


- applistのファイル形式  
    出力したファイルは、次の形式のjsonファイルになります。このファイルをimportすると、指定したパッケージをまとめてインストールします。

``` applist.json
{
  "$schema" : "https://aka.ms/winget-packages.schema.2.0.json",
  "CreationDate" : "2021-07-07T02:53:18.991-00:00",
  "Sources" : 
  [
    {
      "Packages" : 
      [
        {
          "PackageIdentifier" : "Bitwarden.Bitwarden"
        },
        {
          "PackageIdentifier" : "vim.vim"
        },
        {
          "PackageIdentifier" : "stack.stack"
        },
        {
          "PackageIdentifier" : "Google.Chrome"
        },
         .
         .
         .
        {
          "PackageIdentifier" : "Microsoft.PowerShell"
        }
      ],
      "SourceDetails" : 
      {
        "Argument" : "https://winget.azureedge.net/cache",
        "Identifier" : "Microsoft.Winget.Source_8wekyb3d8bbwe",
        "Name" : "winget",
        "Type" : "Microsoft.PreIndexed.Package"
      }
    }
  ],
  "WinGetVersion" : "1.0.11694"
}
```

