---
title: "WSLのDebianを日本語化する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "apt", "日本語", "開発環境" ]
published: false
---

## はじめに

`Windows Subsytem for Linux` (以下、WSL)の Debian は、デフォルトの設定では日本語が扱えません。
この記事では、WSL上の Debian を日本語環境に設定する手順を詳しく説明します。
具体的には:

1. 日本語かパッケージをインストールし、Debian に日本語環境をインストールする
2. Debian に日本語ロケールを追加し、デフォルトロケールを日本語にする
3. タイムゾーンを日本時間にする

以上で、日本語が扱える Debian 環境を構築します。
日本語対応が可能になることで、アプリケーション開発の効率が向上します。

## 重要な技術用語

- **Windows Subsystem for Linux (WSL)**:
  Windows 上で Linux 環境を動作させるためのサブシステム

- **Debian**:
  フリーでオープンな開発が行われている Linux ディストリビューションの 1つ

- **`locale`**:
  コンピューター上で用いられる言語、国や地域、文字コードなどのユーザーインターフェイスやデータフォーマットを管理するコンポーネント

- **`timeZone`**:
  地球上の各地域のローカル標準時間を定義するための区分

- **`apt`**:
  Linux ディストリビューション `Debian`で使われているパッケージ管理ツール

## 1. Debianの日本語化の手順

WSL の Debian を日本語環境に設定し、日本語で利用可能にするための詳細な手続きは次のとおりです。
(以下、日本語環境を設定し、デフォルトで日本語を使える環境にすることを**日本語化**と呼称します)

1. `apt`で各種ツールを日本語対応にするパッケージ`task-japanese`をインストールする
2. 日本語ロケールを追加し、`デフォルトロケール`を日本語である`ja_JP.UTF-8`に設定する
3. タイムゾーンを`Asia/Tokyo` (日本時間)に設定する
4. Debian を再起動する

以上で、Debian が日本語環境に設定されます。

## 2. 日本語パッケージの導入

Debian には、日本語環境に対応するためのツール、フォントなどをまとめたパッケージ`task-japanese`があります。
Debian に`task-japanese`をインストールする手順を説明します。

### 2.1 日本語パッケージを導入する

次のコマンドを実行して、日本語パッケージをインストールします。
これにより、日本語表示に必要尾なフォントや日本語に対応したユーティリティがインストールされます。

```bash:
sudo apt install -y task-japanese
```

実行結果は、次の通りです。

```bash:
atsushifx@ys:~$ sudo apt install -y task-japanese

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  bzip2 dmidecode fbterm fontconfig-config fonts-dejavu-core fonts-unifont laptop-detect libbrotli1 libfontconfig1
  .
  .
  .
Processing triggers for libc-bin (2.31-13+deb11u3) ...
ldconfig: /usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link

atsushifx@ys:~$
```

**注意**:
実行結果に、`ldconfig: /usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link`というメッセージが表示されます。これは Debian の日本語化には影響ありません。

以上で、日本語パッケージのインストールは終了です。

### Debianの日本語化

### 3.1 日本語ロケールの追加

Debian の`locale`の設定を日本語にして、Debian が出力するメッセージを日本語化します。
次の手順で、`locale`の設定を日本語にします。

#### 日本語ロケールの追加手順 (対話式)

`dpkg-reconfigure`を使って、日本語ロケールを設定します。
これにより、Debian が日本語でメッセージを出力するよう設定します。

次の手順で、locale を日本語にします。

