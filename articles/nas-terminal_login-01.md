---
title: "asustor NAS: NASにログインする"
emoji: "🍆"
type: "tech"
topics: ["NAS", "terminal", "ssh", "環境構築"]
published: true

---

## TL;DR

[sshサービスを有効化する](nas-terminal_init-01)によって、NAS へログインできるようになりました。
そこで、ターミナルソフト"rlogin"を使って NAS にログインします。

## rloginの設定

### サーバーの設定

rlogin に NAS サーバーの設定をし、ログインできるようにします。

1. rlogin を起動する
   Windows の[スタートメニュー]から rlogin を起動します
   ![rlogin](https://i.imgur.com/DdoEVa5l.jpg)

2. サーバー選択画面を開く
  [ファイル]-[サーバーに接続]として、[Server Select]画面を開きます
   ![Server Select](https://i.imgur.com/oYrXkFdl.jpg)

3. サーバー設定画面を開く
  [新規]をクリックし[サーバー設定]画面を開きます
   ![Server Entry](https://i.imgur.com/3u8egrR.jpg)

4. サーバーを設定する
   次のようにサーバーを設定し、[OK]をクリックします

   |設定項目|設定|備考|
   |:----|:----|:----|
   |エントリー|agartha| agartha   |NASのホスト名を入れておきます|
   |プロトコル|ssh||
   |ホスト名| agartha  |NASのホスト名|
   |TCPポート|ssh||
   |ログインユーザー名| atsushifx |NASのWebコンソールに入れるユーザー名|
   |パスワードorパスフレーズ|***|NASのWebコンソールに入れるパスワード|
   |パスワード/フレーズを接続時に入力|チェックする||
   |TERM環境変数|ANSI||
   |デフォルト文字セット|UTF-8||

以上で、サーバの設定は終了です。

## NASへのログイン

つぎのようにして、rlogin で NAS にログインします。

1. rlogin を起動する
   Windows の[スタートメニュー]から rlogin を起動します
   ![rlogin](https://i.imgur.com/DdoEVa5l.jpg)

2. サーバー選択画面を開く
  [ファイル]-[サーバーに接続]として、[Server Select]画面を開きます
   ![Server Select](https://i.imgur.com/FUCaiDH.jpg)

3. サーバーにログインする
   接続したいサーバ~(`agartha`)~を選び[OK]をクリックします
   サーバーにログインします

   ![agartha login](https://i.imgur.com/T3RbWzQ.jpg)

4. 以上で、NAS へのログインは終了です
