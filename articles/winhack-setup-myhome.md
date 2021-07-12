---
title: "環境変数'HOME'を上書きして、オレオレ設定フォルダをつくる"
emoji: "🪟"
type: "tech"
topics: [Windows,個人開発,開発環境,カスタマイズ,hack]
published: false
---

# はじめに

Windows環境で普通にbashやvimを使うと、`Users/xxxxx/`下に大量にdotfileをつくられます*(ヒストリーなど)*。

邪魔なので、環境変数"`HOME`"を上書きすることで上記のファイルを設定フォルダ内にまとめることにしました。



# 設定フォルダについて

フォルダ名は、`.config`にしました。確かscoopが自身の情報を格納するために使っていたかがします。しかも、dotfileで最初の方に出てくるので使い勝手がいいのです。

現状、以下のようなディレクトリツリーで運用しています。

```shell
.config
  ├─ .config
  │    └─ git
  │        ignore ... globalな.gitignore
  ├─ .ssh
  └─ scoop
  .git-crendicials
  .gitconfig
```











