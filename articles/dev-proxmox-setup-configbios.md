---
title: "Proxmox VE: インストーラー起動のためのBIOS設定"
emoji: "🏪"
type: "tech"
topics: [ "自宅サーバー", "環境構築", "Windows", "UEFI", "BIOS" ]
published: true
---

## はじめに

`atsushifx`です。
この記事では、`Proxmox VE`インストーラーから PC を起動させるための`BIOS`設定手順を解説します。

## `BIOS`設定方法

`UEFI`/`BIOS`の設定を変更し、USBメモリから`Proxmox VE`インストーラーを起動できるようにします。

### `BIOS`設定画面の起動

`UEFI`/`BIOS`設定画面にアクセスするには、以下の手順を実行します。

1. PC の電源を切る:
  `[スタート]メニュー - [シャットダウン]` を選択して、PC も電源を切ります。

2. PC の電源を入れる:
   電源スイッチを押して、PC を起動します。

3. 設定画面起動:
   PC 起動直後、ロゴ画面が表示されている間に、特定のキー (例: `F2`, `DEL`)を押して設定画面を起動します。
   ![`BIOS`](/images/articles/pve-bios/ss-bios-main.jpg)
   *BIOS画面*

### `Windows 11`からの設定画面の起動

`Windows 11`の場合、`OS`の機能で`UEFI`設定画面にアクセスできます。
以下の手順で、`UEFI`設定画面にアクセスします。

1. [設定]を開く:
   `[スタート]メニュー - [設定]`を選択し、[設定]画面を開きます。
   ![設定](/images/articles/pve-bios/ss-win-setting.jpg)
   *設定*

2. [回復]の選択:
  [システム]>[回復]を選択し、回復オプションを表示します。
   ![回復オプション](/images/articles/pve-bios/ss-win-restore.jpg)
   *回復オプション*

3. PC の再起動:
  [回復オプション]セクションの[今すぐ再起動]をクリックし、PC を再起動します。
   ![今すぐ再起動](/images/articles/pve-bios/ss-win-reboot.jpg)
   *再起動*

4. `UEFIファームウェア`の設定:
   再起動後の[オプションの選択]画面で、[トラブルシューティング]>[詳細オプション]>[`UEFIファームウェア`の設定]を選択します。
   ![`UEFIファームウェア`の設定](/images/articles/pve-bios/ss-win-touefi.jpg)
   *ファームウェアの設定*

5. 設定画面の起動:
   再起動後、`UEFI`または`BIOS`の設定画面が起動します。

## `Boot`オプションの設定

通常、USBメモリを接続しても`Windows`が優先的に起動します。
そのため、`USBデバイス`を`Windows`より優先して起動する設定にします。

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
   起動順序設定 (Boot Order Priorities) セクションの項目`#1`に`USBデバイス`を設定します。

4. 保存&再起動:
   設定を保存し、PC を再起動します。

以上で、`Proxmox VE`インストーラーが起動します。

## 技術用語と注釈

重要な技術用語を一覧にします。

- `Proxmox VE`:
  仮想マシンやコンテナの管理を Web上で行なえる、オープンソースの仮想化プラットフォーム

- `BIOS`:
  ハードウェアの初期化や OS の起動を管理する、コンピューターの基本的な入出力システム。

- `UEFI`:
  `BIOS`の後継として設計され、高速再起動やセキュリティ機能の強化などの多くの改良が加えられたソフトウェア規格。

- `Boot`オプション:
  起動デバイスの順序を変更する機能

## おわりに

以上で、`Proxmox VE`インストーラーの起動設定は完了しました。
この記事を参考に、次のステップで`Proxmox VE`をインストールしてみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [BIOS](https://ja.wikipedia.org/wiki/BIOS):
  Wikipedia の`BIOS`の記事

- [UEFI](https://ja.wikipedia.org/wiki/UEFI):
  Wikipedia の`UEFI`の記事
