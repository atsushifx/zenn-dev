---
title: "wingetインストールガイド: wingetコマンドが見付からない場合の対処法"
emoji: "🪟"
type: "tech"
topics: ["Windows", "hacks", "環境構築", "winget", ]
published: true
---

## tl;dr

以下の手順に従って、`winget`をインストールできます。

1. `GitHub`上の`winget-cli`リポジトリから最新の`msixbundle`パッケージをダウンロード
2. `Add-AppxPackage`コマンドで、ダウンロードした`msixbundle`パッケージをインストール
3. `winget settings`コマンドを使用して、`winget`を設定

以上で、インストールが正常に完了しました。
Enjoy!

## はじめに

この記事では、`winget`コマンドが見つからない場合に、`winget`を再設定する手順を紹介します。
今回は、`Microsoft Store`を使用せずに`GitHub`から直接`winget`をインストールする方法を紹介します。

## 1. `winget`のインストール手順

### 1.1 `winget`パッケージをダウンロードする

以下の手順で`winget`パッケージをダウンロードします:

1. `winget-cli`リポジトリの`リリースページ`にアクセス:
   [`リリースページ`](https://github.com/microsoft/winget-cli/releases)にアクセスする。

2. 最新の`Windows Package Manager`をダウンロード:
  `Latest`タグのついた、`msixbundle`ファイルをダウンロードする。

  :::message alert
  `ダウンロード`フォルダ (`~/Downloads`) に保存する
  :::

### 1.2 `winget`パッケージをインストールする

`Add-AppxPackage`コマンドを使用して、ダウンロードした`msixbundle`パッケージをインストールします。
以下のコマンドを実行します:

```powershell
Add-AppxPackage ~\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

```

:::message alert
`ダウンロード`フォルダ (`~\Downloads`) にパッケージが保存されていることを確認する。
:::

インストールが成功したかを確認するには、以下のコマンドを実行します:

```powershell
winget --version

```

正常にインストールされている場合は、バージョン番号が表示されます。

## 2. `winget`の設定

### 2.1　`winget`を設定する

以下の手順で、`winget`を設定します:

1. `winget settings`コマンドで設定ファイルを開く:

   ```powershell
   winget settings

   ```

2. 設定ファイル`settings.json`を次のように編集する:

   ```json:settings.json
   {
     "$schema": "https://aka.ms/winget-settings.schema.json",

      // For documentation on these settings, see: https://aka.ms/winget-settings
      "source": {
        "autoUpdateIntervalInMinutes": 120
      },
      "experimentalFeatures": {
        "directMSI": true,
        "dependencies": true,
        "configureExport": true
      }
   }
   ```

### 2.2 `winget`の設定項目

`winget`の設定項目は、以下の通りです:

| 設定項目 | 設定 | 説明 | 備考 |
| --- | --- | --- | --- |
| **source** |  |  **アプリケーションソース関連** | |
| autoUpdateIntervalInMinutes | 120 | ソースを更新する間隔 (分) | |
| **experimentalFeatures** | | **実験的項目** | |
| directMSI | true | `MSI`形式パッケージを直接インストール | false:`MSIEXEC`経由でインストール |
| dependencies | true | パッケージの依存関係解決 | 現在、依存しているパッケージの表示のみ |
| configureExport | true | 設定ファイルの出力可 |  |

### 2.3 `path`の設定

`winget`を実行するために、システム環境変数`path`に次の値を追加します:

| `path` | 説明 | 備考 |
| --- | ---| --- |
| %LOCALAPPDATA%\Microsoft\WinGet\Links | ポータブルアプリケーションのリンク | 管理者モード／開発者モードの場合のみ、リンクが追加される |
| %LOCALAPPDATA%\Microsoft\WindowsApps | `Microsoft Store`アプリケーションのリンク | `winget`を含む |

:::message alert
`LOCALAPPDATA`はアプリケーションのデータが格納するパスが設定される環境変数で、通常、"`C:\Users\<ユーザー名>\AppData\Local`"が設定されています。
:::

## おわりに

`システム`-`回復`で`PCをリセット`した際に`winget`が使えなくなった問題に基づき、`winget`の再設定の手順をまとめました。
この記事が、`winget`の再設定を必要とするユーザーにとって、お役に立てれば幸いです。

それでは、Happy Hacking!

## 技術用語と注釈

- **winget**:
  `Windows Package Manager`のコマンドラインツール。アプリケーションのインストールと管理をサポート。

- **Add-AppxPackage**:
  `Microsoft Store`で提供されているアプリを、アプリケーションパッケージを使用してインストールするための`powershell`コマンド。

- **msixbundle**:
  Microsoftが提供する、複数のファイル・リソースを1つにまとめたアプリケーションパッケージ形式。

- **Microsoft Store**:
  `Windows`の公式アプリストア。

- **path**:
  コマンドから実行ファイルを検索するディレクトリを設定する環境変数。

- **experimentalFeatures**:
  `winget`の設定項目の中で、実験的に提供されている機能を設定するグループ。

- **%LOCALAPPDATA%\Microsoft\WinGet\Links**:
  `winget`でインストールしたポータブルアプリ用のリンクを保存するディレクトリ。

- **%LOCALAPPDATA%\Microsoft\WindowsApps**:
  Windowsアプリのリンクを保存するディレクトリ。

## 参考資料

### Webサイト

- [`WinGet`ツールを使用したアプリケーションのインストールと管理](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/)
  Microsoftによる`winget`の概要

- [WinGet CLI Settings](https://aka.ms/winget-settings)
  `winget`の各設定項目の説明

- [`winget-cli`リポジトリ](https://github.com/microsoft/winget-cli)
  `MIcrosoft`による、`winget`コマンドの`GitHub`リポジトリ
