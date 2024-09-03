---
title: "Proxmoxのセットアップ: インストールUSBの作成"
emoji: "🏨"
type: "tech"
topics: [ "仮想化", "proxmox", "pve", "環境構築", ]
published: false
---

## tl;dr

以下の手順で、`Proxmox`のインストールUSBを作成できます。

1. `Proxmox`のWebサイトから、`ISO installer`をダウンロードする
2. インストールUSB用のUSBメモリ (`microSD`+カードリーダーでも可) を用意し、PCに接続する
3. `USB`メモリ書き込みツール`rufus`を試用して、`ISO installer`をUSBメモリに書き込む

以上で、インストールUSBが作成できます。
Enjoy!

## `インストールUSB`の作成

### `ISO installer`のダウンロード

以下の手順で、`ISO installer`をダウンロードします。

1. `proxmox`のダウンロードページ[<https://www.proxmox.com/en/downloads>](https://www.proxmox.com/en/downloads)にアクセスする。
   ![`proxmox` - Downloads](/images/articles/proxmox-setup/ss-proxmox-download.png)

2. `Proxmox VE`ブロックの`Download`をクリックし、`isoイメージ`をダウンロードする。

以上で、`ISO installer`のダウンロードは終了です。

### `ISOイメージ`の書き込み

ダウンロードした`ISOイメージ`を、`rufus`を使ってUSBに書き込んでインストールUSBを作成します。
`rufus`は、次のコマンドでインストールできます。

```powershell
winget install Rufus.Rufus --interactive --location C:\app\utils\DiskUtils\rufus\

```

以下の手順で、インストールUSBを作成します。

1. `rufus`を起動する:
   `rufus`を起動します。起動画面が表示されます。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-start.png)

2. `rufus`に`ISOイメージ`を設定する:
   `rufus`にダウンロードした`ISOイメージ`を設定します。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-isoset.png)

   このとき、以下のダイアログが表示されます。`[OK]`をクリックします。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-dialog1.png)

3. `ISOイメージ`を`USBメモリ`に書き込む:
   `[スタート]`をクリックし、用意しておいたUSBメモリに`ISOイメージ`を書き込みます。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-writing.png)

4. `rufus`を終了する:
   `[閉じる]`をクリックし、`rufus`を終了します。

以上で、`インストールUSB`の作成は完了です。

## 動作チェック

### `インストールUSB`の起動チェック

作成した`インストールUSB`が正常に動作するかチェックします。

以下の手順で、動作チェックします。

1. PCの電源を入れる:
   `proxmox`インストール用のPC (今回は、`Speed S5 Pro`)に`インストールUSB`を差し、電源スイッチをOnにします。

2. 起動画面の確認
   `proxmox`インストーラが起動し、以下の画面が表示されます。
   ![`proxmox`インストーラ](/images/articles/proxmox-setup/ss-proxmox-installer-boot.png)

上記のように、起動画面が表示されれば、インストーラーは正常に動作しています。

## おわりに

この記事では、`proxmox`のインストールUSB`の作成方法から、`インストーラUSB`の動作確認までを説明しました。
次からは実際に`proxmox`をインストールする手順を説明します。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `PROXMOX`: [https://proxmox.com/]<https://proxmox.com/>
  `proxmox`公式Webサイト

- `Rufus`: [https://rufus.ie/]<https://rufus.ie/>
  `インスト-ルUSB`作成ツール`Rufus`の公式サイト
