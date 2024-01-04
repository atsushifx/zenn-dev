---
title: "WSL開発環境構築の記事まとめ"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "開発環境", "環境構築", ]
published: false
---

## はじめに

この記事では、WSL (Windows Subsystem for Linux) 上に開発環境を構築するガイドを紹介します。
リストアップした記事の詳細な手順に従えば、WSL に Debian をインストールし、環境設定を完了できます。

- WSL に Debian をインストールします
- `XDG Base Directory`が使えるように環境変数を設定します
- `XDG Base Directory`にしたがってバージョン管理した設定ファイルを設定します

これにより、どの Windows でも同じ WSL開発環境を構築できます。

実際のソフトウェア開発には、開発言語や各種ツールをインストールする必要があります。
これらも`XDG Base Directory`下に設定ファイルを作成するようにできます。

## キーワード

- **WSL (Windows Subsystem for Linux)**:
  Windows で Linux のコマンドやアプリケーションを使えるようにするサブシステム

- **`XDG Base Directory`**:
  Linux システム上でアプリケーションがファイルを格納する際の標準ディレクトリ構成を規定する仕様

- **Debian**:
  信頼性と安定性に重点を置いた Linux ディストリビューション

- **apt (Advanced Package Tool)** :
  Debian系Linux ディストリビューション専用のパッケージ管理ツール

- **`/etc/wsl.conf`**:
  WSL の動作を設定する設定ファイル

- **`dotfiles`**:
  各種ツールの設定ファイルをバージョン管理するためのリポジトリ

- **`whatdoc`**:
  `what`コマンドの文書化に使用される、規定されたフォーマットのコメント

## WSL開発環境構築の記事まとめ

以下に WSL で開発環境を構築する記事をまとめました。
各記事の手順にしたがえば、開発環境を構築できます。

1. [WindowsにWSLをセットアップする手順](https://zenn.dev/atsushifx/articles/wsl2-windowswsl-setup)
   Windows で WSL を使えるように初期設定する

2. [WSL に Debian をインストールする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-install)
   `wsl`コマンドを使って、`WSL`上に Debian をインストールする

3. [WSLでのDebianのアップグレード方法](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-upgrade)
   Debian のパッケージマネージャー`apt`用に、`sources.list`の`CDN`ミラー、日本ミラーを追加する。
   その後、`apt`を使って Debian をアップグレードする。

4. [WSL上のDebianを日本語化する方法](https://zenn.dev/atsushifx/articles/wsl2-debian-japanese)
   `apt`を使って日本語パッケージをインストールする。
   その後、`locale`を日本語に、`timezone`を`Asia/Tokyo`に設定する。

5. [wsl.conf を使用して WSL2 の動作をカスタマイズする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-wslconf)
   WSL 用動作設定ファイル`/etc/wsl.conf`を設定し、`WSL`起動時の動作を設定する。
   具体的な設定は、該当記事を参照してください。

6. [dotfiles を使って WSL の環境を管理する方法](https://zenn.dev/atsushifx/articles/wsl2-Debian-dotfiles)
   GitHub上の dotfiles リポジトリを使って、`WSL`の環境設定をする。
   具体的には`XDG Base Directory`用に環境変数を設定し、`XDG Base Directory`下に`bash`などの詳細を設定する。

7. [必須パッケージのインストール](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages)
   `zip`, `curl`, `git`などの今後のソフトウェア開発や環境構築に必須となるであろうパッケージをインストールする。

8. [`what`コマンドによるスクリプト管理と文書化](https://zenn.dev/atsushifx/articles/wsl-shell-command-what)
   作成した`what`コマンドをインストールする。また、今後`what`コマンドの利用に必要な`whatdoc`コメントのフォーマットについて説明する。

## おわりに

この記事では、WSL上で開発環境を構築するための記事をまとめました。
各記事の方法を実践することで、各開発言語用のベースとなる環境が構築できます。

次に、プログラミング言語と必要なツールをセットアップします。
これにより、WSL上で効率的なソフトウェア開発可能になります。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL を使用して Windows に Linux をインストールする方法: <https://learn.microsoft.com/ja-jp/windows/wsl/install>
- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL での詳細設定の構成: <https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config>
- Debian パッケージ管理ツール: <https://www.debian.org/doc/manuals/debian-faq/pkgtools.ja.html>
- APT - Wikipedia: <https://ja.wikipedia.org/wiki/APT>
- `XDG Base Directory` - Arch Wiki: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
- ドットファイル - Arch WIki: <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
