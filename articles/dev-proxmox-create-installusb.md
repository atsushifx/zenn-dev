---
title: "Proxmoxのセットアップ: インストールUSBの作成"
emoji: "🏪"
type: "tech"
topics: [ "仮想化", "Proxmox", "pve", "環境構築", ]
published: false
---

## tl;dr

以下の手順で、`Proxmox`のインストールUSB を作成します。

1. `Proxmox` の Webサイトから `ISOイメージ` をダウンロード

2. インストーラ用USBメモリを用意し、PC に接続

3. `Rufus` を使用して `ISOイメージ` を USBメモリ に書き込み

以上で、インストールUSB が作成できます。

Enjoy!

:::message
USBメモリの代わりに、マイクロSDカードとカードリーダーも使用できます。

:::

## はじめに

この記事では、`Proxmox`のインストールUSB の作成方法を説明します。
`ISOイメージ`のダウンロードから `Rufus` を使用した作成手順まで、スクリーンショット付きで詳細に説明します。

## 1. インストールUSBの作成

### 1.1 `ISOイメージ`のダウンロード

以下の手順で、`ISOイメージ`をダウンロードします:

1. `Proxmox` のダウンロードページ <https://www.proxmox.com/en/downloads> にアクセス
   ![`Proxmox` - Downloads](/images/articles/proxmox-setup/ss-proxmox-download.png)

2. `Proxmox VE`ブロックの `Download` をクリックし、`ISOイメージ` をダウンロード

以上で、`ISOイメージ`のダウンロードは完了です。

### 1.2 `ISOイメージ`の書き込み

ダウンロードした`ISOイメージ`を `Rufus` で USBメモリに書き込み、インストールUSB を作成します。
`Rufus` は次のコマンドでインストール可能です。必要に応じて、インストール先を変更してください。

```powershell
winget install Rufus.Rufus --interactive --location "C:\app\utils\DiskUtils\rufus\"

```

:::message
`Rufus` を起動しやすくするために、インストール先を変更しています。

:::

以下の手順で、インストールUSBを作成します:

1. `Rufus` を起動します。以下の起動画面が表示されます。
   ![`Rufus`起動画面](/images/articles/proxmox-setup/ss-rufus-start.png)

2. `Rufus` にダウンロードした `ISOイメージ` を設定します。
   ![`ISOイメージ`設定](/images/articles/proxmox-setup/ss-rufus-isoset.png)

   `ISOイメージ` がハイブリッド形式のため、以下のダイアログが表示されます。`[OK]` をクリックしてダイアログを閉じます。
   ![書き込み方法ダイアログ](/images/articles/proxmox-setup/ss-rufus-dialog1.png)

3. `[スタート]`をクリックし、用意しておいた USBメモリに `ISOイメージ` を書き込みます。
   ![`Rufus`イメージ書き込み](/images/articles/proxmox-setup/ss-rufus-writing.png)

4. `[閉じる]`をクリックし、`Rufus` を終了します。

以上で、インストールUSB の作成は完了です。

## 2. 動作チェック

### 2.1 `インストールUSB`の起動チェック

以下の手順で、作成した インストールUSB が動作するか確認します:

1. サーバー用PC に インストールUSB を差し込み、起動します。

2. 起動画面の確認:
   `Proxmox`インストーラが起動し、以下の画面が表示されます。
   ![`Proxmox`インストーラ](/images/articles/proxmox-setup/ss-proxmox-installer-boot.png)

起動画面が表示されれば、インストーラは正常に動作しています。

## おわりに

この記事では、`Proxmox`インストールUSB の作成方法と動作確認を説明しました。
次回は、サーバー用PC に `Proxmox` をインストールする手順を説明します。

それでは、Happy Hacking!

## 重要キーワード

この記事での重要なキーワードを説明します。

- `Proxmox`:
  オープンソースの仮想化プラットフォーム

- `ISOイメージ`:
  オペレーティングシステムやソフトウェアのディスクイメージファイル

- `Rufus`:
  USBメモリに `ISOイメージ` を書き込むためのツール

- `winget`:
  `Windows Package Manager` のコマンドラインツール

- ハイブリッド形式:
  `BIOS` と `UEFI` の両方に対応した起動可能なディスクイメージ形式

- 仮想化:
  ハードウェア資源を抽象化し、複数の仮想マシンを実行する技術

## 参考資料

### Webサイト

- `Proxmox`: <https://proxmox.com/>
  `Proxmox`公式サイト

- `Rufus`: <https://rufus.ie/>
  `Rufus`公式サイト
