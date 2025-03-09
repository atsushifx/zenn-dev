---
title: "WSL 2: Debianのインストールと初期設定ガイド (2025年版)"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

`Windows Terminal`上で、以下のコマンドを実行して、Debian をインストール・セットアップします。

:::message alert
`WSL 2`を利用する場合は、`Windows 11`の使用を推奨します。
:::

1. `wsl --set-default-version 2`を実行
2. `wsl --install Debian`を実行
3. `wsl -d Debian`を実行し、ユーザーアカウントを作成
4. `Windows Terminal`を再起動

以上で、`Windows Terminal`に`Debian`が追加されます。

## はじめに

`atsushifx` です。
この記事では、`WSL 2`環境に Debian をインストールし、Linux コマンドラインを快適に利用する方法を解説します。
Debian のインストール手順から初期設定までを順を追って説明しています。
また、簡単なトラブルシューティングにより、Debian のインストール時に発生する可能性のあるトラブルにも対応しています。

`WSL 2`を通して Linux環境を活用することで、Windows上で本番環境に近い開発体験ができるでしょう。
Enjoy!

## 用語集

## 1. 前提条件

`WSL`を使用するには、以下の条件が必要です。

1. PC の仮想化支援機能 (`Intel VT-x` または `AMD-V`)が`BIOS`で有効になっていること
2. Windows が`WSL`に対応したバージョンであること
   :::message
   Windows 11 を推奨
   :::
3. Windows が`WSL`および`仮想マシン`関連の機能を有効化していること

上記の設定については、[GitHub からパッケージをダウンロードして WSL をセットアップする方法](wsl2-setup-from-github) を参考にしてください。

## 2. `WSL 2`とは

### 2.1 `WSL 2` の概要

`WSL 2`は、Microsoft がカスタマイズした Linux カーネルを使用した仮想環境を作成します。
従来の`WSL 1`と比較して、高速で互換性の高い Linux環境を提供するため、開発用途に適した環境が実現できます。

### 2.2 `WSL 2` を選ぶ理由

`WSL 2`は、実際の Linuxカーネルを利用することで、従来の`WSL 1`よりも高いパフォーマンスと互換性を実現します。
そのため、`Docker`などのコンテナ技術や最新の Linux ツールを活用する場合にも、より快適な環境が得られます。
また、Windows環境とシームレスに連携できるため、開発効率が向上し、プロジェクトごとの環境構築も簡易化される点が大きなメリットです。

## 3. Debian のインストール、セットアップ

`WSL 2`に Debian をインストールする手順を解説します。
`Windows Terminal`上でコマンドを実行して、Debian をインストールします。

### 3.1 `Windows Terminal`の起動

以下の手順で、`Windows Terminal`を起動します。

1. 実行ダイアログの表示:
   `[Win]+R`キーで[ファイル名を指定して実行]ダイアログを開きます。
   ![ファイル名を指定して実行](/images/articles/wsl2-debian/ss-winr-wt.png)
   *ファイル名を指定して実行*

2. `ターミナル`の起動:
    ダイアログに`wt`と入力して、[Enter]キーを押します。
    `Windows Terminal`が起動します。
    ![ターミナル](/images/articles/wsl2-debian/ss-terminal-normal.png)
    *ターミナル*

    :::message
    ターミナルの起動時に、`PowerShell`が立ち上がるように設定しています。
    以後、`PowerShell`上で操作する前提とします。
    :::

### 3.2 インストール先を`WSL 2`にする

Debian を`WSL 2`環境にインストールするため、`WSL`の既定バージョンを`WSL 2`に設定します。
以下の手順で、`WSL 2`に設定します。

1. 既定のバージョンを設定する:

   ```powershell
   wsl --set-default-version 2
   ```

2. メッセージが表示される:

   ```powershell
   WSL 2 との主な違いについては、https://aka.ms/wsl2
    を参照してください
    この操作を正しく終了しました。

   ```

以上で、インストール先を`WSL 2`に設定できました。

現在のインストール先は、次の手順で確認できます。

1. 既定のバージョンを確認する:

   ```powershell
   wsl --status
   ```

2. メッセージが表示される:

   ```powershell
   既定のバージョン: 2
   ```

上記のように、`既定のバージョン`が 2 であれば、`WSL 2`にインストールされます。

## 3.3 Debian のインストール手順

以下の手順で、`WSL 2` に Debian をインストールします。

1. Debian をインストールする:
   以下のコマンドを実行し、Debian をインストールします。

   ```powershell
   wsl --install Debian
   ```

   :::message
   本記事では、`PowerShell`でインストールしていますが、コマンドプロンプトからでもインストールできます。
   :::

2. メッセージの出力:
   ターミナルに、以下のメッセージが表示されます。

   ```powershell
   ダウンロード中: Debian GNU/Linux
   [==========================47.2%                           ]

   インストール中: Debian GNU/Linux
   [==========================47.2%                           ]

   ディストリビューションが正常にインストールされました。'wsl.exe -d Debian' を使用して起動できます
   ```

上記のメッセージが表示されれば、インストールは完了です。

### 3.4 ユーザーアカウントの作成

Debian を使用するために、Debian用のユーザーアカウント (`UNIXユーザーアカウント`) が必要です。
以下の手順で、ユーザーアカウントを作成します。

1. Debian の起動:
   以下のコマンドで、Debian を起動します。

   ```powershell
   wsl -d Debian
   ```

