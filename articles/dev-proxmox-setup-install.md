---
title: "Proxmox VE: インストール手順"
emoji: "🏪"
type: "tech"
topics: ["自宅サーバ", "環境構築", "Proxmox", "pve" ]
published: false
---

## はじめに

`atsushifx`です。
[BIOSの設定](dev-proxmox-setup-configbios)、[インストーラーの作成](dev-proxmox-setup-installmedia)に続き、`Proxmox VE`のインストール手順を説明します。
この記事では、`Proxmox VE`のインストール手順をスクリーンショット付きで解説しま。

**注意**:
スクリーンショットは、`Windows Hyper-V`で撮影しています。実際のサーバーにインストールする場合、表示内容が異なる可能性があります。

## 1. 事前準備

### 1.1 ホスト名の設定

インストールした`Proxmox VE`に名前でアクセスできるよう、ルーターに静的アドレスとホスト名を設定しておきます。
以下のように設定することで、ブラウザーからホスト名`pve`でアクセスできるようになります。

| `MACアドレス` | `IPアドレス` | `DNSサーバー` | `ホスト名` |
| --- | --- | --- | --- |
| `00:15:5D:0E:1D:04` | `192.168.14.223` | (空白) | `pve` |

上記の設定によって、ブラウザーからホスト名`pve`で`Proxmox`にアクセスできます。

### 1.2 BIOS設定

PC の設定を変更し、電源オン時に`Proxmox VE`インストーラーが起動するようにします。
詳しい方法は、[インストーラー起動のためのBIOS設定](dev-proxmox-setup-configbios.md)を参照してください。

### 1.3 インストールメディア作成

`Proxmox VE`インストーラーを作成します。
作成方法は、[インストールメディア作成](dev-proxmox-setup-installmedia.md)を参照してください。

## 2. インストール

### 2.1 `Proxmox VE`のインストール手順

次の手順で、`Proxmox VE`をインストールします。

1. インストーラーの起動:
  PCのBIOS設定を変更し、`USBメモリ`上の`Proxmox VE`インストーラーを起動します。
  PCの起動後、以下のタイトル画面が表示されます。
   ![`インストーラー`](/images/articles/pve-install/ss-01-installer.jpg)

2. インストーラーの選択
   `Terminal UI`を選択し、インストーラーを起動します。
   ![`ブート`](/images/articles/pve-install/ss-02-booting.jpg)

3. `EULA`の同意
   `EULA`が表示されます。`I agree`を選択します。
   ![`EULA`](/images/articles/pve-install/ss-03-eula.jpg)

4. インストールディスクの設定:
   `Proxmox VE`をインストールするディスクを選択します。
   ![インストール先](/images/articles/pve-install/ss-04-disk.jpg)

5. リージョンの設定:
   国、タイムゾーン。およびキーボードレイアウトを設定します。
   ![リージョン設定](/images/articles/pve-install/ss-05-region.jpg)
   今回は、次のように設定しました。

   | 項目 | 設定 |
   | --- | --- |
   | Country | Japan |
   | Timezone | Asia/Tokyo |
   | Keyboard layout | Japanese |

6. 管理者の設定:
   管理者(`root`)のパスワード、および`Eメール`を設定します。
   ![管理者設定](/images/articles/pve-install/ss-06-root.jpg)

7. ネットワークの設定:
   `Proxmox VE`のホスト名、`IPアドレス`などを設定します。
   事前準備で設定済みの場合、ホスト名などの項目は自動的に設定されます。
   ![ネットワーク設定](/images/articles/pve-install/ss-07-network.jpg)

   今回の場合、次のようになります。

   | 項目 | 設定 | 備考 |
   | --- | --- | --- |
   | `Hostname` | `pve.local` | |
   | `IPアドレス` | `192.168.14.223 / 24` | |
   | `Gateway` | `192.168.14.254` | ルーターの`IPアドレス` |
   | `DNS` | `192.168.1.1` | ルーターの設定した`DNS`の`IPアドレス` |

8. 設定の確認:
   ここまでの設定が表示されます。問題がなければ、`Install`を選択します。
   ![設定確認](/images/articles/pve-install/ss-08-check.jpg)

9. インストールの実行:
   インストールを実行します。
   ![インストール](/images/articles/pve-install/ss-09-installing.jpg)

10. `Proxmox VE`の再起動:
    インストールが正常に終了した場合、PC が再起動します。
    **再起動前に、PC からインストールメディアを取り外してください**

    PCの 再起動後、`Proxmox VE`が起動してログイン画面が表示されます。
    ![ログイン](/images/articles/pve-install/ss-10-boot.jpg)

    **注意**
    ログイン画面ではなくインストーラーのタイトル画面が表示される場合があります。この場合は、インストールメディアをPCから取り外した後、PCを再起動してください。

11. `Webインターフェース`の確認:
    `Proxmox VE`が正常に起動した場合は、`Web`から`Proxmox VE`のコントロール画面にアクセスできます。
    <https://pve:8006> にアクセスし、次の画面が表示されれば、正常に動作しています。
    ![`Webインターフェイス`](/images/articles/pve-install/ss-11-web.jpg)

以上で、`Proxmox VE`のインストールは完了です。

## おわりに

以上で、`Proxmox VE`のインストールは終了です。
この記事では、インストール手順をスクリーンショット付きで解説しました。
BIOSの設定やインストーラーの作成についても触れることで、初心者でも問題なく`Proxmox VE`をインストールできるようになります。
次回からは、インストールした`Proxmox VE`の管理やカスタマイズを行い、仮想マシンの構築もします。

それでは、Happy Hacking!
