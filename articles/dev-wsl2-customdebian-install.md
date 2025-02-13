---
title: "カスタマイズ可能なDebian環境: WSL 2 に カスタマイズ可能な Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

`Windows Terminal`で次のコマンドを実行し、`WSL`に`Debian`をインストールします。

:::message alert
`WSL 2`を利用するには、`Windows 11`の使用を推奨します
:::

1. `wsl --set-default-version 2`を実行
2. `wsl --install -d Debian`を実行
3. Windows Terminal を再起動すると、新しい`Debian`プロファイルが自動的に追加される

これで`Debian`を使用できます。

## はじめに

この記事では、`WSL`を使用して`Debian`をインストールする手順を紹介します。
`WSL 2`では、実際の `Linux カーネル` を使用するため、ネイティブ環境に近い動作を実現できます。

この記事では、`Linuxディストリビューション` の 1つである`Debian`をインストールします。

## 技術用語

- `WSL`:
  `Windows Subsystem for Linux`の略で、`Windows`上で`Linux`環境を動作させる機能。

- `Debian`:
  安定性とセキュリティが高い`Linuxディストリビューション`。

- `Windows Terminal`:
  Windows で利用できるモダンなターミナルアプリケーション。

- `wsl`:
  `WSL`の設定や、`Linuxディストリビューション`のインストールなどの操作を行なうコマンド。

- `Virtual Machine Platform`:
  Windows上で仮想化環境を提供する機能で、`WSL 2`の動作に必要な機能。

- `Microsoft Store`:
  Windows アプリケーションのオンラインストアで、各種アプリケーションのほかに`WSL`用の`Linuxディストリビューション`も配布。

## 1. `WSL`の概要

`WSL` は、Windows上で `Linux` 環境を提供する機能です。
専用の`Linuxサーバ`を用意せずに、Windows 上で Linux 環境を利用できます。

### 1.1 `WSL 2` を選ぶ理由

`WSL 2`は Windows の仮想化技術を活用し、`WSL 1`よりも高いパフォーマンスと互換性を提供します。
主なメリットは次のとおりです。

- **フル機能の`Linux カーネル`**:
  `Linux カーネル`搭載により、多数の`Linuxツール`が利用可能

- **コンテナ環境への対応**:
  `Docker`などのコンテナ環境に対応し、開発用途に最適

### 1.2 既定としてWSL 2を指定する

`WSL`を使うときには、`WSL 1`、`WSL 2`のどちらを使用するかを指定する必要があります。
`wsl --set-default-version 2`コマンドを用い、`WSL`のバージョンを`2`に指定します。

1. `wsl --set-default-version 2`コマンドで、`WSL 2`を指定する

   ```powershell
   wsl --set-default-version 2
   ```

   :::message
   `WSL 2`を既定のバージョンに設定します。
   :::

   実行すると、以下のような出力が表示されます

   ```powershell
   C: > wsl --set-default-version 2

   WSL 2 との主な違いについては、<https://aka.ms/wsl2>
   を参照してください
   この操作を正しく終了しました。

   C:  >
   ```

2. `wsl --status`で既定のバージョンを確認する
   次のコマンドで、既定のバージョンを確認します。

   ```powershell
   wsl --status
   ```

   実行すると、以下のような出力が表示されます

   ```powershell
   C: > wsl --status
   既定のディストリビューション: Debian
   既定のバージョン: 2

   C: >
   ```

`既定のバージョン: 2`と表示されていれば、設定は成功しています。

## 2. Debianのインストール

`WSL`の設定と`Debian`のインストールは、`wsl`コマンドを使用します。

## 2.1 wslコマンドでDebianをインストールする

`wsl --install`コマンドを使用し、次の手順で`Debian`をインストールします。

1. `wsl --install`コマンドで`Debian`をインストールする

   ```powershell
   wsl --install -d Debian
   ```

   実行すると、以下のような出力が表示されます。 (出力内容は環境によって異なることがあります)

   ```powershell
   C: > wsl --install -d Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...

   ```

### 2.2 `UNIXユーザー`の作成

`Debian`がインストールされると、プロンプトが表示されます。
プロンプトに従い、`UNIXユーザー`を作成します。

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

以上で、`Debian`のインストールは終了です。

## 3. `Windows Terminal`の設定

### 3.1 プロファイルに`Debian`を追加する

`Windows Terminal`のプロファイルには、`Debian`が自動的に登録されます。
`Windows Terminal`の再起動後は、プロファイルに`Debian`が追加されています。

![プロファイル](/images/articles/wsl2-debian/wt-shellmenu.png)

## 4. トラブルシューティング

### 4.1 代表的なトラブルと対処法

- `WSL 2` を既定バージョンに設定できない:
  - コマンド: `wsl --set-default-version 2`
  - エラー:
    `WSL 2 requires an update to its kernel component. For information please visit https://aka.ms/wsl2kernel`
    (WSL 2 ではカーネルの更新が必要なため、最新の状態にアップデートしてください)
  - 原因: `WSL 2`のカーネルが古い
  - 対処法: `WSL`を最新のバージョンに更新

    ```powershell
    wsl --update
    ```

  - 仮想化機能 (`Virtual Machine Platform`) が無効:
    - コマンド: `wsl --set-default-version 2`
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

  - `WSL`のディストリビューションが見つからない:
    - コマンド: `wsl --install Debian`
    - エラー: `There is no distribution with the supplied name.`
    - 原因: `WSL`にインストールされた`Linuxディストリビューション`がない
    - 対処法:
      - `Microsoft Store`から`Linuxディストリビューション`をインストール

    - 既定バージョンが`WSL 1`のままの場合:
      - コマンド: `wsl --status`
      - エラー: `WSL default version remains as WSL 1`
      - 原因: `wsl --set-default-version 2`が正しく適用されていない
      - 対処法:
        1. `PowerShell`を管理者権限で開き、次のコマンドを実行:

            ```powershell
            wsl --set-default-version 2
            ```

        2. `Windows`を再起動

## おわりに

以上で、`Windows`上に`Debian`がインストールできました。
これにより、`Windows`上の開発環境と比較して、`AWS`などのクラウド環境に近い開発環境が構築できます。
また、`Linuxツール`が動かせるのも大きな利点です。

次回からは、インストールした`Debian`をカスタマイズして、開発環境を構築する手順を紹介します。
カスタマイズした`Debian`をコピーすることで、勉強用を含む各種開発環境が簡単に構築できます。

まずは、使いやすい`Debian`環境を構築してみましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- <https://learn.microsoft.com/ja-jp/windows/wsl/install>:
  `WSL` を使用して`Windows`に`Linux`をインストールする方法。
- <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>:
  `WSL` の基本的なコマンド。
