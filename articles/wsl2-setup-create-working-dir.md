---
title: "WSL 2: 作業環境を整える作業ディレクトリ作成ガイド"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "XDG", "作業ディレクトリ", "ディレクトリ設計" ]
published: true
---

## はじめに

atsushifx です。

この記事では、`Debian`環境で使用している作業ディレクトリ構成を紹介します。
`XDG Base Directory`仕様を基本に、プログラミング用にわかりやすいディレクトリ構成を作成しました。

この記事が、整理しやすく、使いやすいディレクトリ構成の参考になれば幸いです。

## 1. `WSL 2`とは？

`WSL 2` (`Windows Subsystem for Linux 2`) は、Windows上で Linuxカーネルを動作させるための仕組みです。
`WSL 1`と異なり、完全な Linuxカーネルを採用しているため、ネイティブな Linux環境に近い操作性を提供します。

## 2. `WSL`環境でのディレクトリ構成

## 2.1 `WSL`環境と`Linux`環境の違い

`WSL`は Windows上で動作する Linux サブシステムです。
そのため、純粋な Linux環境とは異なる点があります。

- Linux のデスクトップ環境では一般的なフォルダ (`Desktop`, `Documents` など) が`WSL`では標準で用意されていません。
- Windows のディレクトリが、`/mnt/c/`以下にマウントされており、`WSL`からアクセス可能です。

これらの違いを考慮し、適切なディレクトリ構成を設計することが重要です。

## 2.2 `XDG Base Directory`とは

`XDG Base Directory`は、アプリケーションの設定ファイルやデータを標準化し、一貫した管理を可能にする仕様です。
従来は、各アプリケーションの設定ファイルがホームディレクトリに分散していました。
`XDG Base Directory`仕様に従うと、設定ファイルは`${XDG_CONFIG_HOME}`内に整理され、統一的に管理できます。

結果、各設定ファイルを`GitHub`上に用意した`dotfiles`ポジトリで一元管理できるようになります。

## 3. ディレクトリ設計

この章では、`WSL 2`環境におけるディレクトリ設計の考え方を紹介します。
基本的な設計方針と具体的なディレクトリの例を紹介します。

### 3.1 ディレクトリ設計方針

ディレクトリ設計においては、各ディレクトリの用途や目的を明確にすることが重要です。
それぞれのディレクトリの用途をはっきりさせることで、整理されたディレクトリ管理ができます。

### 3.2 基本ディレクトリ

ユーザー固有のスクリプトや一時ファイルを保存するディレクトリを設定します。

| ディレクトリ | 目的 |
| --- | --- |
| `~/bin` | ユーザー固有のスクリプトや実行ファイルを配置 |
| `~/temp` | 一時ファイルを保存する |

### 3.3 `XDG Base Directory` ディレクトリ

アプリケーションごとの設定やキャッシュは、`XDG Base Directory`に準拠して整理します。
これにより、設定ファイルを`GitHub`の`dotfiles`リポジトリで一元管理できます。

| ディレクトリ | 関連環境変数 | 目的 |
| --- | --- | --- |
| `~/.config`      | `$XDG_CONFIG_HOME` | アプリケーションの設定ファイル |
| `~/.local/share` | `$XDG_DATA_HOME` | アプリケーションのデータ |
| `~/.local/cache` | `$XDG_CACHE_HOME` | キャッシュデータ |
| `~/.local/state` | `$XDG_STATE_HOME` | ステートデータ |

### 3.4 `workspaces`ディレクトリ

`workspaces`下にプログラミング関連のプロジェクトなどをまとめます。

| ディレクトリ | 目的 |
| --- | --- |
| `~/workspaces` | プログラミングルート |
| `~/workspaces/develop` | 開発プロジェクト |
| `~/workspaces/education` | 学習用コンテンツ |
| `~/workspaces/sandbox` | プログラミング用サンドボックス |
| `~/workspaces/temp` | 一時ファイル用 |

## 4. ディレクトリの作成

### 4.1 あらかじめ作成しておくディレクトリ

`Git`の設定ファイルやデータを格納するディレクトリを事前に作成します。

| ディレクトリ | 目的 |
| --- | --- |
| `~/.config/git` | 設定ファイル、アトリビュートファイル、ignoreファイル |
| `~/.local/share/git` | git用credentialファイル |

### 4.2 ディレクトリツリー

ディレクトリ構成は、下記のディレクトリツリーとなります。

```bash
~
├── .config
│   └── git
├── .local
│   ├── share
│   │   └── git
│   ├── cache
│   └── state
├── bin
├── temp
└── workspaces
    ├── develop
    ├── education
    ├── sandbox
    └── temp
```

### 4.3 ディレクトリ作成スクリプト

上記のディレクトリは、下記のスクリプトで自動的に作成できます。

```bash
# create-workingDir.sh
#!/bin/bash

## ホームディレクトリに移動
cd ~

# ユーザー固有の実行可能ファイルを保存するディレクトリ
mkdir -p ~/bin
# 一時ファイルを保存するディレクトリ
mkdir -p ~/temp

# 設定ディレクトリを作成　(XDG Base Directory仕様に準拠)
mkdir -p ~/.config \
  ~/.local/share \
  ~/.local/cache \
  ~/.local/state
# Gitの設定ファイル用ディレクトリを作成
mkdir -p \
  ~/.config/git \
  ~/.local/share/git

# プログラミング用に`workspaces`ディレクトリを作成
mkdir -p ~/workspaces/{develop,education,sandbox,temp}
```

上記のスクリプトを保存し、`bash`経由で起動します。

```bash
bash ./create-workingDir.sh
```

以上で、ディレクトリが作成されます。

## おわりに

以上で、`WSL 2`環境におけるディレクトリ構成を説明しました。
必要なディレクトリを作成するスクリプトもあるので、容易に自分の環境に取り込めるでしょう。

`WSL 2`のような仮想環境では、同じ環境を複数用意して運用することが一般的です。

ディレクトリ管理と統一により、効率的な開発環境の基礎が構築できます。
さらに、`.bashrc`などの初期化スクリプトを適切に設定することで、環境変数や`PATH`の自動設定、コマンドのエイリアス適用などを行なう、より実用的な開発環境を構築できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [XDG Base Directory](https://wiki.archlinux.jp/index.php/XDG_Base_Directory):
  Arch Wiki による、`XDG Base Directory`仕様の説明
