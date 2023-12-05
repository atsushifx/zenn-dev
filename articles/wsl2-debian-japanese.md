---
title: "WSL上のDebianを日本語化する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "apt", "日本語", "開発環境" ]
published: false
---

## はじめに

この記事では、**Windows Subsystem for Linux (以下、WSL)**上の Debian を日本語化する方法について解説します。
Debian に日本語環境を導入し、日本語ロケールを追加した後、デフォルトロケールを日本語に設定します。

これにより、Debian はエラーメッセージなどを日本語で出力するようになるため、開発効率が向上します。

## 重要な技術用語

- **Windows Subsystem for Linux (WSL)**:
  Windows 上で Linux の実行環境を提供する互換性レイヤー

- **Debian**:
  自由ソフトウェアとして開発され、オープンなモデルを採用した Linux ディストリビューションの 1つ

- **`locale`** (ロケール):
  システムにおける特定地域の言語や、時間や日付の表示フォーマットなどの環境設定を表すもの

- **デフォルトロケール**
  システム全体で使用されるデフォルトの`locale`

- **`timeZone`** (タイムゾーン):
  地球上の各地域のローカル標準時間を定義するための区分

- **`apt`**:
  `Debian`および派生ディストリビューションで使われているパッケージ管理システム。ソフトウェアのインストール、アップデート、削除などを行なえる

## 1. Debianの日本語化の手順

`WSL`上の `Debian` を日本語化する具体的な手順は、次のとおりです。

1. `apt`で Debian を日本語対応にするパッケージ`task-japanese`をインストール
2. 日本語`locale`を追加し、`デフォルトロケール`を日本語である`ja_JP.UTF-8`に設定
3. `timeZone`を`Asia/Tokyo` (日本時間)に設定
4. Debian を再起動

以上の手順で、Debian が日本語化されます。

## 2. 日本語パッケージの導入

Debian には、日本語環境を設定するためのパッケージ`task-japanese`があります。
`task-japanese`は、日本語表示に必要なフォントや各種ユーティリティを一元的にインストールするメタパッケージです。

### 2.1 日本語パッケージを導入する

次のコマンドを実行し、日本語での表示に必要な最適なユーティリティとフォントを含むメタパッケージ `task-japanese`をインストールします。
これは、日本語の文字エンコーディングのサポートや、日本語環境で最適な表示を行なうためのフォントなど、日本語表示に必要なすべてをカバーしています。

```bash:
sudo apt install -y task-japanese
```

実行結果は、次のとおりです。

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

以上で、日本語パッケージのインストールは完了です。

### 3. Debianの日本語設定

Debian を日本語化するには 2つのステップが必要です。

1. デフォルトロケールを日本語に設定すること
2. `タイムゾーン`を`Asia/Tokyo` (`JST`)に設定すること

です。
このセクションでは、上記 2つの設定方法を説明します。

### 3.1 日本語`locale`の設定

Debian に日本語`locale`を追加します、その語`デフォルトロケール`を日本語の`ja_JP.UTF-8`にします。

#### 日本語`locale`の設定 (対話式)

次の手順で、`locale`を日本語に設定します。

1. `dpkg-reconfigure` の起動:
   コマンドラインで次のコマンドを実行します。

   ```bash:
   dpkg-reconfigure locales
   ```

   ![localesダイアログ](https://i.imgur.com/fVyJZ74.png)

2. 日本語ロケールの選択:
  ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。
   ![`Locales to be generated`ダイアログ](https://i.imgur.com/HMVJETO.png)

3. デフォルトロケールの選択:
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

   ![`Configuring Locales`ダイアログ](https://i.imgur.com/WOg7MF3.png)

4. ロケールの作成:
   `dpkg-reconfigure`が`locale`を作成します。
   以下のように、`ja_JP.UTF-8`が追加されていれば設定成功です。

   ```bash:
   Generating locales (this might take a while)...
   en_US.UTF-8... done
   ja_JP.UTF-8... done
   Generation complete.
   ```

以上で、`locale`の設定は完了です。

#### 日本語`locale`の設定 (コマンドライン)

コマンドラインからの操作で、日本語`locale`を設定できます。
こちらの操作は、シェルスクリプト内で自動的に日本語かをしたいときに使用できます。

設定方法は、ロケール設定ファイル`/etc/locale.gen`ファイルに日本語ロケールを追加します。
その後、ロケールを再度作成します。

次の手順で、`locale`を日本語にします。

1. 日本語ロケールの追加:
   `root`で次のコマンドを実行し、`ja_JP.UTF-8`を locale に追加します。

   ```bash:
   sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/ig' /etc/locale.gen >/etc/locale.gen.new
   mv /etc/locale.gen.new /etc/locale.gen
   ```

2. locale の再作成:
   `root`で次のコマンドを実行して、`ja_JP.UTF-8`を含んだ`locale`を作成します。

   ```bash:
   /usr/sbin/locale-gen
   ```

   実行結果は、次のようになります:

   ```bash:
   Generating locales (this might take a while)...
     en_US.UTF-8... done
     ja_JP.UTF-8... done
   Generation complete.
   ```

   上記のように`locale`に`ja_JP.UTF-8`が含まれていれば、日本語`locale`が追加されています。

3. デフォルトロケールを日本語に設定:
   `update-locale`でデフォルトロケールを変更します。

   ```bash:
   /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```

以上で、日本語ロケールの設定は完了です。

### 3.2 `timeZone`の設定

Debian を日本語環境にするため、`timeZone`を`Asia/Tokyo (JST)`に設定します。

#### `timeZone`の設定 (対話式)

次の手順で、`timeZone`を`Asia/Tokyo`(日本標準時) に設定します。

1. `dpkg-reconfigure`の起動:
  コマンドラインで、次のコマンドを実行します。

   ```bash:
   sudo /usr/sbin/dpkg-reconfigure tzdata
   ```

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/DbvibFq.png)

2. `tzdata`の設定:
   `timeZone`で`Asia`,`Tokyo`を選択します

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/z5Fmt0R.png)

以上で、`timeZone`が日本になります。

#### `timeZone`の設定手順 (コマンドライン)

`timeZone`は、`/etc/localtime`に保存されています。
このファイルは`/usr/share/zoneinfo`下にある各地域の`timeZone`情報ファイルへのシンボリックになっています。

次の手順で、timeZone を設定します。

1. 旧`timeZone`の削除:
   旧`timeZone`ファイル`/etc/localtime`を削除します

   ```bash:
   sudo rm -f /etc/localtime
   ```

2. 新`timeZone`の設定:
   `Asia/Tokyo`の`timeZone`ファイルを`/etc/localtime`にリンクします

   ```bash:
   sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
   ```

3. `timeZone`の確認:
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

以上で、Debian の再起動が終了しました。
再起動により、設定した`locale`と`timeZone`がシステムに反映されます。

## おわりに

これで WSL上の Debian を日本語化できました。
これにより、メッセージなどが日本語になるため、開発効率が向上します。

それだけでなく、日本語を扱うアプリケーションも開発できるようになりました。

日本語化した Debian を活用し、効率的なプログラミングをすすめてください。
それでは、Happy Hacking!
