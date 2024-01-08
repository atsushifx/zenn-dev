---
title: "WSL開発環境構築: dotfilesを使ってWSLの環境を管理する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "bash", "dotfiles", "環境構築", ]
published: false
---

## tl;dr

以下に、`dotfiles`を使って WSL の環境を管理する手順を示します:

1. `dotfiles`リポジトリのフォーク:
   自分のアカウントにリポジトリのコピーを作成します。これにより、の個人的なカスタマイズが可能になります

2. `dotfiles`リポジトリのクローン:
    WSL 環境に`dotfiles`の内容をダウンロードします。

3. シンボリックリンクの作成:
   環境設定ファイルを`dotfiles`管理下に置いて、更新を容易にします。

4. `dotfiles`設定スクリプトの追加
   設定を自動で読み込むように、スクリプトを編集します

この方法により、WSL上の環境設定ファイルを`dotfiles`で一元管理し、効率的なバックアップやバージョン管理ができます。

Enjoy!

## はじめに

この記事では、WSL (Windows Subsystem for Linux)[^1] 上の設定ファイルを`dotfiles`リポジトリ[^2] で管理する方法を説明します。
WSL は、Windows上で Linux の実行ファイルを動作させるための互換レイヤーであり、その設定は Linux のそれにしたがいます。
Linux では、設定ファイルは`XDG Base Directory`[^3]の規定にしたがい、`~/.config`下に配置されます。

これらのファイルを`dotfiles`リポジトリで一元管理することで、バックアップ・バージョン管理・環境の移行ができるようになります。

さらに、システムの追加の設定を`/etc`とは別のディレクトリ (`/opt/etc`) で設定しています。
これらのディレクトリを`dotfiles`からのシンボリックリンクにすることで、システム設定も管理の対象にしています。

この記事では、GitHub上の既存の`dotfiles`リポジトリを使って、素早く環境構築する方法を説明します。
リポジトリをフォークし、この記事にしたがうことで、WSL の環境を構築できます。
さらに、構築した環境を自分の`dottfiles`リポジトリで効率的に管理できます。

[^1]: WSL: `Windows Subsystem for Linux`の略称で、Windows上で Linux の実行ファイルを動作させるための互換レイヤー
[^2]: `dotfiles`: UNIX/Linux系OS の設定ファイルを管理するためのリポジトリ

[^3]: `XDG Base Directory`: UNIX/Linux系OS で各種設定ファイルの保存ディレクトリを規定する仕様

## 1. `dotfiles`とは

### 1.1 `dotfiles`とは何か

`dotfiles`は、Linux システムの設定ファイルをまとめたリポジトリです。
Linux の設定ファイルをバージョン管理システムで管理することにより、バックアップ・バージョン管理・環境の移行がスムーズに行えます。

## 2. `dotfiles`の初期設定

### 2.1 dotfilesのフォーク

[dotfiles リポジトリ](https://github.com/atsushifx/dotfiles)にアクセスし、\[Fork]ボタンをクリックしてください。
自分の GitHub アカウントにリポジトリのコピーが作成され、`dotfiles`の個人的なカスタマイズが可能になります。

**注意**:
フォークすると、自分の GitHub アカウントに dotfiles リポジトリが作成されます。

![フォークの方法](https://imgur.com/Za9iXFh.png)

フォークすると、自分の GitHub に dotfiles リポジトリが作成されます。

### 2.2 dotfilesのクローン

フォークした dotfiles リポジトリを WSL上の Debian にクローンします。
次のコマンドを実行します:

```bash
git clone https://github.com/<myaccount>/dotfiles
```

**注意**:
\<myaccount>を自分の GitHub アカウントに変えて実行してください。

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

### 2.3 シンボリックリンクの作成

クローンしたディレクトリをもとに、本来のディレクトリへシンボリックリンクを作成します。
この操作により、設定ディレクトリの変更が直接リポジトリのファイルに反映され、バージョン管理が容易になります。

次のスクリプトを実行して、シンボリックリンクを作成します:

```bash
~/.local/dotfiles/scripts/bootstrap-linux/dotfileslinks.sh
```

実行すると、以下のリンクが作成されます。

```bash: $HOME
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

リポジトリ管理下の`dotfiles`が参照されるように、`/etc/profile`,`~/.profile`にスクリプトを追加します。
次のスクリプトを実行します:

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

以後、シェルの起動時にはリポジトリ下の設定ファイルを参照するようになります。

## おわりに

以上で、WSL を`dotfiles`リポジトリを使って管理する方法を説明しました。
このように`dotfiles`を活用すかることで、WSL の開発環境を迅速かつ効率的に構築できます。
また、環境を継続的に管理できます。

今回紹介した方法を利用して、より快適な開発環境を手に入れましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- `dotfiles` - `Arch Wiki`: <https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB>
- `XDG Base Directory` - `Arch Wiki`: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