1. `dpkg-reconfigure` の起動
   コマンドラインで次のコマンドを実行します。

   ```bash:
   dpkg-reconfigure locales
   ```

   ![localesダイアログ](https://i.imgur.com/fVyJZ74.png)

2. 日本語ロケールの選択
  ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。
   ![`Locales to be generated`ダイアログ](https://i.imgur.com/HMVJETO.png)

3. デフォルトロケールの選択
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

   ![`Configuring Locales`ダイアログ](https://i.imgur.com/WOg7MF3.png)

4. ロケールの作成
   ロケールを作成します。以下のように、`ja_JP.UTF-8`が追加されていれば設定成功です。

   ```bash:
   Generating locales (this might take a while)...
   en_US.UTF-8... done
   ja_JP.UTF-8... done
   Generation complete.

   atsushifx@ys #
  ```

以上で、`locale`の設定は終了です。
Debian を再起動した後は、システムメッセージなどが日本語表示になっています。

#### 日本語ロケールの追加手順 (コマンドライン)

コマンドラインからの操作でも、日本語ロケールを設定できます。
この場合は、ロケール設定ファイル`/etc/locale.gen`ファイルに日本語ロケールを追加後、ロケールを再度作成します。

次の手順で、`locale`を日本語にします。

1.  日本語ロケールの追加
   `root`で次のコマンドを実行し、`ja_JP.UTF-8`を locale に追加します。

   ```bash:
   sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/ig' /etc/locale.gen >/etc/locale.gen.new
   mv /etc/locale.gen.new /etc/locale.gen
   ```

2. locale の再作成
    次のコマンドを実行して、`ja_JP.UTF-8`も含んだ`locale`を作成します。

   ```bash:
   /usr/sbin/locale-gen
   ```

   次のように、`ja_JP.UTF-8`が表示されていれば、設定成功です

   ```bash:
   root@ys:~ # /usr/sbin/locale-gen

   Generating locales (this might take a while)...
     en_US.UTF-8... done
     ja_JP.UTF-8... done
   Generation complete.

   root@ys: #
     ```

3. デフォルトロケールを日本語に設定
  `update-locale`でデフォルトロケールを変更します。

   ```bash:
   /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```

以上で、日本語ロケールの設定は終了です。
Debian を再起動すると、メッセージなどが日本語になります。

### 3.2 タイムゾーンの設定

`timeZone`を日本時間に設定します。対話式のものとコマンドの使用によるものの 2 種類の方法があります。

#### `timeZone`の設定手順 (対話式)

次の手順で、`timeZone`を設定します。

1. `dpkg-reconfigure`コマンドを起動する
  bash から、次のコマンドを実行します。

   ```bash:
   sudo /usr/sbin/dpkg-reconfigure tzdata
   ```

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/DbvibFq.png)

2. `tzdata`の設定

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/z5Fmt0R.png)

以上で、`timeZone`が日本になります。

#### `timeZone`の設定手順 (コマンドライン)

`timeZone`は、`/etc/localtime`に保存されています。
このファイルは`/usr/share/zoneinfo`下にある各地域の`timeZone`情報ファイルへのシンボリックになっています。

次の手順で、timeZone を設定します。

1. 旧`timeZone`の削除
   旧 timeZone ファイル/etc/localtime を削除します。

   ```bash:
   sudo rm /etc/localtime
   ```

2. 新`timeZone`の設定
   `Asia/Tokyo`の`timeZone`ファイルを`/etc/localtime`にリンクします

   ```bash:
   sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
   ```

3. `timeZone`の確認
   `date`コマンドを実行し、日時が`JST`になっているかを確認します。

   ```bash:
   date
   Mon Dec  4 06:48:59 PM JST 2023
   ```

   上記のように、`JST`と出力されていれば、`timeZone`は日本標準時になっています。

以上で、`timeZone`の設定は終了です。

## 4. Debianの再起動

日本語化の設定を反映させるために、Debian を再起動する必要があります。

### 4.1 Debianを再起動する

次の手順で、Debian を再起動します。

1. Debian コンソールの終了
   `exit`を入力し、Debian コンソールを終了します

2. Debian の終了
   **`PowerShell`**上で次のコマンドを入力し、Debian を終了します

   ```powershell:
   wsl --terminate Debian
   ```

3. Debian の起動
   Debian コンソールを起動します。日本語化した Debian が起動します

以上で、Debian の再起動は終了です。

## おわりに

Debian を日本語対応にすることで、日本語を使ったアプリケーションが開発可能になります。
メッセージが日本語になることで、開発の効率が上がるでしょう。

日本語化した Debian を引き続き活用して、効率的に開発を進めましょう。
それでは、Happy Hacking!
