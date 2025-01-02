---
title: "Proxmoxのセットアップ - Proxmoxのインストール"
emoji: "🏨"
type: "tech"
topics: ["miniPC", "Proxmox", "pve", "インストール", ]
published: false
---

## はじめに

この記事では、`Proxmox VE`のインストール方法をスクリーンショット付きで解説します。

**注意**:
スクリーンショットは、`Windows Hyper-V`で撮影しています。自分の動作環境に合わせて、読み替えて利用してください。

## 事前準備

### ホスト名の設定

インストールした`Proxmox VE`に名前でアクセスできるよう、ルーターに静的アドレスとホスト名を設定しておきます。
設定は、次のようになります。

| `MACアドレス` | `IPアドレス` | `DNSサーバー` | `ホスト名` |
| --- | --- | --- | --- |
| `00:15:5D:0E:1D:04` | `192.168.14.223` | (空白) | `pve` |

上記の設定によって、ブラウザーから`pve`で`Proxmox`にアクセスできます。

### 起動設定

PC の設定を変更し、電源オン時に`Proxmox VE`インストーラーが起動するようにします。

## インストール

### `Proxmox VE`のインストール

次の手順で、`Proxmox VE`をインストールします。

1. インストーラーの起動:
   PC を`Proxmox VE`インストーラーから起動します。タイトル画面が表示されます。
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
   管理者(`root`)のパスワード、およびEメールを設定します。
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

10. `Proxmox VE`の起動:
   インストールが正常に終了した場合、PCが再起動し、ログイン画面が表示されます。
   ![ログイン](/images/articles/pve-install/ss-10-boot.jpg)

   **注意**
   インストーラーがそのままの場合は、再度、`Proxmox`インストール画面になります。再起動前に、インストールメディアを取り外しておいてください。

11 `Webインターフェース`の確認:
   `Proxmox VE`が正常に起動した場合は、`Web`から`Proxmox VE`のコントロール画面にアクセスできます。
   <https://pve:8006> にアクセスし、次の画面が表示されれば、正常に動作しています。
  ![`Webインターフェイス`](/images/articles/pve-install/ss-11-web.jpg)

以上で、`Proxmox VE`のインストールは完了です。
