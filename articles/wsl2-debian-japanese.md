---
title: "WSLのDebianを日本語化する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "apt", "日本語", "開発環境" ]
published: false
---

## はじめに

`WSL`$_{(Windows Subsystem for Linux)}$ は Windows 上でインストールした Linux ディストリビューションを実行する環境です。
`WSL`の Debian は実機上の Debian と同じように使えますが、デフォルトでは日本語が使えません。
この記事では、`WSL`上の Debian`を日本語化して、日本語による開発を容易にします。

さらに、Debian のデフォルトロケールを日本語にして、Debian の使い勝手をよくします。

## 重要な技術用語

- **WSL $_{(Windows Subsystem for Linux)}$**:
  `Windows Subsystem for Linux`の略で、Windows 上で Linux ディストリビューションを実行する環境

- **Debian**:
  WSL 用に提供されている Linux ディストリビューションの 1 つ

- **`locale`**:
  言語、地域設定を管理するためのシステムコンポーネント

- **`timeZone`**:
  地理的な位置にもとづいて時間を設定するもの

- **`apt`**:
  Linux ディストリビューション `Debian`で使われているパッケージ管理ツール

## 1. Debianの日本語化の手順

Debian の日本語化は次の手順で行います。

1. `apt`で各種ツールを日本語対応にするパッケージ`task-japanese`をインストールする
2. 日本語ロケールを追加し、`デフォルトロケール`を日本語である`ja_JP.UTF-8`に設定する
3. タイムゾーンを`Asia/Tokyo`に設定する
4. Debian を再起動する

以上で、Debian が日本語化されます。
以後の章では、各手順の詳細を説明します。

## 2. 日本語パッケージの導入

### 2.1. 日本語パッケージを導入する

次のコマンドを実行して、日本語パッケージをインストールします。

```bash: Debian
sudo apt install -y task-japanese
```

実行結果は、次の通りです。

```bash: Debian
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

### 3.1. ロケールを日本語にする手順

Debian の`locale` を日本語にして、Debian が出力するメッセージを日本語化します。
次の手順で、`locale` を日本語にします。

#### 日本語ロケールの設定 (対話式)

次の手順で、locale を日本語にします。

1. `dpkg-reconfigure` の起動
   コマンドラインで次のコマンドを実行します。

   ```powershell
   sudo dpkg-reconfigure locales
   ```

   ![locales](https://i.imgur.com/fVyJZ74.png)

2. 日本語ロケールの選択
  ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。
   ![日本語locales](https://i.imgur.com/HMVJETO.png)

3. デフォルトロケールの選択
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

   ![`Configuring Locales`ダイアログ](https://i.imgur.com/WOg7MF3.png)

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

#### 日本語ロケールの設定手順 (コマンドライン)

コマンドラインからの操作でも、日本語ロケールを設定できます。
この場合は、ロケール設定ファイル`/etc/locale.gen`ファイルに日本語ロケールを追加後、ロケールを再度作成します。

非対話式のコマンドでも、日本語`locale`を設定できます。
次の手順で、`locale`を日本語にします。

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


  上記のように、locale に`ja_JP.UTF-8`が含まれていれば成功です。

3. デフォルトロケールを日本語に設定
  `update-locale`でデフォルトロケールを変更します。

  ``` bash: Debian
  atsushifx@ys:~$ sudo /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```bash: Debian
   /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```

以上で、日本語`locale`の設定は終了です。
Debian を再起動すると、メッセージなどが日本語になります。

### 3.2. `timeZone`の設定

`timeZone`を日本時間に設定します。これも、対話式とコマンドの使用によるものの 2 種類の方法があります。

#### `timeZone`の設定手順 (対話式)

次の手順で、`TimeZone`を設定します。

1. `dpkg-reconfigure`コマンドを起動する
  bash から、次のコマンドを実行します。

  ``` bash: Debian
  atsushifx@ys:~$ sudo dpkg-reconfigure tzdata
  ```

   ![timeZone](https://i.imgur.com/DbvibFq.png)

2. `tzdata`の設定

   ![TimeZone](https://i.imgur.com/z5Fmt0R.png)

以上で、`timeZone`が日本になります。

#### `timeZone`の設定手順 (コマンドライン)

`timeZone`は、`/etc/localtime`に保存されています。
このファイルは`/usr/share/zoneinfo`下にある各地域の`timeZone`情報ファイルへのシンボリックになっています。

次の手順で、timeZone を設定します。

1. 旧`timeZone`の削除
   旧 timeZone ファイル/etc/localtime を削除します。

``` bash
atsushifx@ys:~$ sudo rm /etc/localtime

atsushifx@ys:~$
```

2. 新`timeZone`の設定
   `Asia/Tokyo`の`timeZone`ファイルを`/etc/localtime`にリンクします

   ```bash: Debian
   sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
   ```

3. `timeZone`の確認
   `date`コマンドを実行し、日時が`JST`になっているか確認します。

   ```bash: Debian
   date
   Mon Dec  4 06:48:59 PM JST 2023
   ```

   上記のように、`JST`と出力されていれば、`timeZone`は日本標準時になっています。

以上で、`timeZone`の設定は終了です。

## 4. Debianの再起動

Debian を日本語化するためには、Debian を再起動して設定を反映させる必要があります。

### 4.1. Debianを再起動する

次の手順で、Debian を再起動します。

1. Debian コンソールの終了
   `exit`を入力し、Debian コンソールを終了します

2. Debian の終了
   `PowerShell`上で次のコマンドを入力し、Debian を終了します

   ```powershell: Windows Terminal
   wsl --terminate Debian
   ```

3. Debian の起動
   Debian コンソールを起動します。日本語化した Debian が起動します

以上で、Debian の再起動は終了です。

## おわりに

Debian を日本語対応にすることで、日本語を使うアプリケーションが開発可能になります。
メッセージが日本語になることで、日本人開発者の生産性が上がります。

これからも日本語化した Debian を使って、効率的な開発を楽しんでください。
それでは、Happy Hacking!
