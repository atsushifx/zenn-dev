---
title: "Windows: winget: wingetでオプション付きで、アプリをインストールする"
emoji: "🪆"
type: "tech"
topics: ["Windows","構成管理", "SCM", "winget", "PackageManager"]
published: true

---

## はじめに

winget では、インストール時にオプションを指定できます。とはいえ、まだ開発プレビューなので、すべてがうまく動いているわけではありません。

この記事では、知っていると便利なオプションの解説をします。 *`winget v1.0.11694`で試した結果に基づいています*

## 基本的なインストール構文

winget は、次の構文でアプリをインストールします。

`winget install <package> [<オプション>]`

\<package\>は、インストールするアプリのパッケージを指定します。指定の仕方は、[wingetでの基本的なアプリのインストール方法](winget-install_basic)を参照してください。

\<オプション\>は、インストーラの細かな動作を指定します。よく使うオプションは、この記事で解説します。

## よく使うオプション

よく使うオプションを解説します。

- `--help`
  install コマンドで使える各オプションについて出力します

   ``` :PowerShell
   winget install --help
   
   ```

- `-i`, `--interactive`
  対話式のインストールを行います。ユーザーの入力が必要となる場合があります。

   ``` :PowerShell
   winget install <package> --interactive
   
   ```

- `-h`, `--silent`

  サイレントインストールを行います。*パッケージが対応している場合*

   ``` :PowerInstall
   winget install <package> --silent
   
   ```

- `-o`, `--log`
  指定したログファイルにインストールログを出力します。

   ``` powershell
   winget install <packag> --log <logfile>
  
   ```

- `-e`, `--exact`
  英語の大文字小文字もふくめ、入力したキーワードに完全一致するパッケージをインストールします。*主にidでパッケージを指定します*

   ``` :PowerShell
   winget install --exact <package>
  
   ```

- `-v`, `--version`
  指定したバージョンのパッケージをインストールします。~(このオプションを指定しない場合は、最新バージョンをインストールします)~

   ``` :PowerShell
   winget install <package> --version <version>
  
   ```

- `-l`, `--location`
  オプションで指定された場所に、アプリをインストールします。*パッケージが対応している場合*
  **現在、空白をふくむフォルダには対応していません**

   ``` :PowerShell
   winget install <package> --location <installDir>
   
   ```

- `--override`
  パッケージのインストーラに対して、オプションを指定します。
  インストール先の変更など、アプリ毎の細かい指定にこのオプションを使います。
  **複数のオプションを指定したい場合は、引用符で括ります**

   ``` :PowerShell
   winget install <package> --override <installOption>
   
   ```

## リンク

以下のリンクが参考になります。

- [install コマンド (winget)](https://docs.microsoft.com/ja-jp/windows/package-manager/winget/install)
  - Microsoft の公式ドキュメント
