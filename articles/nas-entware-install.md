---
title: "asustor NAS: NASにパッケージマネージャ'entware'を導入する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "カスタマイズ", "パッケージマネージャー", "opkg"]
published: false
---



# tl;dr

asustor NASには、パッケージマネージャ'entware'のアプリが提供されています。

entwareを導入すると、bashやgccなど様々なツールをNASにインストールできるようになります。

というわけで、entwareのインストール方法を説明します



# entwareのインストール


entwareは、asustor NASのApp Central上からインストールできます。次の手順で、entwareをインストールします。


1.  NASの画面を開き、App Centralを開きます。

   ![App Central](https://i.imgur.com/pZYP70A.png)
   
2.  検索窓に'entware'と入力し、entwareを差がします。

   ![AppCentral - entware](https://i.imgur.com/euUvXjp.png)
   
3.  [インストール]をクリックし、entwareをインストールします。

   ![entwareのインストール](https://i.imgur.com/G0nqf8g.png)
   
4.   以上で、インストールは終了です。



# entwareによるパッケージのインストール

entwareをインストールすると、`/opt/`以下がentwareのものに置き換わります。`/opt/bin`下にコマンド`opkg`が追加されます。

この`opkg`コマンドを使うことで、様々なツールをインストールできます。

なお、インストールしたツールや関連ファイルは`/opt/`下に配置されます。



## entwareでbashをインストールする

次の手順で、`bash`をインストールします

1.  opkgを使い、`bash`をインストールします

``` bash
atsushifx@agartha $ /opt/bin/opkg install bash
Installing bash (5.1-3) to root...
Downloading http://bin.entware.net/x64-k3.2/bash_5.1-3_x64-3.2.ipk
Configuring bash.

```



2.  `sudo`を使い、ログインシェルを`/opt/bin/bash`に変更します

``` bash
atsushifx@agartha $ sudo vi /etc/passwd
Password:

```



3. rloginで新たにログインし、シェルが`bash`に変わっていれば成功です

   
