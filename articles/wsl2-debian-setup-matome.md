---
title: "WSL 開発環境構築: 開発環境の構築記事 (まとめ)"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "開発環境", "環境構築", ]
published: false
---

## はじめに

この記事では、WSL (Windows Subsystem for Linux) で開発環境を構築するための記事をまとめています。
各記事の手順を実行することで、`XDG Base Directory`仕様に従った開発環境が構築できます。

実際のソフトウェア開発には、開発言語や各種ツールをインストールする必要があります。
これらも`XDG Base Directory`下に設定ファイルを作成するようにできます。

## キーワード

- WSL (Windows Subsystem for Linux):
  Windows上で Linux の環境を再現するサブシステム

- `XDG Base Directory`:
  Linux上で各種ツールが使用するファイルを保存する際のディレクトリ配置を定めている仕様

- Debian:
  信頼性と安定性に重点を置いた Linux ディストリビューション

- apt (Advanced Package Tool):
  Debian系の Linux ディストリビューションで使用されるパッケージマネージャー

- `/etc/wsl.conf`:
  WSL の動作を設定する設定ファイル

- `dotfiles`:
  各種ツールの設定ファイルをバージョン管理するためのリポジトリ

- `whatdoc`:
  `what`コマンドの文書化に使用される、規定されたフォーマットのコメント

## WSL開発環境構築の記事まとめ

以下に WSL で開発環境を構築する記事をまとめました。
各記事の手順に従うことで、開発環境が構築できます。

1. [WindowsにWSLをセットアップする手順](https://zenn.dev/atsushifx/articles/wsl2-windowswsl-setup)
   Windows で、`WSL`を使えるように環境を設定する。あわせて、`wsl`コマンドを使えるようにする。

2. [WSL2 に Debian をインストールする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-install)
   `wsl`コマンドを使って、`WSL`上に Debian をインストールする。

3. [WSLでのDebianのアップグレード方法](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-upgrade)
   Debian のパッケージマネージャー`apt`用に、`source.list`日本ミラーを追加する。
   その後、`apt`を使って Debian をアップグレードする。

4. [WSL上のDebianを日本語化する方法](https://zenn.dev/atsushifx/articles/wsl2-debian-japanese)
   `apt`を使ってん日本語パッケージをインストールする。
   その後、`locale`を日本語に、`timezone`を`Asia/Tokyo`に設定する。

5. [wsl.conf を使用して WSL2 の動作をカスタマイズする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-wslconf)
   WSL 用動作設定ファイル`/etc/wsl.conf`を設定し、`WSL`起動時の動作を設定する。
   具体的な設定は、該当記事を参照してください。

6. [dotfiles を使って WSL の環境を管理する方法](https://zenn.dev/atsushifx/articles/wsl2-Debian-dotfiles)
   GitHub上の dotfiles リポジトリを使って、`WSL`の環境設定をする。
   具体的には`XDG Base Directory`用に環境変数を設定し、`XDG Base Directory`下に`bash`などの詳細を設定する。

7. [必須パッケージのインストール](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages)
   `zip`, `curl`, `git`などの今後のソフトウェア開発や環境構築に必須となるであろうパッケージをインストールする。

8.[`what`コマンドによるスクリプト管理と文書化](https://zenn.dev/atsushifx/articles/wsl-shell-command-what)
   拙作`what`コマンドをインストールする。また、今後`what`コマンドを使用するためれに`whatdoc`の記述方法を説明する。

## おわりに

この記事では、WSL上で開発環境を構築するための記事をまとめました。
各記事の方法を実践することで、各開発言語用のベースとなる環境が構築できます。

WSL に開発環境を構築することで、効率的なソフトウェア開発できるでしょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL を使用して Windows に Linux をインストールする方法: <https://learn.microsoft.com/ja-jp/windows/wsl/install>
- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL での詳細設定の構成: <https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config>
- Debian パッケージ管理ツール: <https://www.debian.org/doc/manuals/debian-faq/pkgtools.ja.html>
- APT - Wikipedia: <https://ja.wikipedia.org/wiki/APT>
- `XDG Base Directory` - Arch Wiki<https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
- ドットファイル - Arch WIki:<https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
