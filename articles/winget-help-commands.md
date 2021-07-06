---
title: "wingetでよく使うであろうコマンド一覧"
emoji: "🪆"
type: "tech" 
topics: ["SCM","winget","構成管理","CLI","WINDOWS"]
published: false
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
  
  `winget search <query>
  
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

   
