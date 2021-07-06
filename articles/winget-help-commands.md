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

