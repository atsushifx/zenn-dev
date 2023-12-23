---
title: "dotfilesを使ってWSLの環境を管理する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "bash", "dotfiles", "GitHub", ]
published: false
---

## tl;dr

以下の手順で`dotfiles`[^1]を設定します:

1. `GitHub から`dotfiles`リポジトリをクローンする
2. システムディレクトリ、ユーザーディレクトリにシンボリックリンクを作成する
3. `dotfiles`設定スクリプトを`/etc/profile`,`~/.profile`に追加する

これにより、設定ファイルを`dotfiles`リポジトリで一元管理でき、容易にバックアップや移行ができます。

Enjoy!

## はじめに

WSL (Windows Subsystem for Linux)[^2] では、`~/.config`ディレクトリ下に設定ファイルの多くが保存されています。
これらを GitHub上の`dotfiles`リポジトリにて管理することで、バックアップ・バージョン管理・設定の移行などがスムーズに行えます。

この記事では、すでにある GitHub上の`dotfiles`リポジトリを使って、素早く簡単に環境を設定する方法を説明します。

この記事で使用する`dotfilesリポジトリ`は、[dotfiles repository](https://github.com/atsushifx/dotfiles)となります。
このリポジトリをフォークして、この記事の方法に従えば、WSL の設定ファイルを効率的に管理できるでしょう。

## 1. `dotfiles`とは

### 1.1 `dotfiles`とは何か

`dotfiles`は、UNIX/Linux系OS[^3]の設定ファイルを管理するためのリポジトリを示します。

もともと`dotfiles`は、ファイル名が`.`で始まる設定ファイルを指し、これらを集約的に管理することを意味します。
近年では`XDG Base Directory`[^4]という仕様により`~/.config`下にあるディレクトリ、ファイルのことが多くなりました。
この記事では、上記に従い`~/.config/`下にある各種ファイルを`dotfiles`で管理しています。

## 2. `dotfiles`の初期設定

### 2.1 リポジトリからクローン

この記事で使用する`dotfiles`リポジトリは、[/atsushifx/dotfiles](https://github.com/atsushifx/dotfiles)です。
これを`~/.local/`下にクローン[^5]し、ローカルの WSL上に設定ファイルをコピーします。

次のコマンドを実行します:

```bash
git clone https://github.com/atsushifx/dotfiles
```

実行した結果、以下のように出力されます:

```bash
Cloning into 'dotfiles'...
remote: Enumerating objects: 1580, done.
remote: Counting objects: 100% (57/57), done.
remote: Compressing objects: 100% (43/43), done.
remote: Total 1580 (delta 19), reused 39 (delta 13), pack-reused 1523
Receiving objects: 100% (1580/1580), 295.93 KiB | 14.09 MiB/s, done.
Resolving deltas: 100% (730/730), done.
```

この結果、ローカルの PC上に GitHub上の`dotfiles`がコピーされます。

### 2.2 シンボリックリンクの作成

クローンしたディレクトリをもとに、本来のディレクトリへシンボリックリンク[^6]を作成します。
この操作により、設定ディレクトリの変更が直接リポジトリのファイルに反映され、バージョン管理が容易になります。

#### システムディレクトリのシンボリックリンク

`linux/opt/`下の各ディレクトリを'/opt'下にシンボリックリンクします。
次のリンク用スクリプトを実行します:

```bash
~/.local/dotfiles/scripts/bootstrap-linux/optlinks.sh
```

#### ユーザーディレクトリのシンボリックリンク

`linux/.config`ディレクトリを`$HOME`下にシンボリックリンクします。
次のコマンドを実行します:

```bash
ln -s ~/local/dotfiles/linux/.config ~
```

これで、$XDG_CONFIG_HOME ディレクトリがリポジトリの管理下となります。

### 2.3 `/etc/profile`, `~/.profile`の書き換え

リポジトリ管理下の`dotfiles`が参照されるように、`/etc/profile`,`~/.profile`にスクリプトを追加します。
以下のスクリプトを、それぞれのファイルの最終行に追加します:

```bash: /etc/profile
if [[ -f /opt/etc/profile]]; then
  . /opt/etc/profile
fi
```

**注意**:
`/etc/profile`はシェルが自動的に実行するスクリプトです。
上記のようにスクリプトを追加することで`/opt/etc/profile`、つまり`dotfiles`管理下の`profile`も自動的に実行します。、

```bash: ~/.profile
## exec dotfiles
if [[ -f "$HOME/.config/profile" ]]; then
  . $HOME/.config/profile
fi
```

**注意**:
`~/.profile`はシェルスクリプトがユーザースクリプトとして自動的に実行するスクリプトです。
上記のスクリプトを追加することで、`XDG_CONFIG_HOME`下の`profile`スクリプトも自動的に実行されます。

以後、シェルの起動時にはリポジトリ下の設定ファイルを参照するようになります。

## おわりに

以上で、WSL を`dotfiles`リポジトリを使って管理する方法を説明しました。
この記事では、`XDG Base Directory`で規定されている`~/.config`下にある設定ファイルを対象にしています。

`/etc/profile`や`~/.profile`にスクリプトを追加することで、上記`~/.config`下の設定ファイルを参照するようにしています。

`dotfiles`の活用により、WSL 環境を迅速かつ効率的に構築し、継続的な管理を実現できます。
ぜひ、本記事で紹介した方法を使って、dotfiles を効率的に管理してみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `archlinux` - `dotfiles`: <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
- `archlinux` - `XDG Base Directory`: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>

[^1]: `dotfiles`: UNIX/Linux系の OS の設定ファイルを管理するためのリポジトリ
[^2]: WSL: `Windows Subsystem for Linux`の略称で、Windows上で Linux の実行ファイルを動作させるための互換レイヤー
[^3]: UNIX/Linux系OS: 複数のユーザーが同時に利用できるマルチタスク／マルチユーザーの OS
[^4]: `XDG Base Directory`: UNIX/Linux系OS で各種設定ファイルの保存ディレクトリを規定する仕様
[^5]: クローン: バージョン管理システム`git`のコマンドで、リモートリポジトリを PC上のローカルにコピーするコマンド
[^6]: シンボリックリンク: ファイルやディレクトリを別の芭蕉から参照するための仮想的なリンクで、一般的なファイル／ディレクトリと同様に動作する
