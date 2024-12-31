---
title: "Proxmoxのセットアップ - Proxmoxのインストール"
emoji: "🏨"
type: "tech"
topics: ["miniPC", "Proxmox", "pve", "インストール", ]
published: false
---

## はじめに

この記事では、`Proxmox`のインストールをスクリーンショット付きで解説します。

**注意**:
スクリーンショットは、`Windows Hyper-V`で撮影しています。自分の動作環境に合わせて、読み替えて利用してください。

## 事前準備

### ホスト名の設定

インストールした`proxmox`に名前でアクセスできるよう、ルーターに静的アドレスとホスト名を設定しておきます。
設定は、次のようになります。

| `MACアドレス` | `IPアドレス` | `DNSサーバー` | `ホスト名` |
| --- | --- | --- | --- |
| `00:15:5D:0E:1D:04` | `192.168.14.223` | (空白) | `pve` |

上記の設定によって、ブラウザーから`pve`で`Proxmox`にアクセスできます。

### 起動設定

PCの設定を変更し、電源On時に`Proxmox`インストーラーが起動するようにします。

## インストール

### `Proxmox VE`のインストール

次の手順で、`Proxmox VE`をインストールします。

1. インストーラーの起動
   PCを`Proxmox`インストーラーから起動します。タイトル画面が表示されます。
   ![`インストーラー`](/images/articles/pve-install/ss-01-installer.jpg)

2. インストーラーの選択
   `Terminal UI`を選択し、インストーラーを起動します。
   ![`ブート`](/images/articles/pve-install/ss-02-booting.jpg)

3. `EULA`の同意
   `EULA`が表示されます。`I agree`を選択します。
   ![`EULA`](/images/articles/pve-install/ss-03-eula.jpg)
