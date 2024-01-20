---
title: "WSL開発環境: 環境構築の記事まとめ"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "開発環境", "環境構築", ]
published: true
---

## はじめに

WSL (Windows Subsystem for Linux) は、Windows上で Linux を実行するシステムです。
WSL を使うことで、Windows上で Linux を使ったシステム開発が行えます。

この記事では、Windows に WSL をセットアップし、開発環境を構築する方法を紹介します。
記事の手順にしたがうことで、どの Windows でも同じ WSL開発環境を構築できます。

実際のソフトウェア開発には、開発言語や各種ツールをインストールする必要があります。
これらも`XDG Base Directory`下に設定ファイルを作成するように設定できます。

## キーワード

- **WSL (Windows Subsystem for Linux)**:
  Windows で Linux のコマンドやアプリケーションを使用できるようにするためのシステム

- **`XDG Base Directory`**:
  アプリケーションの設定ファイルやキャッシュファイルを管理するためのディレクトリ標準

- **Debian**:
  信頼性と安定性に重点を置いた Linux ディストリビューション

- **apt (Advanced Package Tool)** :
  Debian系Linux ディストリビューション用のパッケージ管理ツール

- **`/etc/wsl.conf`**:
  WSL の動作を定義する設定ファイル

- **`dotfiles`**:
  ユーザーの設定ファイルを管理するためのリポジトリ

- **`whatdoc`**:
  `what`コマンドの文書化に使用される、規定されたフォーマットのコメント

## WSL開発環境構築の手順

以下に WSL で開発環境を構築する記事をまとめました。
各記事の手順にしたがえば、開発環境を構築できます。

1. [WindowsにWSLをセットアップする手順](https://zenn.dev/atsushifx/articles/wsl2-windowswsl-setup)
   Windows で WSL を有効化し、 Linux の基本環境を使用できるようになります。

2. [WSL に Debian をインストールする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-install)
   `wsl`コマンドを使って、`WSL`上に Debian をインストールします。

3. [作業用ディレクトリの作成](https://zenn.dev/atsushifx/articles/wsl2-debian-workingdir-create)
   今後の作業のために、作業用ディレクトリを作成します。

4. [WSLでのDebianのアップグレード方法](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-upgrade)
   `apt`を使って Debian を最新の状態にし、セキュリティと機能の両面でシステムを改善します。

5. [WSL上のDebianを日本語化する方法](https://zenn.dev/atsushifx/articles/wsl2-debian-japanese)
   `apt`を使って日本語パッケージをインストールし、日本語環境を構築します。

6. [wsl.conf を使用して WSL2 の動作をカスタマイズする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-wslconf)
   WSL の設定を自分のニーズに合わせてカスタマイズし、より効率的な開発環境を構築します。

7. [必須パッケージのインストール](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages)
   `zip`, `curl`, `git`などの今後のソフトウェア開発や環境構築に必要なパッケージをインストールします。

8. [dotfilesを使った環境管理](https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles)
   GitHub上の dotfiles リポジトリを使って、環境設定を統一します。

9. [`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what)
   `what`コマンドをインストールします。また、`whatdoc`コメントのフォーマットについて解説します。

## おわりに

この記事では、WSL上で開発環境を構築するための記事をまとめました。
次に、プログラミング言語と必要なツールをセットアップすれば、実際の開発を進められます。

この記事を参考に、新しい開発体験を得てください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- Windows に Linux をインストールする方法 (Microsoft): <https://learn.microsoft.com/ja-jp/windows/wsl/install>
- WSL の基本的なコマンド (Microsoft): <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL での詳細設定の構成 (Microsoft): <https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config>
- Debian パッケージ管理ツール (Debian): <https://www.debian.org/doc/manuals/debian-faq/pkgtools.ja.html>
- APT (Wikipedia): <https://ja.wikipedia.org/wiki/APT>
- `XDG Base Directory` (Arch Wiki): <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
- ドットファイル (Arch WIki): <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
