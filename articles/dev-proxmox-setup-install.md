---
title: "Proxmox VE: インストール手順ガイド"
emoji: "🏪"
type: "tech"
topics: ["自宅サーバ", "環境構築", "Proxmox", "pve" ]
published: false
---

## はじめに

`atsushifx`です。今回は、自宅サーバーに`Proxmox VE`をインストールします。
前回までで、[BIOSの設定](dev-proxmox-setup-configbios)、[インストーラーの作成](dev-proxmox-setup-installmedia)が終わっていますので、今回は実際に`Proxmox VE`をインストールします。
スクリーンショット付きで手順を説明しますので、手順を確認しながらインストールできます。

:::message alert
**注意**:
記事で使用しているスクリーンショットは仮想環境(`Hyper-V`)で撮影されたものです。
そのため、物理サーバー環境でのインストール時には、表示内容が一部、異なる場合があります。
:::

## 1. 事前準備

### 1.1 ホスト名の設定

インストールした`Proxmox VE`に名前でアクセスできるよう、ルーターに静的アドレスとホスト名を設定しておきます。
ルーターの管理画面にアクセスし、静的`IPアドレス`と`ホスト名`を設定します。
例として、以下の設定を行います。
![静的IPアドレス設定](/images/articles/pve-install/ss-router-dhcp.jpg)

*静的`IPアドレス`設定*

| クライアント名 | `MACアドレス` | `IPアドレス` | `DNSサーバー` | `ホスト名` |
| --- | --- | --- | --- | --- |
| `Microsoft` | `00:15:5D:0E:1D:04` | `192.168.14.223` | (空白) | `pve` |

:::message alert
**注意**:
`Hyper-V`仮想マシンのため、クライアント名が`Microsoft`になっています。

:::

### 1.2 BIOS設定

PC の`BIOS`または`UEFI`の設定を変更して、USBメモリからの起動するように優先順位を変更します。
詳しい方法は、[インストーラー起動のためのBIOS設定](dev-proxmox-setup-configbios.md)を参照してください。

### 1.3 インストールメディア作成

`Proxmox VE`インストーラーを作成します。
作成方法は、[インストールメディア作成](dev-proxmox-setup-installmedia.md)を参照してください。

## 2. インストール

### 2.1 `Proxmox VE`のインストール手順

次の手順で、`Proxmox VE`をインストールします。

1. インストーラーの起動:
   `Proxmox VE`インストーラーを起動します。以下のタイトル画面が表示されます。
   ![`インストーラー`](/images/articles/pve-install/ss-01-installer.jpg)

   :::message
   **注**:
   事前準備で`BIOS`設定を変更しているため、挿入した`USBメモリ`内の`Proxmox VE`インストーラーが起動します。
   :::

2. インストーラーの選択
   タイトル画面で`Terminal UI`オプションを選択し、[Enter]キーを押します。
   インストーラーが起動します。
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
   パスワードは十分な複雑さをもったものにしてください。
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

    :::message alert
    **注意**:
    - PC からインストールメディア(USBメモリまたは`ISOイメージ`)を必ず取り外してください。
    - 取り外さない場合、再起動後にインストーラーが再び起動します。
    :::

    PC の再起動後、`Proxmox VE`が起動してログイン画面が表示されます。
    ![ログイン](/images/articles/pve-install/ss-10-boot.jpg)

11. `Webインターフェース`の確認:
    `Proxmox VE`が正常に起動した場合は、`Web`から`Proxmox VE`のコントロール画面にアクセスできます。
    <https://pve:8006> にアクセスし、Web インターフェイス画面が表示されるか確認します。

    :::message alert
    トラブルシューティング:
    Web インターフェイスに接続できない場合は、次の点を確認してください。

    - サーバが正常に起動しているか。
    - サーバにアクセスできるか (`ping <IPアドレス>`で接続を確認する)
    - ホスト名が解決できているか (`ping <ホスト名>` で接続を確認する)
    - `ホスト名`、`ポート`が正しいか (サーバの起動画面を確認する)
    - ファイアウォールの設定を確認する

    :::

    ![`Webインターフェイス`](/images/articles/pve-install/ss-11-web.jpg)

以上で、`Proxmox VE`のインストールは完了です。

## おわりに

以上で、`Proxmox VE`のインストールは終了です。
この記事では、インストール手順をスクリーンショット付きで解説しました。
この記事を参考にすれば、はじめての方でもスムーズに`Proxmox VE`をインストールできます。
次回からは、インストールした`Proxmox VE`の安全かつ効率的に使用する方法を説明します。

それでは、Happy Hacking!
