---
title: "Proxmoxのセットアップ: インストールUSBの作成"
emoji: "🏨"
type: "tech"
topics: [ "仮想化", "proxmox", "pve", "環境構築", ]
published: false
---

## tl;dr

以下の手順で、`Proxmox`のインストールUSBを作成できます。

1. `Proxmox`のWebサイトから、`ISOイメージ`をダウンロードする
2. インストールUSB用のUSBメモリを用意し、PCに接続する
3. `USB`メモリ書き込みツール`rufus`を試用して、`ISOイメージ`をUSBメモリに書き込む

以上で、インストールUSBが作成できます。
Enjoy!

:::message
USBメモリの代わりに、マイクロSDカードとカードリーダーを試用できます。
:::

## はじめに

この記事では、`Proxmox`用のインストールUSBの作成方法を説明します。
`ISOイメージ`のダウンロード方法から、`Rufus`を用いたUSBメモリの作成までを、スクリーンショットを併用して　解説しています。

## 1. インストールUSBの作成

### 1.1 `ISOイメージ`のダウンロード

以下の手順で、`ISOイメージ`をダウンロードします。

1. `proxmox`のダウンロードページ[<https://www.proxmox.com/en/downloads>](https://www.proxmox.com/en/downloads)にアクセスする。
   ![`proxmox` - Downloads](/images/articles/proxmox-setup/ss-proxmox-download.png)

2. `Proxmox VE`ブロックの`Download`をクリックし、`ISOイメージ`をダウンロードする。

以上で、`ISOイメージ`のダウンロードは終了です。

### 1.2 `ISOイメージ`の書き込み

ダウンロードした`ISOイメージ`を、`Rufus`を使ってUSBに書き込み、インストールUSBを作成します。
`Rufus`は、次のコマンドでインストールできます。

```powershell
winget install Rufus.Rufus --interactive --location C:\app\utils\DiskUtils\rufus\

```

:::message
`Rufus`を起動しやすくするため、ツール用のフォルダー`c:\app`下にインストールしています。

:::

以下の手順で、インストールUSBを作成します。

1. `rufus`を起動します。起動画面が表示されます。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-start.png)

2. `rufus`にダウンロードした`ISOイメージ`を設定します。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-isoset.png)

   `ISOイメージ`がハイブリッド形式のため、以下のダイアログが表示されます。`[OK]`をクリックしてダイアログを閉じます。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-dialog1.png)

3. `[スタート]`をクリックし、用意しておいたUSBメモリに`ISOイメージ`を書き込みます。
   ![`rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-writing.png)

4. `[閉じる]`をクリックし、`rufus`を終了します。

以上で、`インストールUSB`の作成は完了です。

## 2. 動作チェック

### 2.1 `インストールUSB`の起動チェック

以下の手順で、作成したインストールUSBが動作するかチェックします。

1. PCの電源を入れる:
   サーバー用PC (今回は、`Speed S5 Pro`)に`インストールUSB`を差し、電源スイッチをOnにします。

2. 起動画面の確認:
   `proxmox`インストーラが起動し、以下の画面が表示されます。
   ![`proxmox`インストーラ](/images/articles/proxmox-setup/ss-proxmox-installer-boot.png)

上記のように起動画面が表示されれば、インストーラーは正常に動作しています。

## おわりに

この記事では、`proxmox`のインストールUSB`の作成方法から、`インストーラUSB`の動作確認までを説明しました。
次回は、サーバー用PCに。`proxmox`をインストールする手順を説明します。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `PROXMOX`: [https://proxmox.com/]<https://proxmox.com/>
  `proxmox`公式Webサイト

- `Rufus`: [https://rufus.ie/]<https://rufus.ie/>
  `インスト-ルUSB`作成ツール`Rufus`の公式サイト
