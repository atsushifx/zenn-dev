---
title: "WSL開発環境: dotfilesを使った環境管理"
emoji: "🐧"
type: "tech"
topics: ["WSL", "bash", "dotfiles", "環境構築", ]
published: false
---

## tl;dr

`dotfiles`を使用すると、以下の手順で簡単に開発環境を構築できます:

1. `dotfiles`リポジトリのフォーク
2. WSL 環境に`dotfiles`をクローン
3. シンボリックリンクを作成して、設定ファイルを管理
4. `profile`スクリプトを編集して、自動読み込み

これにより、環境設定の効率的な管理とバージョン管理が可能になります。

Enjoy!

## はじめに

WSL上で`dotfiles`を使用して設定ファイルを一元管理する方法を紹介します。
これにより、バックアップや環境の移行、設定の同期が容易に行えます。

## 技術用語

この記事で使う技術用語をリストアップします:

- WSL (Windows Subsystem for Linux):
  Windows上で Linux を実行する機能

- `dotfiles`:
  UNIX/Linux系OS の設定ファイルを管理するためのリポジトリ

- `XDG Base Directory`:
  設定ファイルやキャッシュなどを整理し、管理を容易にするためのディレクトリ標準規格

- リポジトリ (Repository):
  バージョン管理システムにおいて、ファイルやディレクトリの変更履歴を保存する場所

- シンボリックリンク (Symbolic Link):
  あるファイルやディレクトリを別の場所から参照するためのショートカット

## 1. `dotfiles`とは

`dotfiles`は設定ファイルを効率的に管理するためのリポジトリです。
設定のバックアップ、移行、共有が簡単に行えます。

## 2. `dotfiles`の初期設定

### 2.1 dotfilesリポジトリのフォーク

`dotfiles`リポジトリを自分の GitHub アカウントにフォークし、`dotfiles`リポジトリをコピーします。
これにより、自分の`dotfiles`を使って WSL 環境をパーソナライズし、自分だけの開発環境を構築できます。

[dotfiles リポジトリ](https://github.com/atsushifx/dotfiles)にアクセスし、\[Fork]ボタンをクリックしてください。

![フォークの方法](https://imgur.com/Za9iXFh.png)

**注意**:
フォークすると、自分の GitHub アカウントに`dotfiles`リポジトリが作成されます。

### 2.2 dotfilesリポジトリのクローン

フォークした`dotfiles`リポジトリを WSL上の Debian にクローンし、`dotfiles`を WSL上にダウンロードします。

以下のコマンドを実行します:

```bash
git clone https://github.com/<myaccount>/dotfiles
```

**注意**:
\<myaccount>を自分の GitHub アカウントに変えて実行してください。

実行結果は以下のようになります:

```bash
Cloning into 'dotfiles'...
remote: Enumerating objects: 1580, done.
remote: Counting objects: 100% (57/57), done.
remote: Compressing objects: 100% (43/43), done.
remote: Total 1580 (delta 19), reused 39 (delta 13), pack-reused 1523
Receiving objects: 100% (1580/1580), 295.93 KiB | 14.09 MiB/s, done.
Resolving deltas: 100% (730/730), done.
```

この結果、GitHub上の`dotfiles`がローカルの PC にコピーされます。

### 2.3 シンボリックリンクの作成

シンボリックリンクを作成することで、設定ファイルを効率的に管理し、常に最新の状態に保つことができます。
これにより、変更をリポジトリに簡単に反映させることができます。

以下のスクリプトを実行して、シンボリックリンクを作成します:

```bash
~/.local/dotfiles/scripts/bootstrap-linux/dotfileslinks.sh
```

実行すると、以下のリンクが作成されます。

```bash:$HOME
.config -> ./.local/dotfiles/linux/.config
.editorconfig -> ./.config/.editorconfig
```

```bash:/opt
bin -> /home/<myaccount>/.local/dotfiles/linux/opt/bin
etc -> /home/<myaccount>/.local/dotfiles/linux/opt/etc
```

**注意**:
\<myaccount>は、自分のアカウントとなります。

### 2.4 `/etc/profile`, `~/.profile`の書き換え

このステップでは、シェルが起動するたびに自動的に`dotfiles`の設定が読み込まれるようにしまます。
これにより、環境設定の一貫性と再現性が保たれます。

以下のスクリプトを実行します:

```bash
~/.local/dotfiles/scripts/bootstrap-linux/addscripts.sh
```

実行すると、次の内容がファイルに追加されます。

```: /etc/profile
if [[ -f /opt/etc/profile]]; then
  . /opt/etc/profile
fi
```

```: ~/.profile
## exec dotfiles
if [[ -f "$HOME/.config/profile" ]]; then
  . $HOME/.config/profile
fi
```

## おわりに

この記事では、`dotfiles`リポジトリを使用して WSL の環境を管理する方法について説明しました。
`dotfiles`を活用することで、WSL の開発環境を迅速かつ効率的に構築できるだけでなく、環境を継続的に管理することも可能になります。

開発環境を素早く構築し、新たなプログラミング体験を楽しみましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- Linux 用 Windows サブシステムとは
  URL: <https://learn.microsoft.com/ja-jp/windows/wsl/about>
  説明: Microsoft 公式による WSL の詳細な説明とその利用方法

- `dotfiles` - `Arch Wiki`
  URL: <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
  説明: `dotfiles`のバージョン管理方法とそのメリット

- `XDG Base Directory` - `Arch Wiki`
  URL: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
  説明: `XDG Base Directory`の基本原則と、それに準拠するアプリケーションのリスト
