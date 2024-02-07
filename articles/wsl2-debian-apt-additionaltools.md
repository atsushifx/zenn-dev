---
title: "WSL開発環境: 開発効率を向上させるパッケージのインストール"
emoji:  "🐧"
type: "tech"
topics: [ "wsl", "開発環境", "APT",  "bash"]
published: true
---

## はじめに

WSL[^1] 上の Debian[^2] 環境をさらに便利に使うため、作業効率を向上させる各種パッケージをインストールします。
`bash-completion`や`rlwrap`パッケージをインストールすれば、`CLI`[^3]操作の効率を向上させ、対話的インタフェースの利用を快適にします。

[^1]: WSL (Windows Subsystem for Linux): Windows上で Linux バイナリを直接実行するための互換レイヤー
[^2]: Debian: フリーでオープンソースの Linux ディストリビューション
[^3]: `CLI` (Command-Line Interface): コマンドを打ち込むことでコンピューターに指示を与えるインタフェース

## 1. 記事の前提環境

この記事は、[高速セットアップ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian)で構築した Debian 環境
を前提にしています。
高速セットアップとは、事前にカスタマイズされた Debian をインポートすることで、WSL上の Debian を迅速に設定するプロセスです。
これにより、`/opt/etc/`下で全ユーザー共通のカスタマイズが可能となります。
`XDG Base Directory`[^4]に対応しており、`~/.config`下に各ユーザーごとの設定を記述できます。

なお、基本的な Linux コマンドや WSL の操作に慣れているほうであれば、一般的な WSL上の Debian 環境にも適用可能な内容です。

[^4]: `XDG Base Directory`: アプリケーションの設定ファイルやデータファイルを格納するためのフォルダ構造の標準規格

## 2. 追加するパッケージ

WSL上で開発効率を上げるために推奨する追加的なパッケージを紹介します。
`bash-completion` をインストールすることで、bash で各種コマンドのオプションなどの補完が可能になります。

### 2.1 補完機能

コマンドライン操作を効率化するため、タブ補完機能を追加します。

<!-- markdownlint-disable line-length -->
| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | --- |
| `bash-completion`[^5] | `bash`コマンドラインにタブ補完機能を提供 | 長いファイル名やオプションを補完でき、`CLI`での作業をよりスムーズにします。| `git`など、多くのコマンドで利用できます。これにより、さまざまな開発作業の効率が向上します |

<!-- markdownlint-enable -->

以下のコマンドで、パッケージをインストールします:

```bash
sudo apt install bash-completion
```

[^5]: `bash-completion`:コマンドライン作業の効率を高めるための補完機能を提供するパッケージ

### 2.2 タブ補完機能の組み込み手順

タブ補完機能は、`bash`起動時に設定スクリプトを読み込む必要があります。
高速セットアップを使用した環境では、この設定はすでに含まれていますので、追加作業は不要です。

高速セットアップを行っていない場合は、手動で設定する必要があります。
システムの起動スクリプト`/opt/etc/profile`に以下のスクリプトを追加して、タブ補完機能を有効にします:

```bash:/opt/etc/profile
if [[ "${SHELL}" =~ "bash" ]]; then
  # bash-completion
  if [[ -f "/etc/bash_completion" ]]; then
    . "/etc/bash_completion"
  fi
fi
```

上記スクリプトは、`bash`起動時に読み込まれ、タブ補完機能を有効にします。

### 2.3 開発ツール

ソフトウェアの開発や必要なパッケージをインストールします。

| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | --- |
| `build-essential`[^6] | ビルドに必要な基本的なパッケージ | ほかのツールをビルドする際に必要なため |  |
| `delta` | 2つのファイルの`diff`をビジュアルに表示 |  |  |

以下のコマンドで、パッケージをインストールします:

```bash
sudo apt install build-essential delta
```

[^6]: `build-essential`:  Debian系 Linux ディストリビューションでソフトウェアをビルドするのに必要な基本的なパッケージ群

### 2.4 効率化ツール

プログラミングやコマンドラインの効率的に使えるツールをインストールします。

| パッケージ名 | 説明 | 選定理由 | 備考 |
| --- | --- | --- | --- |
| `rlwrap` | `CLI`にヒストリーや入力補完機能を追加 | プログラミング言語などの対話的インタフェースで使用する |  |

`rlwrap`は、`CLI`にヒストリー機能や入力補完機能を追加するツールです。
これにより、対話式セッションでコマンドの履歴や補完機能が向上し、効率的に作業が可能です。

```bash
sudo apt install rlwrap
```

`rlwrap`を`XDG Base Directory`に対応させるため、環境変数を設定します。
環境変数設定スクリプト`/opt/etc/envrc`に、次の設定を追加します:

```bash:/opt/etc/envrc
#   rlwrap
export RLWRAP_HOME="${XDG_CACHE_HOME}/rlwrap"

```

## 3. WSLの再起動

パッケージのインストール後、これらの変更をシステム全体に適用するためには、WSL を再起動する必要があります。
これにより、新しくインストールしたパッケージや設定変更がシステム全体に適用されます。

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

次は、各種プログラミング言語の開発環境を構築し、快適なプログラミングを楽しんでください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [カスタム Debian による高速セットアップ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-customdebian):
  WSL のインポート機能を利用した、Debian 環境の高速セットアップ方法を解説しています。

- [Debian 上での必須パッケージのインストール](https://zenn.dev/atsushifx/articles/wsl2-debian-apt-packages):
  WSL上の Debian での開発に必要な基本パッケージについて紹介しています。