2. ユーザーアカウントの作成:
   Debian をはじめて起動した場合は、次のようなメッセージが表示されます。
   画面の指示に従ってください。

   ```powershell
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: <https://aka.ms/wslusers>
   Enter new UNIX username:
   ```

   ユーザー名を入力します。

   ```powershell
   Enter new UNIX username: <myUserAccount>
   ```

   :::message
   `<myUserAccount>` には、自分を特定する英数字のアカウントを入力します。
   Windows のアカウントと同じである必要はありません。わかりやすく、入力しやすい名前を設定しましょう。
   :::

3. パスワードの設定:
   続けて、パスワードを入力するプロンプトが表示されます。

   ユーザー名を設定するプロンプトが表示されます。
   `パスワード`を入力して、ユーザーアカウントを作成します。

   ```powershell
   New password:
   Retype new password:
   ```

   :::message alert
   パスワードは画面に表示されません。
   安全性を考慮し、Windows とは異なるパスワードを設定することが推奨されます。
   :::

以上で、ユーザーアカウントの作成は終了です。

## 4. `Windows Terminal`の設定

### 4.1 プロファイルに`Debian`を追加する

Debian のインストールに成功すると、`Windows Terminal`のプロファイルに Debian が追加されます。
`Windows Terminal`を再起動すると、以下のようにメニューに`Debian`が表示されます。
![シェルメニュー](/images/articles/wsl2-debian/ss-wt-shellmenu.png)
*シェル*

## 4. トラブルシューティング

### 4.1 代表的なトラブルと対処法

#### [WSL-001]: `WSL 2`に切り替えられない

- コマンド:
  `wsl --set-default-version 2`
- エラー:
  `WSL 2 requires an update to its kernel component. For information please visit https://aka.ms/wsl2kernel`
- 原因:
  `WSL 2`のカーネルが古い
- 対処法:
  `WSL`を最新のバージョンに更新

  ```powershell
  wsl --update
  ```

#### [WSL-002]: `WSL 2`に切り替えられない

- コマンド:
  `wsl --set-default-version 2`
- エラー:
  `Please enable the Virtual Machine Platform Windows feature and ensure that virtualization is enabled in the BIOS.`
- 原因:
  - `Windows`の機能で`Virtual Machine Platform`が無効
  - `BIOS`/`UEFI`で仮想化機能 (`Intel VT-x` または `AMD-V`) が無効
- 対処法:
  - `PowerShell`を管理者権限で開き、以下のコマンドを実行:

    ```powershell
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    ```

  - `BIOS`設定で、仮想化支援機能(`Intel VT-x` または、`AMD-V`) を有効化

#### [WSL-003]: `WSL`に Debian がインストールできない

- コマンド:
  `wsl --install Debian`
- エラー:
  `There is no distribution with the supplied name.`
- 原因:
  インストールしようとしたディストリビューションが存在しない、またはみつからない
- 対処法:
  - `wsl --list --online`:
    インストール可能なディストリビューションを確認する
  - `Microsoft Store`:
    `Microsoft Store`から対象の`Linux ディストリビューション`をインストール

#### [WSL-004]: `WSL 2`に切り替わらない

- コマンド:
  `wsl --status`
- エラー:
  `WSL default version remains as WSL 1`
- 原因:
  `wsl --set-default-version 2`が正しく適用されていない
- 対処法:
  1. `PowerShell`を管理者権限で開き、次のコマンドを実行:

     ```powershell
     wsl --set-default-version 2
     ```

#### [TERM-001]: `Windows Terminal`の[プロファイル]に`Debian`が存在しない

- コマンド:
  `Windows Terminal`のシェルメニュー
- エラー:
  シェルに`Debian`が表示されていない
- 原因:
  プロファイルに`Debian`の項目がない
- 対処法:
  - `Windows Terminal`のプロファイルに`Debian`を追加する：
    1. `settings.json`を開く。
      [設定]-[`JSON ファイルを開く`]で、`Windows Terminal`の設定ファイルをエディタで開く。

    2. `Debian`プロファイルを追加:
       `settings.json`内の`profiles`セクションにある`list`配列に Debian の項目を追加します。

       ```settings.json
       "profiles":
       {
          "list":
          [
          ]
       }
       ```

       下記、`Debian`の項目を追加。

       ```settings.json
       {
         "guid": "{<GUID>}",
         "hidden": false,
         "name": "Debian",
         "source": "Microsoft.WSL"
       }
       ```

       :::message
       Debian の`GUID`は、`New-GUID`で新しく作成する
       :::

    3. `Windows Terminal`を再起動

## おわりに

以上で、`Windows`上に `Debian` がインストールできました。
これにより、`AWS`やその他のクラウドサービスに近い Linux環境を Windows上で構築できるようになり、開発環境の幅が大きく広がります。
また、Linux ツールが利用できるという大きな利点により、各種開発やテストがよりスムーズに行なえるようになります。

今後は、インストールした Debian のカスタマイズ方法や、具体的な開発環境の構築手順についても詳しく解説していく予定です。
まずは、使いやすい Debian環境の構築に挑戦してみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`WSL` のインストール方法](https://learn.microsoft.com/ja-jp/windows/wsl/install):
  公式ドキュメントによる、`WSL`インストール方法のチュートリアル

- [`WSL` の基本的なコマンド](https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands):
  `wsl`コマンドが使用できる基本的なサブコマンドの紹介

- [GitHub からパッケージをダウンロードして WSL をセットアップする方法](/atsushifx/articles/wsl2-setup-from-github):
  `WSL`をセットアップする手順
