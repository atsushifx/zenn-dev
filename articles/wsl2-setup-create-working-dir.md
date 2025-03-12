---
title: "WSL 2: 作業環境を整える作業用ディレクトリ作成ガイド"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "Debian", "XDG", "作業用ディレクトリ", "ディレクトリ設計" ]
published: false
---

## はじめに

atsushifx です。

本記事では、WSL 2環境における Debian での作業用ディレクトリの基本構成について説明する。技術的に正確な手法をもとに、ディレクトリ設計の考え方や構成例を紹介する。この記事を通して、WSL 2環境における作業ディレクトリの統一的な管理方法を習得いただければと考える。

## 1. `WSL`環境でのディレクトリ構成

## 1.1 `WSL`環境と`Linux`環境の違い

`WSL`は Windows上で動作する Linux 語間レイヤーです。
そのため、純粋な Linux環境とは異なる点があります。

- Linux のデスクトップ向けフォルダ（Desktop、Documents など）が存在しない
- Windows との連携を意識した設計が必要となる

## 2. ディレクトリ設計

本セクションでは、WSL 2環境におけるディレクトリ設計の考え方を示す。基本的な設計方針と、具体的なディレクトリの例について記述する。

### 2.1 ディレクトリ設計方針

ディレクトリの設計にあたっては、用途に応じた役割分担を明確にし、管理の効率化を図る。
各ディレクトリは、用途や管理対象が明確になるように配置することが推奨される。

### 2.2 基本ディレクトリ

ユーザーごとに使用するスクリプト、一時ファイル用にディレクトリを設定します。

| ディレクトリ | 用途 |
| --- | --- |
| ~/bin | ユーザー固有の、スクリプト、バイナリを配置 |
| ~/temp | 一時ファイルを保存する |

### 2.3 `XDG Base` ディレクトリ

アプリケーションごとの設定やキャッシュは、`XDG Base Directory`に準拠して整理します。
これにより、設定ファイルを`GitHub`の`dotfiles`リポジトリで管理しやすくなります。

| ディレクトリ | 環境変数 | 用途 |
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

`Git`が使用する設定ファイル、データ用にあらかじめディレクトリを作成しておきます。

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

# create basic directory
mkdir -p ~/bin ~/temp

# create XDG Based directory
mkdir -p ~/.config ~/.local/share ~/.local/cache ~/.local/state
mkdir -p ~/.config/git ~/.local/share/git

# create workspaces directory
mkdir -p ~/workspaces/{develop,education,sandbox,temp}
```

## おわりに

本記事では、WSL 2環境での作業ディレクトリの設計と作成方法について説明した。XDG Base Directory の考え方を取り入れることで、設定ファイルやデータの管理がいっそう容易になり、効率的な開発環境が実現される。今後、同様のディレクトリ構成を活用することで、プロジェクト管理の統一化や作業効率の向上が期待できる。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [XDG Base Directory](https://wiki.archlinux.jp/index.php/XDG_Base_Directory):
  Arch Wiki による、`XDG Base Directory`仕様の説明
