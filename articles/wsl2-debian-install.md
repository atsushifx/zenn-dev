---
title: "WSL2 に Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

Windows の `WSL2`に`Debian`をインストールするには、`Windows Terminal`で次のコマンドを実行します。

1. `wsl --set-default-version 2`を実行
2. `wsl --install -d Debian`を実行
3. `Windows Terminal` を再起動

これで`Debian を使用できます。

## はじめに

この記事では、WSL[^1] を使用して Debian をインストールする方法を紹介します。
WSL を利用することで、Windows上の Linux 環境を構築できます。

WSL2 を使うためには、`wsl`コマンドを使用して、WSL上に Linux をインストールする必要があります。
この記事では、Linux ディストリビューションの 1つである Debian をインストールします。

[^1]: WSL:  `Windows Subsystem for Linux`、Windows上で Linux の環境を実行するためのサブシステム

## 1. 既定バージョンの指定

WSL には WSL1 と WSL2[^2] があり、この記事では WSL2 の設定を紹介します。
WSL2 は完全な Linux カーネルを内包しているので、実際の Linux 環境に近い動作を実現します。

[^2]: WSL2: WSL の第2バージョン。完全な Linux カーネルを内包しているため、実際の Linux 環境に近い動作が実現される。

## 1.1. 既定バージョンを指定する

WSL2 を使うため、`wsl --set-default-version`コマンドで既定のバージョンを指定します。

1. `wsl --set-default-version`コマンドで、カーネルバージョンを指定する
   次のコマンドを実行します

   ```powershell
   wsl --set-default-version 2
   ```

   実行結果は、次のようになります

   ```PowerShell
   C: > wsl --set-default-version 2

   WSL 2 との主な違いについては、<https://aka.ms/wsl2>
   を参照してください
   この操作を正しく終了しました。

   C:  >
   ```

2. `wsl --status`で既定のバージョンを確認する
   次のコマンドを実行します

   ```powershell
   wsl --status
   ```

   実行結果は、次のようになります。

   ```powershell
   C: > wsl --status
   既定のディストリビューション: Debian
   既定のバージョン: 2

   C: >
   ```

このように表示されたら  `既定のバージョン: 2`、設定は成功しています。

## 2. Debianのインストール

WSL にコマンドラインで使える`wsl`コマンドがあります。
今回は、`wsl`コマンドを使って Debian[^3] をインストールします。

[^3]: Debian: オープンソースの Linux ディストリビューション

## 2.1. wslコマンドでDebianをインストールする

`wsl --install`コマンドを使用して Debian をインストールします。
次の手順で、Debian をインストールします。

1. `wsl --install`コマンドで Debian をインストールする
   次のコマンドを実行します

   ```powershell
   wsl --install -d Debian
   ```

   実行結果は、次のようになります

   ```powershell
   C: > wsl --install -d Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...

   ```

2. UNIX ユーザー[^4]を作成する
   以下のプロンプトが表示されるので、ユーザー名とパスワードを設定してユーザーを作成します

   ```powershell
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: <https://aka.ms/wslusers>
   Enter new UNIX username: <username>

   New password:
   Retype new password:

   ```

   **注意**:
   パスワードは画面に表示されません。また、安全性を考慮し、Windows とは異なるパスワードを設定することが推奨されます。

以上で、`Debian`のインストールは終了です。

[^4]:  UNIX ユーザー: UNIX/Linux のユーザーアカウント

## 3. Windows Terminalの設定

### 3.1 Windows Terminalを設定する

`Windows Terminal`[^5]のプロファイルには、Debian が自動的に登録されます。
`Windows Terminal`を一度閉じてから再度開くと、新しいシェルに`Debian`が追加されます。

[^5]: `Windows Terminal`: Windows 用の公式ターミナルエミュレーター

## おわりに

WSL2 を利用することで、Windows上で Linux の完全な環境を構築できます。

これにより、多くの Linux 用ツールやアプリ (例:Docker,  Git など) が利用できるようになり、開発の幅が広がります。
Linux の環境をしっかりと理解し、より高度な技術の習得を目指しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL を使用して Windows に Linux をインストールする方法 : <https://learn.microsoft.com/ja-jp/windows/wsl/install>
- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
