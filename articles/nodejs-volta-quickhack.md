---
title: "nodejs: voltaの使い方をquickhackする"
emoji: "🐷"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["nodejs", "volta", "開発環境"]
published: false
---

## はじめに

nodejs用のSCMツール`volta`を使ってみたので、いろいろと試してみました。

## voltaの動作

### voltaのインストール

  voltaは、パッケージマネージャー`winget`および`scoop`に対応しています。
  scoopでは、

  ``` :powershell
  PS > scoop install volta
  ```

  でインストールできます。
