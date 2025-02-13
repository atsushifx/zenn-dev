---
title: "カスタマイズ可能なDebian環境: WSL 2 に Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

`Windows Terminal`で以下のコマンドを実行すると、`WSL`に`Debian`をインストールします。

:::message alert
`WSL 2`を利用する場合は、`Windows 11`の使用を推奨します。
:::

1. `wsl --set-default-version 2`を実行
2. `wsl --install -d Debian`を実行
3. `Windows Terminal`を再起動すると、新しい`Debian`プロファイルが自動的に追加される

以上で、`Debian`のセットアップが完了します。

## はじめに

この記事では、`WSL`を使用して`Debian`をインストールする手順を紹介します。
`WSL 2` では、実際の `Linux カーネル`を使用するため、ネイティブに近い動作が可能です。

この記事では、`Linux ディストリビューション` の 1つである`Debian`をインストールします。

## 技術用語

- `WSL`:
  `Windows Subsystem for Linux`の略で、`Windows`上で`Linux`環境を動作させる機能。

- `Debian`:
  安定性とセキュリティに優れた`Linux ディストリビューション`。

- `Windows Terminal`:
  Windows で利用できるモダンなターミナルアプリケーション。

- `wsl`:
  `WSL`の設定や、`Linux ディストリビューション`のインストールなどの操作を行なうコマンド。

- `Virtual Machine Platform`:
  Windows上で仮想化環境を提供する機能で、`WSL 2`の動作に必要な機能。

- `Microsoft Store`:
  Windows アプリケーションのオンラインストアで、各種アプリケーションのほかに`WSL`用の`Linux ディストリビューション`も配布。

## 1. `WSL`の概要

`WSL`は、`Linux` 環境を Windows 上に構築するための機能です。
`WSL`を使用することで、`AWS`や`GCP`などのクラウド環境に近い開発環境を構築できます。

### 1.1 `WSL 2` を選ぶ理由

`WSL 2`は Windows の仮想化技術を活用し、`WSL 1`よりも高いパフォーマンスと互換性を提供します。
主なメリットは次の通りです。

- **完全な`Linux カーネル`**:
  `Linux カーネル`搭載により、多数の`Linuxツール`が利用可能

- **コンテナ環境への対応**:
  `Docker`などのコンテナ環境に対応し、開発用途に最適

### 1.2 `WSL 2`をデフォルトバージョンに設定

`WSL`のデフォルトバージョンを`WSL 2`に変更するには、次のコマンドを実行します。

1. `wsl --set-default-version 2`コマンドで、`WSL 2`を指定する

   ```powershell
   wsl --set-default-version 2
   ```

   :::message
   `WSL 2`を既定のバージョンに設定します。
   :::

   実行すると、以下のような出力が表示されます。

   ```powershell
   C: /wsl > wsl --set-default-version 2

   WSL 2 との主な違いについては、<https://aka.ms/wsl2>
   を参照してください
   この操作を正しく終了しました。

   C: /wsl >
   ```

2. `wsl --status`でデフォルトバージョンを確認する
   次のコマンドで、デフォルトバージョンを確認します。

   ```powershell
   wsl --status
   ```

   実行すると、以下のような出力が表示されます。

   ```powershell
   C: /wsl > wsl --status
   既定のディストリビューション: Debian
   既定のバージョン: 2

   C: /wsl >
   ```

`既定のバージョン: 2`と表示されていれば、設定は成功しています。

## 2. Debianのインストール

`WSL`の設定と`Debian`のインストールは、`wsl`コマンドを使用します。

## 2.1 wslコマンドでDebianをインストールする

`wsl --install`コマンドを使用し、次の手順で`Debian`をインストールします。

1. `wsl --install`コマンドで`Debian`をインストールする

   ```powershell
   wsl --install Debian
   ```

   実行すると、以下のような出力が表示されます (出力内容は環境によって異なることがあります)。

   ```powershell
   C: /wsl > wsl --install Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...

   ```

