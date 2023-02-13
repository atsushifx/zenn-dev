---
title: "Windows: 開発環境: 自分のWindowsディレクトリ構成(2022年版)"
emoji: "⚒️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Windows", "開発環境", "環境構築", "カスタマイズ" ]
published: false
---

## tl;dr

  Windows 開発環境用のディレクトリ構成です。

- ファイル処理はファイラー。
- コマンドは`Win+R`でキー入力
- 細かい機能は Windows Terminal 上で

というのが、前提です。

## はじめに

前提でわかるとおり、基本的にターミナルからコマンドをキー入力して作業します。
リポジトリ管理は素のgitを使い、Visual Source Code などの IDE も端末から起動します。

ディレクトリの作成やファイルの削除はファイラーを使っています。`Wz Filer`という昔から使っている 2画面ファイラーで、スペースキーで選択したファイルを一括削除やコピーできるのが楽で、手放せません。

さらに、コンテキストメニューにシンボリック作成やパス名のコピーなどの拡張機能をいれているので、ファイラーからリンクの作成などができるようになっています。

## ディレクトリ構成

### ディレクトリ構成図

Windowsルートとユーザーごとのディレクトリ構成図をおいておきます。

- Windowsルートツリー
  @[gist](https://gist.githubusercontent.com/atsushifx/c64fcd83a902fd1b018e5776c71cecf3/raw/bb12ec1d8f0379e7c36af85ccec5f6d06437962c/root.tree)

- ユーザー別ツリー
  @[gist](https://gist.githubusercontent.com/atsushifx/c64fcd83a902fd1b018e5776c71cecf3/raw/bb12ec1d8f0379e7c36af85ccec5f6d06437962c/user.tree)

それぞれのディレクトリーの役割については、後の章で説明します。
