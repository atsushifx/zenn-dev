---
title: "Windows WSL2 に Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

`Windows WSL2`に`Debian`をインストールするには、`Windows Terminal`で次のコマンドを実行します。

1. `wsl --set-default-version 2`
2. `wsl --install -d Debian`
3. `Windows Terminal` を立ち上げなおす

これで`Windows Terminal`から`Debian`が使えるようになります。

## はじめに

この記事では、WSL (`Windows Subsystem for Linux`) を使用して Debian をインストールする方法を紹介します。
WSL を利用することで、Windows上に Linux 環境を構築できるようになりました。

WSL2 を使うためには、`wsl`コマンドを使用して、WSL上に Linux をインストールする必要があります。
この記事では、Linux ディストリビューションの 1つである Debian をインストールします。

## 1. 規定バージョンの指定

WSL には WSL1 と WSL2 の 2種類がありますが、この記事では WSL2 での設定方法を紹介します。

## 1.1. 既定バージョンを指定する

WSL2 を使うため、`wsl --set-default-version`規定のバージョンを指定します。

1. `wsl --set-default-version`コマンドで、カーネルバージョンを指定する

   ```powershell
   wsl --set-default-version 2
   ```

2. `wsl --status`で既定のバージョンを確認する

   ```powershell
   wsl --status
   ```

   実行結果は、次のようになります。

   ```powershell
   C: > wsl --status
   既定のバージョン: 2

   C: >
   ```

このように`既定のバージョン: 2`と出力されれば、設定は成功です。

## 2. Debianのインストール

WSL にコマンドラインで使える`wsl`コマンドがあります。
今回は、`wsl`コマンドを使って Debian をインストールします。

## 2.1. wslコマンドでDebianをインストールする

`wsl --install`コマンドを使い Debian をインストールします。
次の手順で、Debian をインストールします。

1. `wsl --install`コマンドで Debian をインストールする

   ```powershell
   wsl --install -d Debian
   ```

   実行結果は、次のようになります。

   ```powershell
   C: > wsl --install -d Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...

   ```

2. UNIX ユーザーを作成する
   UNIX ユーザー作成のプロンプトが表示されるので、ユーザー名とパスワードをお設定してユーザーを作成する

   ```powershell
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: <https://aka.ms/wslusers>
   Enter new UNIX username: atsushifx

   New paaaword:
   Retype new password:

   ```

以上で、`Debian`のインストールは終了です。
このとき、パスワードを入力しても画面に出力されなので注意してください。
また、セキュリティのために Windows 用のパスワードとは別のパスワードを使うべきです。

## 3. Windows Terminalの設定

`Windows Terminal`のプロファイルには、Debian が自動的に登録されます。
`Windows Terminal`を一度閉じ。再度開くと新しいシェルに`Debian`が追加さます。

## おわりに

この記事では、Windows WSL2 に Debian をインストールする方法について説明しました。
WSL2 を利用することで、Windows上に Linux 環境を作成できます。

これにより、多くの Linux 用ツールやアプリが利用できるようになり、開発の幅が広がります。
Linux の環境をしっかりと理解し、より高度な技術の習得を目指しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL を使用して Windows に Linux をインストールする方法 : <https://learn.microsoft.com/ja-jp/windows/wsl/install>
