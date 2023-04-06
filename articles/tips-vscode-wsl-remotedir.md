---
title: "Tips: VS Code: Visual Studio CodeでWSLのディレクトリを指定する"
emoji: "🍿"
type: "tech"
topics: ["tips", "WSL", "VSCode", "CLI", "remote" ]
published: true
---

## tl;dr

- "-remote"オプションを使えば、`WSL`上のディレクトリを指定できます

## はじめに

`WSL`から`Visual Studio Code`を使うと、`Windows`側のパスでファイルやディレクトリを開きます。
たとえば、`/home/atsushifx`下で`code .`としてディレクトリを開くと、"\\wsl.localhost\codings\home\atsushifx"のようなネットワークパスでディレクトリを開きます。

`WSL`側のパスで開くには、`--remote`オプションを使う必要があります。

## オプション付きでVS Codeを起動する

### --remote オプションとは

`Visual Studio Code`には、`WSL`や`Linux`サーバなどのファイルをリモートで編集するリモート編集機能があります。
このとき、リモート側のファイルを見るためにリモートエクスプローラーを使用します。

`--remote`オプションを指定すると、リモートエクスプロラー経由でファイルやディレクトリを見るようになります。

### wsl上のサーバを指定する

通常、`--remote`オプションではリモートのサーバ名を指定します。`WSL`上では、`WSL+`を前につけてディストリビューションを指定します。
たとえば、`code --remote wsl+Debian .`のような感じです。

### 起動用スクリプトを作成する

上記の`--remote`オプションは毎回使用するので、起動スクリプトに組み込みます。WSL 側の起動スクリプトは、次の通りです。

``` code : shell script
/mnt/c/app/develop/ide/VSCode/bin/code --remote wsl+coding $*

```

以後、コマンドラインで`code .`と入力すれば、上記スクリプトが起動します。

## さいごに

このオプションを知る前は、`Visual Studio Code`を立ち上げた後にいちいちフォルダをリモート側で開く必要がありました。
今回はオプションの指定をスクリプトで自動的に指定しているので、サクッとプログラミングに集中できます。

それでは、Happy Hacking!

## 参考資料

- [Developing in WSL](https://code.visualstudio.com/docs/remote/wsl)
