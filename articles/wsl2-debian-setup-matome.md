---
title: "WSL 開発環境構築: WSLの環境構築記事のまとめ"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "開発環境", "環境構築", ]
published: false
---

## はじめに

この記事では、自分の WSL上の開発環境構築の記事をまとめています。
この記事上の各記事の手順を実行することで、`XDG Base Directory`仕様に従った開発環境が構築できます。

実際のソフトウェア開発には、開発言語や各種ツールのインストールが必要です。
これらも`XDG Base Directory`下に設定ファイルを作成するようにできます。

## WSL開発環境構築の記事まとめ

以下の記事の手順を実行することで、WSL に開発環境を構築できます。

1. [WindowsにWSLをセットアップする手順](https://zenn.dev/atsushifx/articles/wsl2-windowswsl-setup)
   Windows で、`WSL`を使えるように環境を設定する。あわせて、`wsl`コマンドを使えるようにする。

2. [WSL2 に Debian をインストールする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-install)
   `wsl`コマンドを使って、`WSL`上に Debian をインストールする。

3. [WSLでのDebianのアップグレード方法](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-upgrade)
   Debian のパッケージマネージャー`apt`用に、`source.list`日本ミラーを追加する。
   その後、`apt`を使って Debian をアップグレードする。

4. [WSL上のDebianを日本語化する方法](https://www.youtube.com/watch?v=U7yB_buPKSg)
   `apt`を使ってん日本語パッケージをインストールする。
   その後、`locale`を日本語に、`timezone`を`Asia/Tokyo`に設定する。

5. [wsl.conf を使用して WSL2 の動作をカスタマイズする方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-wslconf)
   WSL 用動作設定ファイル`/etc/wsl.conf`を設定し、`WSL`起動時の動作を設定する。
   具体的な設定は、該当記事を参照してください。

6. [dotfiles を使って WSL の環境を管理する方法](https://zenn.dev/atsushifx/articles/wsl2-Debian-dotfiles)
   GitHub上の dotfiles リポジトリを使って、`WSL`の環境設定をする。
   具体的には`XDG Base Directory`用に環境変数を設定し、`XDG Base Directory`下に`bash`などの詳細を設定する。

7. [WSL 開発環境構築ガイド: 必須パッケージのインストール](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages)
   `zip`, `curl`, `git`などの今後のソフトウェア開発や環境構築に必須となるであろうパッケージをインストールする。

8.[`what`コマンドによるスクリプト管理と文書化](https://zenn.dev/atsushifx/articles/wsl-shell-command-what)
   拙作`what`コマンドをインストールする。また、今後`what`コマンドを使用するためれに`whatdoc`の記述方法を説明する。

## おわりに

この記事では、WSL上で開発環境を構築するための記事をまとめました。
各記事の方法を実践することで、各開発言語用のベースとなる環境が構築できます。

WSL に開発環境を構築することで、効率的なソフトウェア開発できるでしょう。
それでは、Happy Hacking!
