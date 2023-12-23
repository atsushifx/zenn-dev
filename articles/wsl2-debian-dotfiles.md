---
title: "WSLの設定ファイルをGitHub上のdotfilesで管理する"
emoji: "🐧"
type: "tech"
topics: ["WSL", "bash", "dotfiles", "GitHub", ]
published: false
---

## tl;dr

以下の手順で`dotfiles`[^1]を設定します:

1. `dotfiles`を GitHub から`clone`する

2. システムディレクトリ、`~/.config`ディレクトリを clone したリポジトリからシンボリックリンクする

3. `/etc/profile`,`~/.profile`に既定のスクリプトを追加する

以上で、各種設定ファイルを`dotfiles`で管理できます。
詳しい方法は、この記事の各章を見てください。

Enjoy!

[^1]: `dotfiles`: ツールの各種設定を保存するファイルやディレクトリで、`.`で始まるファイルであることからこう呼ばれる

## はじめに

WSL[^2] では各種ツールの設定は、`.`から始まる設定ファイルに格納されています。
最新の Linux ディストリビューションの多くは、これらの設定ファイルを`XDG Base Directory`[^3]である`~/.config`下に格納しています。

これらの各種設定ファイルを`GitHub`リポジトリ`dotfiles`で管理することで、バージョン管理、バックアップ、ほかの WSL への設定の移行などを可能にします。

この記事の`dotfiles`リポジトリは、<https://github.com/atsushifx/dotfiles>です。
上記をフォークすることで、この記事と同じように設定ファイルを管理できます。

[^2]: WSL: `Windows Subsystem for Linux`の略称で、Windows上で Linux の実行ファイルを動作させるための互換レイヤー
[^3]: `XDG Base Directory`: UNIX/Linux系OS で各種設定ファイルの保存ディレクトリを規定する仕様

## 1. `dotfiles`とは

### 1.1 `dotfiles`とはなにか

WSL など UNIX/Linux系の OS では、各種の設定を`.`で始まるファイルに保存しています。
これらの各種設定ファイルを管理するリポジトリは、一般的に`dotfiles`と呼ばれます。

近年では`XDG Base Directory`という仕様により、`~/.config`下に各種ツールの設定がまとまりました。
この記事では、上記に従い`~/.config/`下にある各種ファイルを`dotfiles`で管理しています。

## 2. `dotfiles`の初期設定

### 2.1 リポジトリからのclone

この記事の`dotfiles`リポジトリは、[/atsushifx/dotfiles](https://github.com/atsushifx/dotfiles)です。
これを`~/.local/`下に clone[^4] します。

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

[^4]: clone: バージョン管理システム`git`のコマンドで、リモートリポジトリを PC上のローカルにコピーするコマンド

### 2.3 シンボリックリンクの作成

GitHub から`clone`したディレクトリを本来のディレクトリへシンボリックリンク[^5]します。
こうすることで、設定の変更をするときリポジトリ上のファイルを変更するようになります。

[^5]: `symblic link`: ファイルやディレクトリの実際の位置をしめすリンクで、参照時に実際のディレクトリ／ファイルのように動作する

#### システムディレクトリのシンボリックリンク

`linux/opt/`下の各ディレクトリを'/opt'下にシンボリックします。
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

### 2.4 `/etc/profile`, `~/.profile`の書き換え

リポジトリ管理下の`dotfiles`を実行するように、`/etc/profile`,`~/.profile`にスクリプトを追加します。
以下のスクリプトを、ファイルの最終行に追加します:

```bash: /etc/profile
if [[ -f /opt/etc/profile]]; then
  . /opt/etc/profile
fi
```

```bash: ~/.profile
## exec dotfiles
if [[ -f "$HOME/.config/profile" ]]; then
  . $HOME/.config/profile
fi
```

以後、シェルの起動時にはリポジトリ下の設定ファイルを参照するようになります。

## おわりに

以上で、WSL を`dotfiles`リポジトリを使って管理する方法を説明しました。
この記事では、`XDG Base Directory`で規定されている`~/.config`下にある設定ファイルを対象にしています。

`/etc/profile`や`~/.profile`にスクリプトを追加することで、上記`~/.config`下の設定ファイルを参照するようにしています。

このように`dotfiles`を利用することで、WSL の環境を素早く構築でき、効率的に管理できます。
ぜひ、`dotfiles`を活用してください。

それでは、Happy　Hacking!

## 参考資料

### Webサイト

- `archlinux` - `dotfiles`: <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
- `archlinux` - `XDG Base Directory`: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
