---
title: "asustor NAS: NASにパッケージマネージャ'entware'を導入する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "カスタマイズ", "パッケージマネージャー", "entware"]
published: true

---

## tl;dr

asustor NAS には、パッケージマネージャー'entware'のアプリが提供されています。
entware を導入すると、bash や gcc などさまざまなツールを NAS にインストールできます。
というわけで、entware のインストール方法を説明します。

## entwareのインストール

entware は、asustor NAS の App Central 上からインストールできます。次の手順で、entware をインストールします。

1. NAS の画面を開き、`App Central`を開きます
  ![App Central](https://i.imgur.com/pZYP70A.png)

1. 検索窓に'entware'と入力し、`entware`をさがします
  ![AppCentral - entware](https://i.imgur.com/euUvXjp.png)

1. [インストール]をクリックし、`entware` をインストールします
  ![entwareのインストール](https://i.imgur.com/G0nqf8g.png)

1. 以上で、インストールは終了です

## entware によるパッケージのインストール

`entware`をインストールすると、`/opt/`以下が entware のものに置き換わります。`/opt/bin`下にコマンド`opkg`が追加されます。

この`opkg`コマンドを使うことで、さまざまなツールをインストールできます。
なお、インストールしたツールや関連ファイルは`/opt/`下に配置されます。

### entwareでbashをインストールする

entware の例として、`bash` をインストールします。

次の手順で、`bash`をインストールします。

1. opkg を使い、`bash`をインストールします
  
   ``` bash
   atsushifx@agartha $ /opt/bin/opkg install bash
   Installing bash (5.1-3) to root...
   Downloading http://bin.entware.net/x64-k3.2/bash_5.1-3_x64-3.2.ipk
   Configuring bash.
   
   ```

1. `sudo`を使い、ログイン shell を`/opt/bin/bash`に変更します

   ``` bash
   atsushifx@agartha $ sudo vi /etc/passwd
   Password:

   ```

1. rlogin で新たにログインし、shell が`bash`に変わっていれば成功です

## entwateの基本的なコマンド

`/opt/bin/opkg`のみ入力すると、でコマンドのヘルプを表示します。
ここでは、基本的なコマンドを紹介します。

| entware | サブコマンド | コマンドの説明                                               |
| ------- | ------------ | ------------------------------------------------------------ |
| | update | パッケージ情報を最新の者に更新します |
| | upgrade | インストール済みのパッケージを最新のものにアップグレードします |
| | install \<package\> | 指定したパッケージをインストールします |
| | remove \<package\> | 指定したパッケージをアンインストールします |
| | list | パッケージ一覧を表示します |
| | list \<keyword\> | キーワードを含むパッケージを表示します |
| | list-installed | インストール済みのパッケージを表示します |
| | list-upgradable | アップグレード可能なパッケージを表示します |
| | info \<package\> | パッケージの情報を表示します |
