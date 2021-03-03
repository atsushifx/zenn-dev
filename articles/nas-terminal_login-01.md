---

title: "asustor NAS : NASにログインする"
emoji: "🍆"
type: "tech" # tech: 技術記事
topics: ["NAS", "terminal", "ssh", "開発環境"]
published: true

---
# asustor NAS: NASにログインする

## TL;DR

sshでNASにログインできるようになったので、ターミナルソフト"rlogin"を使ってNASにログインします


## rloginの設定
### サーバーの設定
rloginにNASサーバーについて設定し、ログインできるようにします。

1. rloginを起動する  
    Windowsの[スタートメニュー]からrloginを起動します。
    
   ![rlogin](https://i.imgur.com/DdoEVa5l.jpg)

2. サーバー選択画面を開く  
   [ファイル]-[サーバーに接続]として、[Server Select]画面を開きます。 
   
   ![Server Select](https://i.imgur.com/oYrXkFdl.jpg)

3. サーバー設定画面を開く  
   [新規]をクリックし[サーバー設定]画面を開きます。
   
   ![Server Entry](https://i.imgur.com/3u8egrR.jpg)

4. サーバーを設定する  
    次のようにサーバーを設定し、[OK]をクリックします。
    |設定項目|設定|備考|
    |:----|:----|:----|
    |エントリーnasagartha| agartha   |NASのホスト名を入れておきます|
    |プロトコル|ssh||
    |ホスト名| agartha  |NASのホスト名|
    |TCPポート|ssh||
    |ログインユーザー名| atsushifx |NASのWebコンソールに入れるユーザー名|
    |パスワードorパスフレーズ|NASのWebコンソールに入れるパスワード||
    |パスワード/フレーズを接続時に入力|チェックする||
    |TERM環境変数|ANSI||
    |デフォルト文字セット|UTF-8||
    
    ![サーバー設定](https://i.imgur.com/5SGHnIP.jpg)

5. 以上で、サーバの設定は終了です。

## NASへのログイン
つぎのようにして、rloginでNASにログインします。

1. rloginを起動する  
    Windowsの[スタートメニュー]からrloginを起動します。
    
   ![rlogin](https://i.imgur.com/DdoEVa5l.jpg)

2. サーバー選択画面を開く 
   [ファイル]-[サーバーに接続]として、[Server Select]画面を開きます。
   
    ![Server Select](https://i.imgur.com/FUCaiDH.jpg)
   
3.  サーバーにログインする
   接続したいサーバ<sub>(ここでは'agartha')</sub>を選び[OK]をクリックします。
   サーバーにログインします。
   
   ![agartha login](https://i.imgur.com/T3RbWzQ.jpg)

4. 以上で、NASへのログインは終了です。
