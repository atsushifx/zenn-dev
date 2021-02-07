---
title: "NAS: asustor nasにMariaDBをインストールする"
emoji: "💻"
type: "tech" # tech: 技術記事
topics: ["NAS","開発環境","MariaDB"]
published: false

---

# MariaDBのインストール

## MariaDBのインストール (AppCentral上)

1. Web上のAppCentralにアクセスします
   ![AppCentral](images/screenshots/nas-appcentral-01.jpg)

2. AppCentralからMariaDBを探し、選択します。
    ![MariaDB](images/screenshots/nas-mariadb-01.jpg) 
    
3. [インストール]をクリックします。
    ![MariaDB](images/screenshots/nas-mariadb-02.jpg)

4. 以上でインストールは終了です。


## MariaDBの起動/停止/再起動

asustor nasでは、MariaDBの起動／停止をWeb上のAppCentralからおこないます。

1. Web上のAppcentralにアクセスします
    ![AppCentral](images/screenshots/nas-appcentral-01.jpg)


2. 左サイドメニューの[インストール済み]を選択し、[MariaDB]を開きます。
    ![MariaDB](images/screenshots/nas-mariadb-03.jpg)


3. [MariaDB]のロゴの下に、実行／終了スライドスイッチがあります。ここを使って、MariaDBを起動／停止します。


4. MariaDBの再起動は、上記のスイッチを使います。MariaDBを終了後、再度MariaDBを実行することで再起動します。

