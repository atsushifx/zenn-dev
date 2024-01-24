---
title: "WSL開発環境: 追加のパッケージのインストール"
emoji:  "🐧"
type: "tech"
topics: [ "wsl", "開発環境", "APT",  "bash"]
published: false
---

## はじめに

この記事では、WSL上の Debian 環境で開発作業を行なう際、さらに効率を上昇させるための追加パッケージを紹介します。
[必須パッケージ](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-package) に加えて、これらのツールをインストールすることで、より効率的な開発ができます。

## 1. 記事の前提

この記事は、[高速セットアップ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian)で構築した Debian 環境をもとにしています。
この環境は、`bash`を使用し、`/opt/etc/`下の設定ファイルによって、カスタマイズが可能です。
すでに`XDG Base Directory`などの基本的な設定は完了しており、すぐに作業を開始できます。

## 2. 追加するパッケージ

### 2.1 補完機能

コマンドラインでの作業効率を高めるタブ補完機能を導入します。

| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | --- |
| `bash-completion` | `bash`コマンドラインにタブ補完機能を提供 | コマンドの補完により、日常の開発作業を迅速化する |  `git`など、多くのコマンドで利用可能 |

インストールコマンド:

```bash
sudo apt install bash-completion
```

### 2.2 タブ補完機能の組み込み方法

前提環境では、コードは記述済みのためこのセクションは必要ありません。
前提環境以外の場合は、手動で設定する必要があります。

タブ補完機能は、`bash`起動時に設定スクリプトを起動させる必要があります。
システムの起動スクリプト`/opt/etc/profile`に以下のコードを追加します:

```bash:/opt/etc/profile
if [[ "${SHELL}" =~ "bash" ]]; then
  # bash-completion
  if [[ -f "/etc/bash_completion" ]]; then
    . "/etc/bash_completion"
  fi
fi
```

これで、`bash`にタブ補完機能が追加されます。

### 2.3 開発ツール

WSL上で使用するツールをリストアップします。

| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | ---  |
| `build-essential` | ビルドに必要な基本的なパッケージ | ほかのツールをビルドする際に必要なため |  |
| `python3` | Python 実行環境 | スクリプトの作成、利用のため  |  |

インストールコマンド:

```bash
sudo apt install build-essential python3
```

## 3. WSLの再起動

パッケージのインストール後、変更を有効にするため、WSL を再起動します」。
以下の手順で、WSL を再起動します。

1. WSL のシャットダウン:
   コマンドを入力し、WSL をシャットダウンします。

   ```powershell
   wsl --shutdown
   ```

2. WSL上の Debian の起動:
   `Windows Terminal`で Debian を選び、Debian を起動します。

以上で、WSL の再起動は終了です。

## おわりに

この記事を通じて、WSL上での開発環境を強化するためのツールを紹介しました。
これらを導入することで、開発プロセスをより快適で効率的にし、日々の作業を大きく改善するでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- カスタム Debian による高速セットアップ
  URL: <https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian>

- Debian 上での必須パッケージのインストール
  URL: <https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages>
