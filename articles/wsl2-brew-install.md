---
title: "WSL開発環境: Homebrewのセットアップ"
emoji: "☕"
type: "tech"
topics: ["WSL", "開発環境", "Homebrew", "brew", ]
published: false
---

## はじめに

Homebrew は、`macOS` で広く利用されるパッケージマネージャーで、Linux や WSL[^1] 環境下でも使用できます。
WSL は Windows上で Linux 環境を提供する機能で、開発者にとって非常に便利です。

`Homebrew`は、各種パッケージを*`/home/linuxbrew`下にインストールするため、管理者権限を必要としません。
システムへの影響を最小限に抑えるため、開発環境の構築時に大きな利点となります。

[^1]: WSL (Windows Subsystem for Linux): Windows上で Linux 環境を提供する機能

## 1. 注意事項

Linux版Homebrew[^2] では、`/home/linuxbrew`下にパッケージを配置しています。
このディレクトリ構造のため、`linuxbrew`というユーザーアカウントのホームディレクトリと衝突します。
これを防ぐため、`linuxbrew`というユーザーアカウントを作成するとことは避けましょう。

[^2]: Homebrew: `macOS`向けに開発されたパッケージ管理システムで、Linux 環境や WSL でも利用可能

## 2. Homebrewのセットアップ

### 2.1 パッケージのインストール

Homebrew をインストールするためには、`apt`を使用して`build-essential`[^3] などの必要なパッケージをインストールしておきます。

以下のコマンドを実行して必要なパッケージをインストールします:

```bash
sudo apt install build-essential gcc procps curl wget file git
```

[^3]: `build-essential`: ソフトウェアのビルドに必要なパッケージをまとめたメタパッケージ

### 2.2 Homebrewのインストール

Homebrew のインストール方法は、[brew.sh](https://brew.sh/)に示されています。
以下のコマンドを実行して、Homebrew をインストールします:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

上記のコマンドを実行すると、下記のようなメッセージが表示されます。

```bash
==> Checking for `sudo` access (which may request your password)...
==> This script will install:
/home/linuxbrew/.linuxbrew/bin/brew
 .
 .
 .
Press RETURN/ENTER to continue or any other key to abort:
```

\[ENTER]キーを押すと、インストールを続行します。

```bash
 .
 .
 .
==> Next steps:

```

上記のように、"Next steps:"と表示されれば、インストールは成功しています。
以上で、Homebrew のインストールは完了です。

### 2.3 環境変数の設定

Homebrew を正しく使用するために、環境変数と PATH を設定する必要があります。
以下のスクリプトを`/opt/etc/envrc`[^4] に追加して、環境変数を設定してください:

```bash:/opt/etc/envrc
# setup for brew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
if [[ -d "${HOMEBREW_PREFIX}" ]]; then
  HOMEBREW_CACHE="${HOMEBREW_PREFIX}/.local/cache"
  HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
  HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew";

  PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:${PATH+:$PATH}";
  MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
  INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";

  export HOMEBREW_PREFIX HOMEBREW_CACHE HOMEBREW_CELLAR HOMEBREW_REPOSITORY
  export PATH MANPATH INFOPATH
fi

```

[^4]: `/opt/etc/envrc`: `dotfiles`で規定されたユーザー共通の環境変数設定

### 2.4 Terminalの再起動

Homebrew の設定を有効にするため、`Windows Terminal`上で Debian タブを再起動します。
再起動後は、以下のように brew コマンドが使用できます:

```bash
$ brew -v
Homebrew 4.2.6

```

上記のようにバージョンが表示されれば、Homebrew は正常にインストールされています。

## おわりに

Homebrew を使用して、WSL上で開発環境を効率的に構築できます。
これにより、開発作業がスムーズに行え、ソフトウェア開発の生産性が向上します。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [brew ホームページ](https://brew.sh)
- [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)
- [dotfiles を使った環境管理](https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles)
