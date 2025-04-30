---
title: "WSL 2の初期設定: Debianのインストールと初期設定ガイド (2025年版)"
emoji: "🔠"
type: "tech"
topics: ["WSL", "Linux", "Debian", "インストール"]
published: true
---

## tl;dr

Windows Terminal 上で、以下のコマンドを実行して、`Debian` をインストール・セットアップします。

:::message alert
`Windows 11`を推奨します。
`Windows 10`では一部の機能に制限があります (カーネルを`wsl --update`で更新できない)。
:::

1. `WSL`の既定のバージョンを 2 に設定

   ```powershell
   wsl --set-default-version 2
   ```

2. `Debian`をインストール

   ```powershell
   wsl --install -d Debian
   ```

3. ユーザーアカウントを作成

   ```powershell
   wsl -d Debian
   ```

4. `Windows Terminal`を再起動

以上で、`Windows Terminal` に `Debian` のプロファイルが自動追加され、メニューから選択して起動できます。

Enjoy!

## はじめに

atsushifx です。
この記事では、`WSL 2`環境に `Debian` をインストールし、Linux コマンドラインを快適に利用する方法を解説します。
また、インストール時のトラブルシューティングについても紹介します。

`WSL 2`を利用すると、Windows上でコンテナ開発や Linux ネイティブな開発環境を構築できます。

## 用語集
<!-- textlint-disable ja-technical-writing/sentence-length -->
- `WSL 1` (`Windows Subsystem for Linux 1`):
  Linux システムコールを Windows システムコールへ変換する方法で、`NTFS` ファイルシステム上で Linux のバイナリを実
  行する技術

- `WSL 2` (`Windows Subsystem for Linux 2`):
  Windows上で Linux環境を実現するための仮想化技術

- `Debian`:
  安定性とセキュリティを重視した Linuxディストリビューション

- `Windows Terminal`:
  Windows 向けの複数のシェル環境に対応した、モダンなターミナルエミュレータ

- `PowerShell`:
  Windows上で利用されるコマンドラインシェルおよびスクリプト環境

- `GUID`:
  Windows 内部でオブジェクトを一意に識別する識別子

- `dism.exe`:
  Windows のシステムイメージを管理するコマンドラインツール

- `BIOS` / `UEFI`:
  PC の起動を管理するファームウェア (`BIOS`はレガシー形式、`UEFI`はその後継規格で、より高度な機能を提供)
<!-- textlint-enable -->

## 1. 前提条件

`WSL`を使用するには、以下の条件が必要です。

1. **仮想化支援機能の有効化**:
   (`Intel VT-x` または `AMD-V`)が`BIOS`/`UEFI`の設定で有効になっていること。

2. **Windowsのバージョン**:
   `Windows 11` を推奨。
   `Windows 10` では一部の機能に制限あり (`wsl -update`が使用できない)

3. **`WSL` および `Virtual Machine Platform` の有効化**:
   `WSL`, `Virtual Machine Platform`および`Hyper-V`の各機能が Windows上で有効になっていること。
   (通常、"Virtualization Technology" というオプション名で記載される)

上記の設定については、[GitHub からパッケージをダウンロードして WSL をセットアップする方法](wsl2-setup-from-github) を参考にしてください。

そのほか、インストール操作で、

1. `Windows Terminal`

2. `PowerShell` (`Windows PowerShell` ではなく)

を使用しています。

:::message
この記事では`PowerShell`を使用していますが、`コマンドプロンプト`でもインストールできます。
:::

## 2. `WSL 2`とは

### 2.1 `WSL 2` の概要

`WSL 2`は、Microsoft がカスタマイズした `Linux`カーネルを使用し、仮想環境を作成します。
`WSL 2`は、`WSL 1`と異なり、完全な Linux カーネルを利用し、ファイルシステムのパフォーマンスが向上しています。そのため、開発用途に適した環境を提供します。

### 2.2 `WSL 2` を選ぶ理由

`WSL 2`は、`Linuxカーネル`をネイティブに使用し、`WSL 1`よりも高速で高い互換性を提供します。
特に、`Docker` などのコンテナ技術や最新の `Linux` ツールの利用に適しています。
また、Windows のファイルシステムと統合され、エディタや `IDE` との連携も容易です。

## 3. `Debian`のインストール、セットアップ

`WSL 2`に`Debian`をインストールする手順を解説します。
`Windows Terminal`上でコマンドを実行して、`Debian`をインストールします。

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

### 3.2 インストール先を`WSL 2`にする

`Debian`を`WSL 2`環境にインストールするため、`WSL`の既定バージョンを`WSL 2`に設定します。
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

現在の `WSL` のバージョン (既定のバージョン) を、次の手順で確認できます。

1. 既定のバージョンを確認する:

   ```powershell
   wsl --status
   ```

2. メッセージが表示される:

   ```powershell
   既定のバージョン: 2
   ```

上記のように、`既定のバージョン`が 2 であれば、`WSL 2`にインストールされます。

## 3.3 `Debian`のインストール手順

以下の手順で、`WSL 2` に`Debian`をインストールします。

1. `Debian`をインストールする:
   以下のコマンドを実行し、`Debian`をインストールします。

   ```powershell
   wsl --install -d Debian
   ```

