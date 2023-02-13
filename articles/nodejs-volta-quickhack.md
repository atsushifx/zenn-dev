---
title: "nodejs: voltaの使い方をquickhackする"
emoji: "🐷"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["nodejs", "volta", "開発環境"]
published: false
---

## はじめに

Node.js 用の SCM ツール`volta`を使ってみたので、いろいろと試してみました。

## voltaの動作

### voltaのインストール

  volta は、パッケージマネージャー`winget`および`scoop`に対応しています。
  scoop では、

  ``` :powershell
  PS > scoop install volta
  ```

  でインストールできます。
