---
title: "WSL開発環境: Homebrewのセットアップ"
emoji: "☕"
type: "tech"
topics: ["WSL", "開発環境", "Homebrew", "brew", ]
published: false
---

## はじめに

Homebrew は、`MacOS` で広く利用されるパッケージマネージャーです。
このツールは Linux や WSL 環境下でも使用でき、管理者権限なしで多様なソフトウェアパッケージを簡単にインストールできる点が大きなメリットです。
とくに、開発ツールや言語の環境構築時にその便利さを発揮します。

## 1. 注意事項

Linux版Homebrew は、`/home/linuxbrew`下にパッケージを配置します。
このディレクトリ構造のため、`linuxbrew`という名前のユーザーアカウントを作成することは避けるべきです。

## 2. Homebrewのセットアップ

### 2.1 パッケージのインストール

Homebrew をインストールするためには、`apt`を使用して必要なパッケージをインストールしておきます。
以下のコマンドを実行します。

```bash
sudo apt install build-essential gcc procps curl wget file git
```

以上で、パッケージのインストールは完了です。

### 2.2 Homebrewのインストール

[brew.sh](https://brew.sh/)にしたがって、brew のインストールスクリプトを実行します。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

スクリプトを実行するとキーの入力待ちになるので、\[ENTER]キーを押して続行します。

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

`brew`用に、環境変数、PATH を設定します。
環境変数設定スクリプト`/opt/etc/envrc`に、以下の行を追加します。

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

### 2.4 Terminalの再起動

環境変数を有効にするため、`Windows Terminal`上で Debian タブを一度閉じてから再開してください。
これにより、設定した brew コマンドのパスが反映され、ターミナル上で直接利用できるようになります。

たとえば、以下のように`brew`コマンドを実行します:

```bash
$ brew -v
Homebrew 4.2.6

```

上記のようにバージョンが表示されれば、Homebrew は正常にインストールされています。

## おわりに

今までの説明で WSL に Homebrew をインストールし、brew コマンドを使えるようになりました。
Homebrew を使えば、システムへの影響を最小限にして開発環境を構築できます。

Homebrew を使用して、スムーズに開発環境を構築し、効率的なソフトウェア開発を体験しましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- brew ホームページ
  URL: <https://brew.sh>
- Homebrew on Linux
  URL:  <https://docs.brew.sh/Homebrew-on-Linux>
