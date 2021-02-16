title: "asustor NAS : sshログインを設定する"
emoji: "🍆"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["NAS", "terminal", "ssh", "開発環境"]
published: false

# asustor NAS: sshログインを設定する



## TL;DR

asustor NASにはsshサーバがついている。そこで、sshサービスを有効化してターミナルソフトでログインできるようにする。



## sshサービスの有効化



以下の手順でsshサービスを有効化します

1. NASのWebコンソールを開きます。

   ![Webコンソール](https://i.imgur.com/GIKo3df.jpg)

   

2. [システム管理]-[サービス]として、[サービス]ペーンを開きます。

   ![サービス](https://i.imgur.com/lyttOnR.jpg)

3. [端末]を選択して[端末]ペーンを開きます。その後、[sshサービスを有効にする]をチェックして、[適用]をクリックします。
   ![端末](https://i.imgur.com/JhhlAAL.jpg)
   
   
   
4. 以上で、sshサービスの有効化は完了です。

   