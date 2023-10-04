---
title: "wsl2: wsl上のDebianを日本語化する"
emoji: "🐧"
type: "tech"
topics: ["wsl", "Debian", "apt", "日本語", "開発環境" ]
published: false
---

## はじめに

Debian は apt で簡単に日本語環境にできます。
この記事では、wsl 上の Debian を日本語化し、あわせて日本語マニュアルもインストールします。

## Debianの日本語化

### パッケージの導入

Debian の apt には日本語環境のためのパッケージがあるので、それをインストールします。
その後、`locale`と`timezone` を日本語環境に書き換えます。

#### 日本語packageの導入

Debian の日本語パッケージは、`task-japanese`です。
次のコマンドを実行して、日本語パッケージをインストールします。

```bash: Debian
sudo apt install -y task-japanese
```

``` bash: debian
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

以上で、日本語パッケージのインストールは終了です。

### Debianの日本語化

#### localeを日本語にする

システムの`locale` を日本語にすると、エラーメッセージが日本語になります。
次の手順で、`locale` を日本語にします。

#### 対話式コマンドによる日本語ロケールの設定

`dpkg-reconfigure` を使うことで、画面のメニューを見ながら`locale`を設定できます。
次の手順で、locale を日本語にします。

1. `dpkg-reconfigure` の起動
   コマンドラインで次のコマンドを実行します。

   ```powershell
   sudo dpkg-reconfigure locales
   ```

  `locale` 設定ダイアログが表示されます。」

2. 日本語ロケールの選択
    ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。


3. デフォルトロケールの選択
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

4.ロケールの作成
   ロケールを作成します。コマンドラインは、次のようになります。

   ```bash
   Generating locales (this might take a while)...
   en_US.UTF-8... done
   ja_JP.UTF-8... done
   Generation complete.

   atsushifx@ys #
  ```

以上で、`locale`の設定は終了です。
Debian を再起動すると、メッセージが日本語になっています。

#### コンソールでの日本語ロケールの設定

非対話式のコマンドでも、日本語 locale を設定できます。
次の手順で、locale を日本語にします。

1.  日本語ロケールの追加
   `root`で次のコマンドを実行し、`ja_JP.UTF-8`を locale に追加します。

   ```bash: Debian
   sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/ig' /etc/locale.gen >/etc/locale.gen.new
   mv /etc/locales.gen.new /etc/locales.gen
   ```


2. locale の再作成
    次のコマンドを実行して、`ja_JP.UTF-8`も含んだ`locale`を作成します。

   ```bash: Debian
   /usr/sbin/locale-gen
   ``

   実行結果は、次のようになります。

   ```bash: Debian
   Generating locales (this might take a while)...
     en_US.UTF-8... done
     ja_JP.UTF-8... done
   Generation complete.

   root@ys: #
     ```


3.
  `sudo vim /etc/locale.gen\`として`/etc/locale.gen`を編集し、`ja_JP.UTF-8`をコメントアウトから外す。

1. locale の再作成
  `/usr/sbin/locale-gen`コマンドを実行し。`ja_JP.UTF-8`も含めた locale を再作成する。

  ``` bash: Debian
  atsushifx@ys:~$ sudo /usr/sbin/locale-gen
  Generating locales (this might take a while)...
  en_US.UTF-8... done
  ja_JP.UTF-8... done
  Generation complete.

  atsushifx@ys:~$ /usr/bin/localectl list-locales
  C.UTF-8
  en_US.UTF-8
  ja_JP.UTF-8

  atsushifx@ys:~$
  ```

  上記のように、locale に`ja_JP.UTF-8`が含まれていれば成功です。

3. デフォルトロケールを日本語に設定
  `update-locale`でデフォルトロケールを変更します。

  ``` bash: Debian
  atsushifx@ys:~$ sudo /usr/bin/update-locale LANG=ja_JP.UTF-8

  atsushifx@ys:~$
  ```

以上で、日本語 locale の設定は終了です。以後、エラーメッセージなどが日本語で表示されます。

### TimeZoneの設定

次に、TimeZone を日本時間に設定します。これも、対話型とコマンド使用の 2 種類の方法があります。

#### TimeZoneの設定 (対話式)

次の手順で、TimeZone を設定します。

1. `dpkg-reconfigure`コマンドを起動する
  bash から、次のコマンドを実行します。

  ``` bash: Debian
  atsushifx@ys:~$ sudo dpkg-reconfigure tzdata
  ```

  と入力し、`tzdataを設定しています`ダイアログを表示します。

2. `tzdata`の設定

  ダイアログで`Asia`、`Tokyo`を選択し、`OK`で設定します。

3. Debian の再起動
  設定を反映させるため、Debian コンソールから`exit`で抜けます。その後、PowerShell 側で、`wsl --shutdown Debian`として wsl 上の Debian をシャットダウンします。
  再度、Debian コンソールを起動すると、Debian が日本語化されています。

#### TimeZoneの設定 (コマンドライン)

TimeZone 自体は、/etc/localtime に保存されています。このファイルは/usr/share/zoneinfo 下にある各地域の TimeZone 情報ファイルへのシンボリックになっています。
/etc/localtime のリンク先を変更すれば、TimeZone を変更できます。

次の手順で、TimeZone を設定します。

1. 旧 TimeZone の削除
旧 TimeZone ファイル/etc/localtime を削除します。

``` bash
atsushifx@ys:~$ sudo rm /etc/localtime

atsushifx@ys:~$
```

2. 新 TimeZone の設定
新 TimeZone ファイルを/etc/localtime にリンクします。

``` bash: Debian
atsushifx@ys:~$ sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

atsushifx@ys:~$
```

3. TimeZone の確認
date コマンドを実行し、日時が JST になっているか確認します。

``` bash: Debian
atsushifx@ys:~$ date
2022年  8月 15日 月曜日 17:48:51 JST

atsushifx@ys:~$
```

これで、TimeZone の設定は終了です。

### man の日本語化

Debian には、日本語に翻訳された`manpages`があります。通常の`manpages`パッケージに加え、日本語`manpages`パッケージをインストールして、man を日本語化します。
次の手順で、manages を日本語化します。

1. `manpages`パッケージのインストール
  次の手順で、`manpages`パッケージをインストールします。

  ``` bash: Debian
  atsushifx@ys:~$ sudo apt install -y manpages manpages-dev man-db
  パッケージリストを読み込んでいます... 完了
  依存関係ツリーを作成しています... 完了
  状態情報を読み取っています... 完了
   .
   .
   .

  atsushifx@ys:~$
  ```

  以上で、`manpages`のインストールは終了です。

2. `manpages-ja`パッケージのインストール
  日本語`manpages`パッケージ`manpages-ja`は、`task-japanese`と一緒にインストールされます。
  実行する必要はありませんが、次の手順で日本語`manpages`パッケージをインストルします。

  ``` bash: Debian
  atsushifx@ys:~$ sudo apt install -y manpages-ja manpages-ja-devb
  パッケージリストを読み込んでいます... 完了
  依存関係ツリーを作成しています... 完了
  状態情報を読み取っています... 完了
   .
   .
   .

  atsushifx@ys:~$
  ```

  以上で、日本語`manpages`のインストールは終了です。
  以後、`man`コマンドで日本語マニュアルを表示します。

## おわりに

やはり日本語表示はストレスがかからなくて良いです。みんなも Debian を日本語化して、じゃんじゃん開発しましょう。

それでは、Happy Hacking
