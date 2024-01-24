---
title: "WSL開発環境: 追加のパッケージのインストール"
emoji:  "🐧"
type: "tech"
topics: [ "wsl", "開発環境", "APT",  "bash"]
published: false
---

## はじめに

この記事では、WSL[^1]上の Debian[^2]環境を使った開発作業の効率をさらに向上させる追加パッケージを紹介します。
[必須パッケージ](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-package) に加えて、これらのツールをインストールすることで、開発がよりスムーズになります。

[^1]: WSL (Windows Subsystem for Linux): Windows上で Linux バイナリを直接実行するための互換レイヤー
[^2]: Debian: フリーでオープンソースの Linux ディストリビューション

## 1. 記事の前提

この記事は、[高速セットアップ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian)で構築した Debian 環境をもとにしています。
この環境は、`bash`を使用し、`/opt/etc/`下の設定ファイルによって、カスタマイズが可能です。
すでに`XDG Base Directory`[^3] などの基本的な設定は完了しており、すぐに作業を開始できます。

[^3]: `XDG Base Directory`: アプリケーション設定ファイルのための標準ディレクトリパスを定義する仕様、およびその環境変数

## 2. 追加するパッケージ

### 2.1 補完機能

コマンドライン作業の効率を上げるために、タブキーを使ってコマンドを補完する機能を追加します。

| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | --- |
| `bash-completion`[^4] | `bash`コマンドラインにタブ補完機能を提供 | コマンドの補完により、日常の開発作業を迅速化する |  `git`など、多くのコマンドで利用可能 |

インストールコマンド:

```bash
sudo apt install bash-completion
```

[^4]: `bash-completion`:コマンドライン作業の効率を高めるための補完機能を提供するパッケージ

### 2.2 タブ補完機能の組み込み方法

タブ補完機能は、`bash`起動時に設定スクリプトを読み込む必要があります。
ただし、高速セットアップを使用した環境では、この設定はすでに含まれていますので、追加作業は不要です。

それ以外の場合は、手動で設定する必要があります。
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
| `build-essential`[^5] | ビルドに必要な基本的なパッケージ | ほかのツールをビルドする際に必要なため |  |
| `python3` | Python 実行環境 | スクリプトの作成、利用のため  |  |

インストールコマンド:

```bash
sudo apt install build-essential python3
```

[^5]: `build-essential`:  Debian系Linux ディストリビューションでソフトウェアをビルドするのに必要な基本的なパッケージ群

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

WSL上での開発環境を強化するためのツールを紹介しました。
これらのツールを利用することで、日々の作業が迅速かつ効率的になるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- カスタム Debian による高速セットアップ
  URL: <https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian>

- Debian 上での必須パッケージのインストール
  URL: <https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages>
