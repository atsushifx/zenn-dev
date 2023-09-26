---
title: "WindowsにWSLをセットアップする手順"
emoji: "🔧"
type: "tech"
topics: ["Windows", "Linux", "WSL", "環境構築", ]
published: false
---

## tl;dr

WSL[^1]は、Windows上で Linux を動かせるツールで、`wsl --install`[^2]コマンドを使って簡単にセットアップできます。

1. `Windows Terminal`を起動
2. `wsl --install`コマンドを実行
3. PC の再起動

以上の手順で、WSL 環境を構築できます。

[^1]: WSL: Windows上で Linux 環境を構築するためのサブシステム
[^2]: `wsl --install`: Windows で WSL 環境を構築するコマンド

## はじめに

WSL は、インストール直後の Windows ではデフォルトで有効になっていません。
また、その基盤となる仮想化機能も同様です。
この記事では、これらを簡単にセットアップする方法を紹介します。

WSL をセットアップすることで、Windows上で Linux のツールやアプリケーションをシームレスに利用でき、開発やデバッグの効率が高まります。

## 1. WSLとは

WSL は、`Windows Subsystem for Linux`の略で 、Windows上で Linux を動かすサブシステムです。

### 1.1 WSLの概要

WSL は、Windows の仮想化技術[^3]を用いた Linux システムの互換レイヤーであり、親環境である Windows とのシームレスな動作が特徴です。
最新バージョンの WSL2 は Linux カーネルを含んでいます。このため、以前のバージョンと比べて互換性が向上しています。

WSL を使うと、Windows で Linux のネイティブアプリケーションが実行できます。
これにより、開発、テスト、デバッグの効率が向上します。
とくに Linux 特有のツールやコマンドを使用する際に、迅速にアクセスできるのが大きな利点です。

[^3]: 仮想化技術: OS上で仮想的な PC を作成する技術

### 1.2. WSL2 の特徴

WSL は、2023年現在、最新バージョンとして WSL2 が提供されています。

WSL2 は、WSL1 と比較して多くの改善点があります。
もっとも重要な点として、WSL2 は完全な Linux カーネルを内蔵しており、これにより互換性が大幅に向上しています。
そのため、実際の Linux 環境と同等の性能を Windows上で得ることができます。

## 2. WSL環境の構築

WSL 環境は、`Windows Terminal`[^4]上のコマンドで簡単に構築できます。

[^4]: `Windows Terminal`: Windows 公式ターミナルエミュレーター

### 2.1. WSLをインストールする

以下の手順で、WSL をインストールします。

1. **`Windows Terminal`の起動**
   管理者権限で、`Windows Terminal`を起動します

    ```スタートメニュー
   wt
   ```

   ![Windows Terminal:起動画面](https://i.imgur.com/vyQ1TKv.jpg)
   *`Windows Terminal`の起動画面*

2. **WSL のインストール**
   `wsl --install`コマンドを実行して、WSL をインストールします
   このコマンドは、WSL のセットアップに必要なコンポーネントをダウンロードし、インストールします

   ```powershell
   wsl --install
   ```

   ![Windows Terminal](https://i.imgur.com/aQov7it.jpg)
   *WSLのインストール画面*

3. **PC の再起動**
   Windows の仮想化機能を有効にするため、`Windows`を再起動します

以上で、`WSL` のインストールは完了です。

インストールが完了したら、Microsoft Store からお好きな Linux ディストリビューション [^5] (例: Ubuntu, Debian など) を選択してインストールします。
その後は、`Windows Terminal`でインストールした Linux ディストリビューションが起動できます。

[^5]: Linux ディストリビューション: Linux カーネルと上層のソフトウェアを組み合わせた OS のパッケージ

## おわりに

この記事では、Windows に WSL2 環境を構築する手順を詳しく説明しました。
WSL を活用することで、Windows と Linux のシームレスな連携が可能になり、開発、テスト、デバッグの効率が向上します。

そのためには、WSL に Linux をインストールして、必要なツールやアプリケーションのセットアップを行なう必要があります。

Linux はオープンソースのコミュニティの支えにより、日々発展しています。
Linux 上のさまざまなプログラミング環境やツールに触れることで、スキルの幅を広げることができます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [WSL を使用して Windows に Linux をインストールする方法](https://learn.microsoft.com/ja-jp/windows/wsl/install)
- [WSL の基本的なコマンド](https://learn.Microsoft.com/ja-jp/windows/wsl/basic-commands)
- [以前のバージョンの WSL の手動インストール手順](https://learn.microsoft.com/ja-jp/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
