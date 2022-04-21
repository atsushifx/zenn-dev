---
title: "nodejs: voltaの使い方をquickhackする"
emoji: "🐷"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["nodejs", "volta", "開発環境"]
published: false
---

## はじめに

nodejs 用の SCMツール`volta`を使ってみたので、いろいろと試してみました。

## voltaの動作

### voltaのインストール

`volta`は、各種ツールを自分の管理しているディレクトリに保存します。ツールの実行には、指定したディレクトリ内の shims ファイル~(いわゆるショートカット)~を通しておこないます。

ディレクトリの指定は、環境変数'`VOLTA_HOME`'を使用します。デフォルトのディレクトリは、macOS/Linux では`~/.volta`、Windows では`%LOCALAPPDATA%\\Volta\`となります~(インストーラーを使用した場合)~。
