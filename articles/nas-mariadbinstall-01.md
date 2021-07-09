---
title: "NAS: asustor nasにMariaDBをインストールする"
emoji: "🍆"
type: "tech" # tech: 技術記事
topics: ["NAS","開発環境","MariaDB"]
published: false

---

# はじめに

asustor製のNASには、各種アプリ用のデータベースとしてMariaDBが提供されています。この記事では、NASの管理用アプリであるAppCentral上でMariaDBをインストールして、DBの起動／停止までを行います。 

# MariaDBのインストール (AppCentral上)

1. Web上のAppCentralにアクセスします
   ![AppCentral](https://storage.googleapis.com/zenn-user-upload/v4c4y3aq0yd0jhb1g9397h3keijz)
   
   


2. AppCentralからMariaDBを探し、選択します。
    ![MariaDB](https://storage.googleapis.com/zenn-user-upload/52hhzcpnzboyk70r4155nbc0votm)
    
    


3. [インストール]をクリックします。
    ![MariaDB](https://storage.googleapis.com/zenn-user-upload/uwxiqe4cbg1lrq0vnfsnndvi3zr9)
    
    


4. 以上でインストールは終了です。

# MariaDBの起動/停止/再起動

asustor nasでは、MariaDBの起動／停止をWeb上のAppCentralからおこないます。

1. Web上のAppcentralにアクセスします
    ![AppCentral](https://storage.googleapis.com/zenn-user-upload/v4c4y3aq0yd0jhb1g9397h3keijz)
    
    


2. 左サイドメニューの[インストール済み]を選択し、[MariaDB]を開きます。
     ![MariaDB](https://storage.googleapis.com/zenn-user-upload/y7okgbbbztmjxxq55yv8ty72or5w)
     
     


3. [MariaDB]のロゴの下に、実行／終了スライドスイッチがあります。ここを使って、MariaDBを起動／停止します。

   


4. MariaDBの再起動は、上記のスイッチを使います。MariaDBを終了後、再度MariaDBを実行することで再起動します。

   

