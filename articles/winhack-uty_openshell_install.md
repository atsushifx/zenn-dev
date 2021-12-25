---
title: "Windows: uty: open-shellをインストールする"
emoji: "🪟"
type: "tech"
topics: ["Windows", "環境構築", "hack", ]
published: true

---

## tl;dr

Windows に open-shell をインストールして、Windows 7 時代のスタートメニューを復活させる。

## はじめに

Windows も 11 までバージョンが上がりましたが、スタートメニューは Windows 7 のころのが使いやすいです。
そこで、open-shell をインストールして Windows 7 のときのスタートメニューを復活させます。

### Open-Shellについて

Open-Shell は、Windows 8 以降の環境で Windows XP や Windows 7 スタイルのスタートメニューを追加するツールです。  

もともとは"Classic Shell"というツールでしたが、Classic Shell は開発が止まってしまいました。
そのため、Classic Shell から fork して、新たに Open-Shell という名前で OSS として開発されました、
現在は、[GitHub](https://github.com/Open-Shell/Open-Shell-Menu)上で開発が続けられています。

## Open-Shellのインストール

### Open-Shellをダウンロードする

Open-Shell は GitHub の Open-Shell/Open-Shell-Menu からダウンロードできます。次の手順で、Open-Shell をダウンロードします。

1. Web サイトへのアクセス
   [GitHub/Open-Shell](https://github.com/Open-Shell/Open-Shell-Menu)にアクセスします

   ![Open-Shell](https://i.imgur.com/cEeOFaP.jpg)

2. release ファイルへのアクセス
   Download の項の[Downloadボタン](https://github.com/Open-Shell/Open-Shell-Menu/releases)をクリックします。Open-Shell インストーラのリンクが表示されます

3. Open-Shell のダウンロード
   release 中の Open-Shell のリンクをクリックします。Open-Shell をダウンロードします

以上で、Open-Shell のダウンロードは終了です。

### Open-Shellをインストールする

次の手順で Open-Shell をインストールします。

1. インストラーの起動
   Open-Shell インストーラを起動します

   ![Open-Shell Setup](https://i.imgur.com/GO8GBZS.jpg)

2. ライセンスの同意
   ライセンスを下までスクロールし、**License Agreement**に同意します

   ![End-User License Agreement](https://i.imgur.com/eNpzGOu.jpg)

3. セットアップオプション
   Custom Setup を選択し、Classic IE のチェックを外します。また、インストール先を"C:\Program Files\System\Open-Shell"に変更します

   ![Custom Setup](https://i.imgur.com/rrBGHen.jpg)

4. Open-Shell のインストール
   Open-Shell をインストールします
   終了ダイアログが表示されるので、**Finish**をクリックします

   ![Open-Shellセットアップ](https://i.imgur.com/GO8GBZS.jpg)

以上でインストールは終了です。
以後、**Windows**アイコンをクリックすると Windows 7 スタイルのメニューを表示します。~(Windows 11 ではアイコンをクリックしてもメニューは表示されません。`Replace Start Button`をチェックすると左下にボタンを表示します)~

## Open-Shellのカスタマイズ

### Open-Shellをカスタマイズする

Open-Shell は Open-Shell Menu settings アプリでカスタマイズします。
次の手順で、Open-Shell をカスタマイズします。

1. Settings アプリの起動
   スタートメニューから、*[Open-Shell Menu Setting]*を開きます

   ![Settings for Open-Shell Menu](https://i.imgur.com/clJ0E71.jpg)

2. Open-Shell のカスタマイズ
  [Start Menu Style]では、*[Windows 7 Style]*を選びます。同様に、[Replace Start Button]をチェックして、[スタート]ボタンを表示します

3. そのほかの設定
   必要ならそのほかの項目も設定します。[Show all settings]をチェックすると、さらに細かい設定もできます

4. 設定の終了
  [OK]をクリックして、設定を*"Open-Shell Menu"*に適用します

以上で、Open-Shell のカスタマイズは終了です。設定した項目は、XML ファイルとしてバックアップできます。

参考として、自分の設定を載せておきます。

[Menu-Settings.xml](https://gist.github.com/atsushifx/a58d47175ee91a0d9375b2ab179cd730)

@[gist](https://gist.github.com/atsushifx/a58d47175ee91a0d9375b2ab179cd730)
