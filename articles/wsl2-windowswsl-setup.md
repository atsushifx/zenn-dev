---
title: "WindowsにWSL2環境を構築する"
emoji: "🔧"
type: "tech"
topics: ["Windows", "Linux", "wsl", "環境構築", ]
published: false
---

## tl;dr

WSL[^1] 環境は、`wsl --install`[^2]コマンドで簡単に構築できます。

1. `Windows Terminal`を起動
2. `wsl --install`コマンドを実行
3. PC の再起動

以上の手順で、WSL 環境を構築できます。

[^1]: WSL: Windows上で Linux 環境を構築するためのサブシステム
[^2]: `wsl --install`: Windows で WSL 環境を構築するコマンド

## はじめに

この記事では、Windows上で Linux 環境を構築するための方法を紹介します。WSL (`Windows Subsystem for Linux') を使用することで、Windows マシン上で Linux を実行し、開発やテストに便利な環境を手に入れることができます。

WSL は、Windows の仮想化技術を活用し、Linux ディストリビューションを実行するための強力なサブシステムです。
この記事では、WSL の最新バージョンである WSL2 をインストールする方法について説明します。

## 1. WSLとは

### 1.1 WSLの概要

WSL2 は、Windows の仮想化技術を用いた Linux システムの互換レイヤーであり、親環境である Windows とのシームレスな動作が特徴です。
WSL2 は Linux カーネルを含んでおり、より実際の Linux に近い動作をします。

## 2. WSL2環境の構築

WSL2 環境は、`Windows Terminal`[^3]上のコマンドで簡単に構築できます。

[^3]: `Windows Terminal`: Windows 公式ターミナルエミュレーター

### 2.1. WSLをインストールする

次の手順で、`WSL`をインストールします。

1. `Windows Terminal`の起動
   管理者権限で、``Windows Terminal``を起動します

   ![Windows Terminal:起動画面](https://i.imgur.com/vyQ1TKv.jpg)
   *起動画面*

2. WSL のインストール
   `wsl --install`コマンドを実行し、WSL をインストールします

   ![Windows Terminal](https://i.imgur.com/aQov7it.jpg)
   *`wsl --install`コマンド*

3. WSL のインストール途中
   WSL の各モジュールがインストールされます

   ![Windows Terminal](https://i.imgur.com/q708dPC.jpg)
   *WSLのインストール中*

4. PC の再起動
   Windows の仮想化機能を有効にするため、`Windows`を再起動します

以上で、`WSL` のインストールは終了です。

### 2.2. Ubuntu をインストールする

`WSL`を実際に使用するためには、対応している Linux ディストリビューション[^4] をインストールする必要があります。
この記事では、例として Ubuntu[^5] をインストールします。

次の手順で、Ubuntu をインストールします。

1. Ubuntu のインストール
   `wsl --install -d Ubuntu`を実行して、Ubuntu をインストールします

   ```powershell
   C: > wsl --install -d Ubuntu
   インストール中: Ubuntu

   Ubuntu がインストールされました。
   Ubuntu を起動しています...
   Installing, this may take a few minutes...]

   ```

2. Ubuntu の起動
   Ubuntu のインストールに成功すると、Ubuntu が起動します

   ![Ubuntuコンソール](https://i.imgur.com/65zxdFT.jpg)
   *Ubuntuコンソール*

3. UNIX ユーザーの作成
   画面のメッセージに従い、ユーザーを作成します

   ![Welcome to Ubuntu](https://i.imgur.com/AOQE334.jpg)
   *UNIXユーザー作成*

4. コンソールの確認
   `Windows Terminal`を再起動して、プロファイルに`Ubuntu`が追加されていることを確認します。

   ![Windows Terminal - Ubuntu](https://i.imgur.com/zadrX7o.jpg)
   *Ubuntu追加*

以上で、WSL のインストールは終了です。

[^4]: Linux ディストリビューション: Linux カーネルとその他のソフトウェアで構成された OS パッケージ
[^5]: Ubuntu:WSL2上で実行できる Linux ディストリビューションの 1つ

## おわりに

この記事を読むことで、Windows マシン上で WSL2 環境を構築し、Linux の恩恵を享受するための手順を理解しました。WSL2 を活用することで、Windows と Linux のシームレスな連携が可能になり、開発、テスト、デバッグの効率が向上します。

また、WSL2 は Linux のパワーを Windows ユーザーに提供するための優れたツールであり、多くの開発者やエンジニアにとって価値のあるものとなっています。今後のプロジェクトやタスクで WSL2 を有効活用し、より効率的に作業を進めてください。

この記事では。WSL2 環境を構築するための手順をご紹介しました。
`wsl`コマンドの使い方や実際に Linux をインストールする方法は参考資料をご覧ください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [WSL を使用して Windows に Linux をインストールする方法](https://learn.microsoft.com/ja-jp/windows/wsl/install)
- [WSL の基本的なコマンド](https://learn.Microsoft.com/ja-jp/windows/wsl/basic-commands)
- [以前のバージョンの WSL の手動インストール手順](https://learn.microsoft.com/ja-jp/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
