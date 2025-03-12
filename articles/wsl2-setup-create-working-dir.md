---
title: "WSL 2: 作業環境を整える作業用ディレクトリ作成ガイド"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "XDG", "作業用ディレクトリ", "ディレクトリ設計" ]
published: false
---

## はじめに

atsushifx です。

この記事では、`Debian`環境で使用している作業用ディレクトリ構成を紹介します。
`XDG Base Directory`仕様を基本に、プログラミング用にわかりやすくディレクトリを整理しました。

この記事が、使いやすく整理しやすいディレクトリ構成を作るための一助になると幸いです。

## 1. `WSL`環境でのディレクトリ構成

## 1.1 `WSL`環境と`Linux`環境の違い

`WSL`は Windows上で動作する Linux サブシステムです。
そのため、純粋な Linux環境とは異なる点があります。

- Linux のデスクトップ向けフォルダ（Desktop、Documents など）が存在しない
- Windows上のディレクトリが参照できる (`/mnt/c/`)

これらを考慮して、ディレクトリを設計する必要があります。

## 1.2 `XDG Base Directory`とは

`XDG Base Directory`は、アプリケーションの設定ファイルやデータを統一的に管理するための仕様です。
それまで、各アプリケーションの設定ファイルは、ホームディレクトリ上に分散して配置されていました。
`XDG Base Directory`の仕様に従えば、設定ファイルは`${XDG_CONFIG_HOME}`下で一元管理されます。
結果、各設定ファイルを`GitHub`上に用意した`dotfiles`ポジトリで一元管理できるようになります。

## 2. ディレクトリ設計

この章では、`WSL 2`環境におけるディレクトリ設計の考え方を紹介します。
基本的な設計方針と具体的なディレクトリの例を紹介します。

### 2.1 ディレクトリ設計方針

ディレクトリ設計においては、各ディレクトリの用途や目的を明確にすることが重要です。
それぞれのディレクトリの用途をはっきりさせることで、整理されたディレクトリ管理ができます。

### 2.2 基本ディレクトリ

ユーザーごとに使用するスクリプトや一時ファイルの配置用ディレクトリを設定します。

| ディレクトリ | 用途 |
| --- | --- |
| ~/bin | ユーザー固有の、スクリプト、バイナリを配置 |
| ~/temp | 一時ファイルを保存する |

### 2.3 `XDG Base` ディレクトリ

アプリケーションごとの設定やキャッシュは、`XDG Base Directory`に準拠して整理します。
これにより、設定ファイルを`GitHub`の`dotfiles`リポジトリで管理しやすくなります。

| ディレクトリ | 関連環境変数 | 用途 |
| --- | --- | --- |
| `~/.config`      | `$XDG_CONFIG_HOME` | アプリケーションの設定ファイル |
| `~/.local/share` | `$XDG_DATA_HOME` | アプリケーションのデータ |
| `~/.local/cache` | `$XDG_CACHE_HOME` | キャッシュデータ |
| `~/.local/state` | `$XDG_STATE_HOME` | ステートデータ |

### 2.4 `workspaces`ディレクトリ

`workspaces`下にプログラミング関連のプロジェクトなどをまとめます。

| ディレクトリ | 用途 |
| --- | --- |
| ~/workspaces | プログラミングルート |
| ~/workspaces/develop | 開発プロジェクト |
| ~/workspaces/education | 学習用コンテンツ |
| ~/workspaces/sandbox | プログラミング用サンドボックス |
| ~/workspaces/temp | 一時ファイル用 |

## 3.ディレクトリの作成

### 3.1 あらかじめ作成しておくディレクトリ

`Git`が使用する設定ファイルやデータ用のディレクトリを、あらかじめ作成しておきます。

| ディレクトリ | 用途 |
| --- | --- |
| ~/.config/git | 設定ファイル、アトリビュートファイル、ignoreファイル |
| ~/.local/share/git | git用credentialファイル |

### 3.2 ディレクトリツリー

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

### 3.3 ディレクトリ作成スクリプト

上記のディレクトリは、下記のスクリプトで自動的に作成できます。

```bash
#!/bin/bash

# binディレクトリ : ユーザー固有の実行可能ファイル、スクリプト配置用
mkdir -p ~/bin
# 一時ファイル用
mkdir -p ~/temp

# XDG仕様に従い、設定ディレクトリを作成
mkdir -p ~/.config ~/.local/share ~/.local/cache ~/.local/state
mkdir -p ~/.config/git ~/.local/share/git

# プログラミング用に`workspaces`ディレクトリを作成
mkdir -p ~/workspaces/{develop,education,sandbox,temp}
```

## おわりに

以上で、`WSL 2`環境におけるディレクトリ構成を説明しました。
必要なディレクトリを作成するスクリプトもあるので、容易に自分の環境に取り込めるでしょう。

`WSL 2`のような仮想環境を使う場合、同じような環境を複数用意して使用することが多いでしょう。

ディレクトリ管理と統一により、効率的な開発環境の基礎が構築できます。
さらに、`.bashrc`などの初期化スクリプトを適切に設定することで、環境変数の自動設定、`Path`の設定、コマンドのエイリアスが有効になり、より実用的な開発環境が構築できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [XDG Base Directory](https://wiki.archlinux.jp/index.php/XDG_Base_Directory):
  Arch Wiki による、`XDG Base Directory`仕様の説明
