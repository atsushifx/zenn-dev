---
title: "NAS: asustor nasにMariaDBをインストールする"
emoji: "🍆"
type: "tech"
topics: ["NAS","開発環境", "MySQL", "MariaDB"]
published: true

---

## はじめに

asustor NAS には、各種アプリ用のデータベースとして MariaDB が提供されています。この記事では、管理用アプリ`App Central`を使って`MariaDB` をインストールし、DB の起動／停止までを行います。

## MariaDBのインストール

### MariaDB のインストール

`App Central`を使って、MariaDB をインストールします。

1. Web 上の App Central にアクセスします
  ![AppCentral](https://storage.googleapis.com/zenn-user-upload/v4c4y3aq0yd0jhb1g9397h3keijz)

2. App Central から MariaDB を探し、選択します
  ![MariaDB](https://storage.googleapis.com/zenn-user-upload/52hhzcpnzboyk70r4155nbc0votm)

3. [インストール]をクリックします
  ![MariaDB](https://storage.googleapis.com/zenn-user-upload/uwxiqe4cbg1lrq0vnfsnndvi3zr9)

4. 以上でインストールは終了です。

### MariaDBの起動/停止/再起動

asustor nas では、MariaDB の起動／停止を Web 上の App Central からおこないます。

1. Web 上の App Central にアクセスします
  ![AppCentral](https://storage.googleapis.com/zenn-user-upload/v4c4y3aq0yd0jhb1g9397h3keijz)

2. 左サイドメニューの[インストール済み]を選択し、[MariaDB]を開きます
  ![MariaDB](https://storage.googleapis.com/zenn-user-upload/y7okgbbbztmjxxq55yv8ty72or5w)

3. [MariaDB]のロゴの下に、実行／終了スライドスイッチがあります。ここを使って、MariaDB を起動／停止します
  
4. MariaDB の再起動は、上記のスイッチを使います。MariaDB を終了後、再度 MariaDB を実行することで再起動します
