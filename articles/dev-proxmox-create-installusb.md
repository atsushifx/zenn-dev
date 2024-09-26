---
title: "Proxmoxのセットアップ: インストールUSBの作成"
emoji: "🏪"
type: "tech"
topics: [ "仮想化", "Proxmox", "pve", "環境構築", ]
published: false
---

## tl;dr

以下の手順で、`Proxmox`のインストールUSBを作成できます。

1. `Proxmox`のWebサイトから`ISOイメージ`をダウンロード

2. インストールUSB用USBメモリを用意してPCに接続

3. `Rufus`を使用して`ISOイメージ`をUSBメモリに書き込み

以上で、インストールUSBが作成できます。
Enjoy!

:::message
USBメモリの代わりに、マイクロSDカードとカードリーダーが使用可能
:::

## はじめに

この記事では、`Proxmox`用のインストールUSBの作成方法を説明します。
`ISOイメージ`のダウンロードから`Rufus`によるインストールUSBの作成まで、手順をスクリーンショット付きで詳しく解説します。

## 1. インストールUSBの作成

### 1.1 `ISOイメージ`のダウンロード

以下の手順で、`ISOイメージ`をダウンロードします:

1. `Proxmox`のダウンロードページ[<https://www.Proxmox.com/en/downloads>](https://www.Proxmox.com/en/downloads)にアクセスする。
   ![`Proxmox` - Downloads](/images/articles/Proxmox-setup/ss-Proxmox-download.png)

2. `Proxmox VE`ブロックの`Download`をクリックし、`ISOイメージ`をダウンロードする。

以上で、`ISOイメージ`のダウンロードは終了です。

### 1.2 `ISOイメージ`の書き込み

ダウンロードした`ISOイメージ`を`Rufus`でUSBメモリに書き込み、インストールUSBを作成します。
`Rufus`は次のコマンドでインストール可能です。

```powershell
winget install Rufus.Rufus --interactive --location C:\app\utils\DiskUtils\rufus\

```

:::message
Rufusを起動しやすくするためにインストール先を変更。
インストール先は環境に合わせて変更可能。

:::

以下の手順で、インストールUSBを作成します:

1. `Rufus`を起動します。以下の起動画面が表示されます。
   ![`Rufus`起動画面](/images/articles/Proxmox-setup/ss-rufus-start.png)

2. `Rufus`にダウンロードした`ISOイメージ`を設定します。
   ![`ISOイメージ`設定](/images/articles/Proxmox-setup/ss-rufus-isoset.png)

   `ISOイメージ`がハイブリッド形式のため、以下のダイアログが表示されます。`[OK]`をクリックしてダイアログを閉じます。
   ![書き込み方法ダイアログ](/images/articles/Proxmox-setup/ss-rufus-dialog1.png)

3. `[スタート]`をクリックし、用意しておいたUSBメモリに`ISOイメージ`を書き込みます。
   ![`Rufus`イメージ書き込み](/images/articles/Proxmox-setup/ss-rufus-writing.png)

4. `[閉じる]`をクリックし、`Rufus`を終了します。

以上で、`インストールUSB`の作成は完了です。

## 2. 動作チェック

### 2.1 `インストールUSB`の起動チェック

以下の手順で、作成したインストールUSBが動作するかチェックします:

1. サーバー用PCにインストールUSBを差し、起動します。

2. 起動画面の確認:
   `Proxmox`インストーラが起動し、以下の画面が表示されます。
   ![`Proxmox`インストーラ](/images/articles/Proxmox-setup/ss-Proxmox-installer-boot.png)

上記のように起動画面が表示されれば、インストーラーは正常に動作しています。

## おわりに

この記事では、`Proxmox`のインストールUSBの作成方法から動作確認までを説明しました。
次回は、サーバー用PCに`Proxmox`をインストールする手順を説明します。

それでは、Happy Hacking!

## 重要キーワード

この記事での重要なキーワードを説明します。

- `Proxmox`:
  オープンソースの仮想化プラットフォーム

- `ISOイメージ`:
  オペレーティングシステムやソフトウェアのディスクイメージファイル

- `Rufus`:
  USBメモリに`ISOイメージ`を書き込むためのツール

- `winget`:
  `Windows Package Manager`のコマンドラインツール

## 参考資料

### Webサイト

- `Proxmox`: [https://proxmox.com/]<https://proxmox.com/>
  `Proxmox`公式サイト

- `Rufus`: [https://rufus.ie/]<https://rufus.ie/>
  `Rufus`公式サイト
