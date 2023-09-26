---
title: "WindowsにWSL環境を構築する方法"
emoji: "🔧"
type: "tech"
topics: ["Windows", "Linux", "WSL", "環境構築", ]
published: false
---

## tl;dr

WSL[^1] 環境は、`wsl --install`[^2]コマンドを使って構築できます。

1. `Windows Terminal`を起動
2. `wsl --install`コマンドを実行
3. PC の再起動

以上の手順で、WSL 環境を構築できます。

[^1]: WSL: Windows上で Linux 環境を構築するためのサブシステム
[^2]: `wsl --install`: Windows で WSL 環境を構築するコマンド

## はじめに

この記事では、Windows上で Linux 環境を構築するための方法を紹介します。WSL を使用することで、Windows マシン上で Linux を実行し、開発やテストに便利な環境を手に入れることができます。

WSL は、Windows の仮想化技術[^3]を活用し、Linux ディストリビューション[^4]を実行するための強力なサブシステムです。

[^3]: 仮想化技術: OS上で仮想的な PC を作成する技術
[^4]: Linux ディストリビューション: Linux カーネルとシェルなどのソフトウェアを組み合わせて、単体で OS として動かせるパッケージ

## 1. WSLとは

### 1.1 WSLの概要

WSL は、Windows の仮想化技術を用いた Linux システムの互換レイヤーであり、親環境である Windows とのシームレスな動作が特徴です。
最新バージョンの WSL2 は Linux カーネルを含んでおり、より実際の Linux に近い動作をします。

## 2. WSL環境の構築

WSL 環境は、`Windows Terminal`[^5]上のコマンドで簡単に構築できます。

[^5]: `Windows Terminal`: Windows 公式ターミナルエミュレーター

### 2.1. WSLをインストールする

次の手順で、`WSL`をインストールします。

1. `Windows Terminal`の起動
   管理者権限で、`Windows Terminal`を起動します

   ![Windows Terminal:起動画面](https://i.imgur.com/vyQ1TKv.jpg)
   *Windows Terminalを管理者権限での起動画面*

2. WSL のインストール
   以下のコマンドを実行して、WSL をインストールします

   ```powershell
   wsl --install
   ```

   ![Windows Terminal](https://i.imgur.com/aQov7it.jpg)
   *WSLのインストール画面*

3. WSL のインストール途中
   WSL の各モジュールがインストールされます

   ![Windows Terminal](https://i.imgur.com/q708dPC.jpg)
   *WSLの各モジュールのインストール*

4. PC の再起動
   Windows の仮想化機能[^3]を有効にするため、`Windows`を再起動します

以上で、`WSL` のインストールは終了です。

実際に Linux を使用するには、適当な Linux ディストリビューション[^4]をインストールする必要があります。

## おわりに

この記事では、Windows に WSL2 環境を構築する手順を説明しました。
WSL を活用することで、Windows と Linux のシームレスな連携が可能になり、開発、テスト、デバッグの効率が向上します。

また、WSL は Linux のパワーを Windows ユーザーに提供するための優れたツールであり、多くの開発者やエンジニアにとって価値のあるものとなっています。今後のプロジェクトやタスクで WSL を有効活用し、より効率的に作業を進めてください。

WSL を活用するためには、WSL を使って Linux ディストリビューションをインストールする必要があります。
また、参考資料を参照して`wsl`コマンドの詳細を知るのもよい方法です。

これらを通して、Linux 環境に慣れることでプログラマーとしてよりスキルアップするでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [WSL2 に Debian をインストールする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-install)
- [WSL を使用して Windows に Linux をインストールする方法](https://learn.microsoft.com/ja-jp/windows/wsl/install)
- [WSL の基本的なコマンド](https://learn.Microsoft.com/ja-jp/windows/wsl/basic-commands)
- [以前のバージョンの WSL の手動インストール手順](https://learn.microsoft.com/ja-jp/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
