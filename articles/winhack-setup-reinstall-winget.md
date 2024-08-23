---
title: "wingetのインストールと設定方法 (コマンドが見付からない場合の対処法)"
emoji: "🪟"
type: "tech"
topics: ["Windows", "hacks", "環境構築", "winget", ]
published: false
---

## tl;dr

次の手順を実行することで、wingetをインストールできます。

1. `GitHub`の`winget-cli`リポジトリから最新の`msixbundler`パッケージをダウンロード
2. `Add-AppxPackage`コマンドで、ダウンロードした`msixbunle`パッケージをインストール
3. `winget settings`で、`winget`を設定

Enjoy!

## はじめに

この記事では、`winget`コマンドがインストールされていない、`Microsoft Store`で`アプリインストーラー`が見付からない場合に、`winget`をインストールする方法を説明します。

## 1. `winget`のインストール手順

### 1.1 `winget`パッケージをダウンロードする

`GitHub`の[`winget-cli`リポジトリ](https://github.com/microsoft/winget-cli)から、`winget`パッケージをダウンロードします。
次の手順で、`winget`パッケージをダウンロードします。

1. `winget-cli`リポジトリの`リリースページ`にアクセス:
   [`リリースページ`](https://github.com/microsoft/winget-cli/releases)にアクセスする。>

2. 最新の`Windows Package Manager`をダウンロード:
  `Latest`タグのついた、`msixbundle`ファイルをダウンロードする。

  **注意**:
  `~/Downloads`に保存する

### 1.2 `winget`パッケージをインストールする

`Add-AppxPackage`コマンドで、ダウンロードした`msixbundle`パッケージをインストールします。
`Powershell`のコマンドラインで、次のコマンドを実行します:

```powershell
Add-AppxPackage ~\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

```

**注意**:

`~\Downloads`ディレクトリにパッケージが保存されているものとする。

インストールが成功したか確認するには、次のコマンドを実行します:

```powershell
winget --version

```

正常にインストールされている場合は、バージョン番号が表示されます。

## 2. `winget`の設定

### 2.1　`winget`を設定する

`winget`の設定ファイルを変更して、設定を行います。
次の手順で、`winget`を設定します。

1. `winget settings`で設定ファイルを開く:
   `winget settings`コマンドを実行し、`winget`の設定ファイルを開く。

   ```powershell
   winget settings

   ```

2. 設定ファイルを修正する:
  設定ファイルを次のように修正します。

  ``` :settings.json
  {
    "$schema": "https://aka.ms/winget-settings.schema.json",

    // For documentation on these settings, see: https://aka.ms/winget-settings
    "source": {
        "autoUpdateIntervalInMinutes": 120
    },
    "experimentalFeatures": {
        "directMSI": true,
        "dependencies": true,
        "experimentalMSStore": true,
        "configureExport": true
    }
  }
  ```

### 2.2 `winget`の設定項目

各項目の説明は、次の通りです:

| 設定項目 | 設定 | 説明 | 備考 |
| --- | --- | --- | --- |
| autoUpdateIntervalInMinutes | 120 | ソースを更新する間隔 (分) | |
| directMSI | true | `MSI`パッケージの直接インストール | false:`MSIEXEC`経由でインストール |
| dependencies | true | パッケージの依存関係解決 | 現在、依存しているパッケージの表示のみ |
| experimentalMSStore | true | `Microsoft Store`上のアプリのインストール |  |
| configureExport | true | 設定ファイルの出力可 |  |

### 2.3 `path`の設定

`winget`を実行するために、システム環境変数`path`に以下の値を追加します:

| `path` | 説明 | 備考 |
| --- | ---| --- |
| %LOCALAPPDATA%\Microsoft\WinGet\Links | ポータブルアプリ用リンク | 管理者モード／開発者モードのみリンクが追加される |
| %LOCALAPPDATA%\Microsoft\WindowsApps | ストアアプリ用リンク | `winget`を含む |

**注意**:

環境変数`LOCALAPPDATA`には、アプリケーションのデータを格納するパスが設定されており、通常は"`C:\Users\<ユーザー名>\AppData\Local`"です。

## おわりに

`システム`-`回復`で`PCをリセット`した際に`winget`が使えなくなった経験をもとに、再設定の手順をまとめました。
この記事が同様の問題に直面したユーザーの参考になれば幸いです。

それでは、Happy Hacking!

## 技術用語と注釈

- **winget**:
  `Windows Package Manager`のコマンドラインツール。アプリケーションのインストールと管理をサポート。

- **Add-AppxPackage**:
  Windows PowerShellで使用するコマンドで、アプリパッケージをインストールするためのもの。

- **msixbundle**:
  Microsoftのアプリケーションパッケージ形式。

- **`Microsoft Store`**:
  `Windows`の公式アプリストア。

- **path**:
  コマンドから実行ファイルを検索するディレクトリを設定する環境変数。

- **experimentalFeatures**:
  `winget`の設定項目の中での、実験的な項目のグループを示す項目。

- **%LOCALAPPDATA%\Microsoft\WinGet\Links**:
  `winget`でインストールしたポータブルアプリ用のリンクを保存するディレクトリ。

- **%LOCALAPPDATA%\Microsoft\WindowsApps**:
  Windowsアプリのリンクを保存するディレクトリ。

- **settings;json**:
  `winget`のカスタマイズ項目を設定する設定ファイル。

## 参考資料

### Webサイト

- [`WinGet`ツールを使用したアプリケーションのインストールと管理](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/)
  Microsoftによる`winget`の概要

- [WinGet CLI Settings](https://aka.ms/winget-settings)
  `winget`の各設定項目の説明