2. メッセージの出力:
   以下のメッセージがターミナルに表示されます。

   ```powershell
   ダウンロード中: Debian GNU/Linux
   [==========================47.2%                           ]

   インストール中: Debian GNU/Linux
   [==========================47.2%                           ]

   ディストリビューションが正常にインストールされました。'wsl.exe -d Debian' を使用して起動できます
   ```

上記のメッセージが表示されれば、インストールは完了です。

### 3.4 ユーザーアカウントの作成

`Debian`上でファイル操作やソフトウェア管理をするため、`UNIX`ユーザーアカウントを作成する必要があります。
以下の手順で、ユーザーアカウントを作成します。

1. `Debian`の起動:
   以下のコマンドで、`Debian`を起動します。

   ```powershell
   wsl -d Debian
   ```

2. ユーザーアカウントの作成:
   `Debian`をはじめて起動した場合は、次のようなメッセージが表示されます。
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
   `Windows` のアカウントと同じである必要はありません。わかりやすく、入力しやすい名前を設定しましょう。
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
   安全性を考慮し、`Windows` とは異なるパスワードを設定することが推奨されます。
   :::

以上で、ユーザーアカウントの作成は終了です。

## 4. `Windows Terminal`の設定

### 4.1 プロファイルに`Debian`を追加する

`Debian`のインストールに成功すると、`Windows Terminal`のプロファイルに`Debian`が追加されます。
`Windows Terminal`を再起動すると、以下のようにメニューに`Debian`が表示されます。
![シェルメニュー](/images/articles/wsl2-debian/ss-wt-shellmenu.png)
*シェル*

## 5. トラブルシューティング

### 5.1 代表的なトラブルと対処法

#### [WSL-001]: `WSL 2`に切り替えられない (`WSL 2 required`)

- コマンド:
  `wsl --set-default-version 2`
- エラーメッセージ: <!-- textlint-disable ja-technical-writing/sentence-length -->
  "WSL 2 requires an update to its kernel component. For information please visit <https://aka.ms/wsl2kernel>"
  <!-- textlint-enable -->
- 日本語訳:
  `WSL 2` のカーネルコンポーネントが古いため、更新が必要です。詳細は <https://aka.ms/wsl2kernel> を参照してください。
- 原因:
  `WSL 2`のカーネルが古い
- 対処法:
  `WSL` のカーネルを最新のバージョンに更新し、PC を再起動

  ```powershell
  wsl --update
  shutdown /r /t 0
  ```

#### [WSL-002]: `WSL 2`に切り替えられない (`Please enable the Virtual Machine`)

<!-- textlint-disable ja-technical-writing/sentence-length -->
- コマンド:
  `wsl --set-default-version 2`
- エラーメッセージ:
  "Please enable the Virtual Machine Platform Windows feature and ensure that virtualization is
  enabled in the BIOS."
- 日本語訳:
  `Virtual Machine Platform` 機能、および`BIOS`の仮想化支援機能が有効になっていることを確認してください
- 原因:
  - `Windows`の`Virtual Machine Platform`機能が無効化されている
  - `BIOS`または`UEFI`で仮想化支援機能 (`Intel VT-x` または `AMD-V`) が無効になっている
- 対処法:
  - `PowerShell`を管理者権限で開いて、以下のコマンドを実行後、PC を再起動:

    ```powershell
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    shutdown /r /t 0
    ```

  - `BIOS`設定で、仮想化支援機能(`Intel VT-x` または、`AMD-V`) を有効化
<!-- textlint-enable -->

#### [WSL-003]: `WSL`に `Debian` がインストールできない

- コマンド:
  `wsl --install -d Debian`
- エラーメッセージ:
  "There is no distribution with the supplied name."
- 日本語訳:
  指定した名前のディストリビューションが存在しません。
- 原因:
  インストールしようとしたディストリビューションが存在しない、またはみつからない
- 対処法:
  - `wsl --list --online`:
    インストール可能なディストリビューションを確認する
  - `Microsoft Store`:
    `Microsoft Store`から対象の`Linux ディストリビューション`をインストール

#### [WSL-004]: `WSL 2`に切り替わらない (`WSL default version`)

- コマンド:
  `wsl --status`
- エラーメッセージ:
  "WSL default version remains as WSL 1"
- 日本語訳:
  `WSL`の既定のバージョンが、 1 のままです。
- 原因:
  `wsl --set-default-version 2`が正しく適用されていない
  (`WSL` を完全に終了していない可能性がある)
- 対処法:
  - `PowerShell`を管理者権限で開き、次のコマンドを実行後、`WSL`を再起動

     ```powershell
     wsl --set-default-version 2
     wsl --shutdown
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
    1. `settings.json`を開く:
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
`Linux`ツールが利用できるという大きな利点により、各種開発やテストがよりスムーズになります。

今後は、`Debian` のカスタマイズ方法や具体的な開発環境の構築手順について解説する予定です。
まずは、使いやすい`Debian`環境の構築に挑戦してみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`WSL` のインストール方法](https://learn.microsoft.com/ja-jp/windows/wsl/install) -
  公式ドキュメントによる、`WSL`インストール方法のチュートリアル

- [`WSL` の基本的なコマンド](https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands) -
  `wsl`コマンドが使用できる基本的なサブコマンドの紹介

- [`GitHub`からパッケージをダウンロードして`WSL`をセットアップする方法](/atsushifx/articles/wsl2-setup-from-github) -
  `WSL`をセットアップする手順