### 2.2 `UNIXユーザー`の作成

`Debian`の初回起動時に、ユーザー名とパスワードの入力を求められます。
ここで設定した`UNIX ユーザー`は `Debian` 環境でのデフォルトユーザーとなります。

`Debian`初回起動時に表示されるプロンプトに従い、`UNIXユーザー`を作成します。

1. `UNIXユーザー`を作成する
   ユーザー名を設定するプロンプトが表示されます。
   `ユーザー名`、`パスワード`を設定して、`UNIXユーザー`を作成します。

   ```powershell
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: <https://aka.ms/wslusers>
   Enter new UNIX username: poweruser

   New password:
   Retype new password:

   ```

   :::message alert
   パスワードは画面に表示されません。
   安全性を考慮し、Windows とは異なるパスワードを設定することが推奨されます。
   :::

以上で、`UNIXユーザー`の作成は終了です。

## 3. `Windows Terminal`の設定

### 3.1 プロファイルに`Debian`を追加する

通常、`Windows Terminal`のプロファイルには、`Debian`が自動で登録されます。
ただし、登録されない場合は手動でプロファイルを追加できます。
`Windows Terminal`の再起動後は、以下の画像のようにプロファイルに`Debian`が追加されています。

![プロファイル](/images/articles/wsl2-debian/wt-shellmenu.png)
*プロファイル*

## 4. トラブルシューティング

### 4.1 代表的なトラブルと対処法

<!-- textlint-disable ja-technical-writing/sentence-length -->
- エラー: `WSL 2 requires an update to its kernel component. For information please visit https://aka.ms/wsl2kernel`
  <!-- textlint-enable -->
  - コマンド: `wsl --set-default-version 2`
  - 原因: `WSL 2`のカーネルが古い
  - 対処法: `WSL`を最新のバージョンに更新

    ```powershell
    wsl --update
    ```
<!-- textlint-disable ja-technical-writing/sentence-length -->
- エラー: `Please enable the Virtual Machine Platform Windows feature and ensure that virtualization is enabled in the BIOS.`
  <!-- textlint-enable -->
  - コマンド: `wsl --set-default-version 2`
  - 原因:
    - `Windows`の機能で`Virtual Machine Platform`が無効
    - `BIOS`/`UEFI`で仮想化機能 (`Intel VT-x` または `AMD-V`) が無効
    - 対処法:
      - `PowerShell`を管理者権限で開き、以下のコマンドを実行:

        ```powershell
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        ```

      - `BIOS`設定で、仮想化支援機能(`Intel VT-x` または、`AMD-V`) を有効化

- エラー: `There is no distribution with the supplied name.`
  - コマンド: `wsl --install Debian`
  - 原因: `WSL`にインストールされた`Linuxディストリビューション`がない
  - 対処法:
    - `Microsoft Store`から`Linux ディストリビューション`をインストール

- エラー: `WSL default version remains as WSL 1`
  - コマンド: `wsl --status`
  - 原因: `wsl --set-default-version 2`が正しく適用されていない
  - 対処法:
    1. `PowerShell`を管理者権限で開き、次のコマンドを実行:

       ```powershell
       wsl --set-default-version 2
       ```

    2. `Windows`を再起動

## おわりに

以上で、`Windows`上に `Debian` がインストールできました。
これにより、`AWS` や他のクラウドサービスの Linux 環境に近い開発環境を Windows上に構築できます。
また、`Linux ツール`が利用できるのも大きな利点です。

次からは、インストールした `Debian` をカスタマイズし、開発環境を構築する手順を紹介します。
カスタマイズした `Debian` をコピーすることで、勉強用を含む各種開発環境が簡単に構築できます。

まずは、使いやすい `Debian` 環境を構築してみましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `WSL` のインストール方法
  <https://learn.microsoft.com/ja-jp/windows/wsl/install>:

- `WSL` の基本コマンド。
  <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>:
