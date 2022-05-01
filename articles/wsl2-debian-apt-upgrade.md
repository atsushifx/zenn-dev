---
title: "wsl2: aptを使ってDebianをアップグレードする"
emoji: "🐧"
type: "tech"
topics: ["wsl", "Debian", "apt", "パッケージマネージャー" ]
published: true
---

## はじめに

Debian のパッケージマネージャー、`apt`は公式ページからパッケージをダウンロードします。
ここでは、高速化のため日本語ミラーからもダウンロードする設定を追加して`Debian`をアップグレードします。

## ミラーの追加

### apt と source.list

apt では、`/etc/apt/sources.list`にパッケージ一覧の source を記述します。
インストール直後なら、次のようになります。

  ``` /etc/apt/sources.list
  deb http://deb.debian.org/debian bullseye main
  deb http://deb.debian.org/debian bullseye-updates main
  deb http://security.debian.org/debian-security bullseye-security main
  deb http://ftp.debian.org/debian bullseye-backports main
  
  ```

apt は、このほかに`/etc/apt/sources.list.d`下の`*.list`ファイルも読み込みます。
設定を追加するときには、`/etc/apt/sources.list.d`にファイルを追加します。

### ミラーの`source.list`を追加する

まず、cdn ミラーによるリストを追加します。[https://httpredir.debian.org/](https://httpredir.debian.org/)に source が載っているので、source を書き写します。

  ``` /etc/apt/sources.list.d/cdn.list]
  # cdn mirror
  
  deb http://cdn-fastly.deb.debian.org/debian stable main
  # deb http://cdn-fastly.deb.debian.org/debian-security stable/updates main  
  ```

なお、4行目の`debian-security`はエラーがでるのでコメントアウトしています。

日本の cdn ミラーは、[Debian JP Project - CDNミラー](https://www.debian.or.jp/community/push-mirror.html)に載っています。ここの source も書き写します。

  ```  /etc/apt/sources.list.d/ja-jp.list
  # cdn mirror from Debian JP

  deb http://ftp.jp.debian.org/debian/ bullseye main contrib non-free
  deb http://ftp.jp.debian.org/debian/ bullseye-updates main contrib
  deb http://ftp.jp.debian.org/debian/ bullseye-backports main contrib non-free
  # deb-src http://ftp.jp.debian.org/debian/ bullseye main contrib non-free
  # deb-src http://ftp.jp.debian.org/debian/ bullseye-updates main contrib
  # deb-src http://ftp.jp.debian.org/debian/ bullseye-backports main contrib non-free

  ```

以上で、ミラーの追加は終了です。

## Debian のアップグレード

### Debianをアップグレードする

設定が終われば、apt を使って Debian をアップグレードできます。
次の手順で、Debian をアップグレードします。

  ``` bash
  atsushifx@ys:/etc/apt$ sudo apt update
   .
   .
   .
  Reading package lists... Done
  Building dependency tree... Done
  Reading state information... Done
  4 packages can be upgraded. Run 'apt list --upgradable' to see them.

  atsushifx@ys:/etc/apt$ sudo apt upgrade -y 
    .
    .
    .
  Processing triggers for libc-bin (2.31-13+deb11u3) ...
  ldconfig: /usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link

  atsushifx@ys:/etc/apt$

  ```

  以上で、Debian のアップグレードは終了です。

## おわりに

ここまでで、wsl下の Debian を最新 Version にできました。
このあと、日本語化と GUI 化すれば本格的に Debian を使えるようになります。

それでは、Happy Hacking.
