---
title: "Windows: wsl: wsl2をインストールする"
emoji: "🐧"
type: "tech"
topics: [Windows, Linux, wsl, 開発環境, カスタマイズ]
published: true

---

## tl;dr

wsl は Windows ネイティブで使える Linux 環境です。
現在では、コマンドラインから wsl コマンドを実行することで、自動的に環境を構築できます。

## はじめに

`wsl` ~(`Windows Subsystem for Linux`)は、Windows 上で Linux 系 OS を動かすための仕組みです。
現在では、wsl コマンドですべての環境構築ができるようになり、利用が簡単になりました。

### wslのインストール

ここでは、`wsl 2`をインストールします。
次の手順で、``wsl``をインストールします。

1. `Terminal`の起動

   管理者権限で、``Windows Terminal``を起動します

   ![Windows Terminal](https://i.imgur.com/vyQ1TKv.jpg)

2. wsl のインストール

   `wsl --install`と入力し、wsl2 のインストールを開始します

   ![Windows Terminal](https://i.imgur.com/aQov7it.jpg)

3. wsl のインストール: ~(途中経過)~

   wsl の各モジュールがインストールされます

   ![Windows Terminal](https://i.imgur.com/q708dPC.jpg)

4. Windows の再起動

   wsl を使うには"仮想マシンプラットフォーム"などの Windows の仮想化機能を使う必要があります。
   メッセージが表示されるので、`Windows`を再起動します

5. Ubuntu の起動

   wsl が正常にインストールできていれば、次に Linux ディストリビューション`Ubuntu`をインストールできます。
   Ubuntu をインストールすると、ubuntu のコンソール画面が表示されます

   ![Ubuntuコンソール](https://i.imgur.com/65zxdFT.jpg)

6. Linux ユーザーの作成

   画面のメッセージに従い、ユーザーを作成します

   ![Welcome to Ububtu](https://i.imgur.com/AOQE334.jpg)

7. コンソールの確認

   `Windows Terminal`を起動します。`ubuntu`のコンソール画面が追加されています

   ![Windows Terminal - ubuntu](https://i.imgur.com/zadrX7o.jpg)

以上で、wsl のインストールは終了です。
