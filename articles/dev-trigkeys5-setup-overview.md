---
title: "proxmox: proxmoxのセットアップ #1: Overview"
emoji: "💻"
type: "tech"
topics: ["miniPC", "proxmox", "pve", "diagram", ]
published: false
---

## はじめに

`Amazon`でミニPCの`TRIGKEY Speed S5 Pro`を買いました。
仮想化環境である[`prxomox`](https://www.proxmox.com/)を入れて、色々と遊ぼうとおもいます。
Enjoy!

## `proxmox`とは

`proxmox`はオープンソースの仮想化アプライアンスです。
`Debian`をベースに仮想化用のツールを組み込み、仮想化に特化した`Linux`ディストリビューションで、Web上の管理画面で仮想化機能の管理が行えます。

## 構成

### ハードウェア構成

`Speed S5 Pro`は、`SSD`/`メモリ`を換装し、外付け`HDD`を増設しています。

ハードウェアスペックは、下記の通りです:

| 種別 | ハードウェア | スペック | 備考 |
| --- | --- | --- | --- |
| CPU | `AMD Ryzen 7 5800H` | `8コア` / `16スレッド` | |
| Graphics | `Radon Graphics` | `ATI Cezanne` | 内蔵`GPU` |
| メモリ | `DDR4` | `64GB` | |
| ストレージ1 | `NVME SSD` | `2TB` | |
| ストレージ2 | `SATA SSD` | `2TB` | |
| 外付け`HDD` | `SATA HDD` | `8TB` | `USB`外付け |

### ネットワーク構成

`Speed S5 Pro`は、自宅の`LAN`に繋ぎます。
自分の`PC`や`スマートフォン`は`無線LAN`で繋ぎますが、`NAS`などは`有線LAN`で繋ぎます。
図にすると下記のような感じです:

![家庭内LAN構成図](https://raw.githubusercontent.com/atsushifx/zenn-cli/e4ea3558b73f896fa71399e0791020f3c01a244b/images/atsushifxs-diagram/house-lan.svg)
*LAN構成図*

`IPアドレス`は、`1`～`100`を`DHCP`用に、`200`～をサーバーなどの`固定IP`用に確保しています。
`250`～`254`は、ルーター用のアドレスです。

## セットアップ戦略

### ストレージのパフォーマンス

`NVME`接続の`SSD`は高速ですが、そのほかのストレージ、とくに外付けの`HDD`は低速です。
そのため、`NVME`接続の`SSD`をキャッシュにして、パフォーマンスを改善します。

`キャッシュ`には、[`bcache`](https://wiki.archlinux.jp/index.php/Bcache)を使用します。
`bcache`では、`/dev/bcache*`のかたちでストレージを提供するため、通常のストレージと同じようにストレージを使用できます。

### 起動ディスク

`proxmox`のインストールには、`USBメモリ`を使います。
インストーラーの作成には、[`rufus`](https://rufus.ie/)を使用しました。
`prxomox`のインストールイメージは、`rufus`のファイルコピーには対応していませんが、`rufus`USB メモリに直接書き込むので、問題なくインストールできます。

### キーボードとマウス、およびモニター

インストール時には、キーボード、マウス、モニターを接続する必要があります。
キーボードとマウスは USB 接続の有線のもの、モニターは HDMI に対応したものを使います。
また、USB 接続端子のことを考えると、USB ハブがあるといいでしょう。

## おわりに

以上、家庭内サーバーについて説明しました。
仮想化機能を利用して、`NAS`や`Minecraft`サーバーなど、色々と楽しみたいとおもいます。

それでは、Happy Hacking!
