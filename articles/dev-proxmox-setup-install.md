---
title: "Proxmoxのセットアップ - Proxmoxのインストール"
emoji: "🏨"
type: "tech"
topics: ["miniPC", "Proxmox", "pve", "インストール", ]
published: false
---

## はじめに

この記事では、`Proxmox`のインストールをスクリーンショット付きで解説します。

**注意**
スクリーンショットは、`Windows Hyper-V`で撮影しています。自分の動作環境に合わせて、適宜、変更して利用してください。

## 事前準備

### ホスト名の設定

インストールした`proxmox`に名前でアクセスできるよう、ルーターに静的アドレスとホスト名を設定しておきます。
設定は、次のようになります。

| MACアドレス | IPアドレス | DNSサーバー | ホスト名 |
| --- | --- | --- | --- |
| 00:15:5D:0E:1D:04 | 192.168.14.223 | (空白) | pve |

### 起動設定

`Proxmox`インストーラが起動するように、`USBメモリ`から起動するようにしておきます。

## インストール

### `Proxmox VE`のインストール

次の手順で、`Proxmox`をインストールします。

1. インストーラーの起動:
   PCを`Proxmox`インストーラーから起動します。タイトル画面が表示されます。
   ![`インストーラー`](/images/articles/pve-install/ss-01-installer.jpg)

2. インストーラーの選択:
   `Terminal UI`を選択し、インストラーを起動します。
  ![`ブート`](/images/articles/pve-install/ss-02-booting.jpg)

3. `EULA`の同意:
   `EULA`が表示されます。`I agree`を選択します。
  ![`EULA`](/images/articles/pve-install/ss-03-eula.jpg)

4.
