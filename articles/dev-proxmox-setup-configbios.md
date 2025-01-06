---
title: "Proxmox VE: インストーラー起動のためのBIOS設定"
emoji: "🏠"
type: "tech"
topics: [ "自宅サーバー", "環境構築", "Windows", "UEFI", "BIOS" ]
published: false
---

## はじめに

`atsushifx`です。
この記事では、PC を`Proxmox VE`インストーラーから起動させるための`BIOS`設定手順を解説します。

## `UEFI`/`BIOS`設定方法

`Proxmox VE`インストーラーが起動するためには、`UEFI`/`BIOS`の設定を変更する必要があります。

### `UEFI`/`BIOS`設定画面の起動

`UEFI`または`BIOS`を設定するには、PCの電源を入れた直後に特定のキー (例: `F2`、`DEL`) を押して設定画面にアクセスします。
以下の手順で、`UEFI`/`BIOS`設定画面にアクセスします。

1. PC の電源を切る:
  [スタート]-[シャットダウン]を選択して、PC の電源を切ります。

2. PC の電源を入れる:
   電源スイッチを押して、PC を起動します。

3. 設定画面起動:
   PC の起動直後(ロゴ画面が表示されている間)に、特定のキー (`F2`、`DEL`など)を押します。
   ![ロゴ画面](/images/articles/pve-bios/ss-boot-logo.jpg)
   *ロゴ画面*

4. 設定画面へ移動:
   `UEFI`または`BIOS`の設定画面が表示されます。
   ![`BIOS`](/images/articles/pve-bios/ss-bios-main.jpg)
   *BIOS画面*

### `Windows 11`からの設定画面の起動

`Windows 11`の場合、`OS`の機能で`UEFI`設定画面にアクセスできます。
次の手順で、`UEFI`設定画面にアクセスします。

1. \[設定]を開く:
   \[スタート]メニュー-\[設定]として、\[設定]画面を開きます。
   ![設定](/images/articles/pve-bios/ss-win-setting.jpg)
   *設定*

2. \[回復]の選択:
   \[システム] > \[回復]を選択し、回復オプションを表示します
   ![回復オプション](/images/articles/pve-bios/ss-win-restore.jpg)
   *回復オプション*

3. PC の再起動:
   \[回復オプション]セクションの\[今すぐ再起動]をクリックし、PC を再起動します。
   ![今すぐ再起動](/images/articles/pve-bios/ss-win-reboot.jpg)
   *再起動*

4. `UEFIファームウェア`の設定:
   再起動後の\[オプションの選択]画面で、\[トラブルシューティング]>\[詳細オプション]>\[`UEFIファームウェア`の設定]を選択します。
   ![`UEFIファームウェア`の設定](/images/articles/pve-bios/ss-win-touefi.jpg)
   *ファームウェアの設定*

5. 設定画面の起動:
   再起動後、`UEFI`/`BIOS`設定画面が起動します。

## `Boot`オプションの設定

通常の`Windows`では、USB メモリが接続されていても`Windows`が起動します。
`Proxmox VE`インストーラーを起動させるためには、`Bootオプション`で`USBメモリ`から起動するように設定する必要があります。

次の手順で、`Boot`オプションを設定します:

1. `UEFI`/`BIOS`画面の起動:
   `Proxmox VE`インストーラーを PC に接続した状態で、`UEFI`/`BIOS`画面を起動します。
   ![`BIOS`](/images/articles/pve-bios/ss-bios-main.jpg)
   *BIOS画面*

2. `Boot`オプションの表示:
   `Boot`タブを選択し、`Boot`オプション画面を表示します。
   ![`Boot`オプション](/images/articles/pve-bios/ss-bios-bootdevice.jpg)
   *Bootオプション*

3. 起動デバイスの設定:
   起動順序設定(Boot Order Priorities)セクションの`#1`に`USB DEVICE`を設定します。

4. 保存&再起動:
   設定を保存し、PC を再起動します。

以上で、`Proxmox VE`インストーラーが起動します。

## 技術用語と注釈

重要な技術用語を一覧にします。

- `Proxmox VE`:
  オープンソースの仮想化プラットフォーム。

- `UEFI`/`BIOS`:
  PCハードウェアの動作を設定する基本プログラム。

- `Boot`オプション:
  起動デバイスを選択するための設定。

## おわりに

以上で、`Proxmox VE`インストーラーの起動設定は完了しました。
この記事を参考に、次のステップで`Proxmox VE`をインストールしてみてください。

それでは、Happy Hacking!
