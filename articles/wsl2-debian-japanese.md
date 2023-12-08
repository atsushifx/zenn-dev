---
title: "WSL上のDebianを日本語化する手順"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "apt", "日本語", "開発環境" ]
published: false
---

## はじめに

この記事では、**Windows Subsystem for Linux (以下、WSL)**上の Debian を日本語化する方法について解説します。
インストール直後ではロケールは英語になっています。
診断やデバッグのさいに、システムメッセージやエラーメッセージが英語で出力され、混乱るこすとがあります。

その問題を解消するため、Debian を日本語化して、システムメッセージやエラーメッセージが日本語にします。

また、Debian で日本語をあつかうアプリケーションの開発が可能になります。

## 重要な技術用語

- **Windows Subsystem for Linux (WSL)**:
  Windows 上で　Linux のカーネルを使って Linux バイナリを実行できるようにする互換性レイヤー

- **Debian**:
  自由ソフトウェアとして開発され、オープンなモデルを採用した Linux ディストリビューション

- **ロケール** (`locale`):
  システムにおける特定地域の言語や、時間や日付の表示を調整するコンポーネント

- **デフォルトロケール**
  システム全体で使用されるデフォルトのロケール

- **タイムゾーン** (`timeZone`):
  地球上の各地域のローカル標準時間を定義するための区分

- **`apt`**:
  `Debian`および派生ディストリビューションで使われているパッケージ管理システム。ソフトウェアのインストール、アップデート、削除などを行なえる

- **`dpkg-reconfigure`**:
  Debian において、インストール済みのパッケージの設定を対話形式で再設定するコマンド

## 1. Debianの日本語化の手順

`WSL`上の `Debian` を日本語化する具体的な手順は、次のとおりです。

1. Debian上で`apt`を使い、日本語対応パッケージ`task-japanese`をインストール
2. 日本語ロケールを追加し、`デフォルトロケール`を日本語である`ja_JP.UTF-8`に設定
3. タイムゾーンを`Asia/Tokyo` (日本時間)に設定
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

Debian を日本語化するためには、以下の 2つのステップを必要とします。

1. デフォルトロケールを日本語に設定すること
2. `タイムゾーン`を`Asia/Tokyo` (`JST`)に設定すること

です。
このセクションでは、上記 2つの設定方法を説明します。

### 3.1 日本語ロケールの設定

Debian に日本語ロケールを追加します、その後、`デフォルトロケール`を日本語(`ja_JP.UTF-8`)にします。

#### 日本語ロケールの設定 (対話式)

次の手順で、ロケールを日本語に設定します。

1. `dpkg-reconfigure` の起動:
   コマンドラインで次のコマンドを実行します。

   ```bash:
   dpkg-reconfigure locales
   ```

   ![localesダイアログ](https://i.imgur.com/fVyJZ74.png)
   *`locales`ダイアログ*

2. 日本語ロケールの選択:
  ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。
   ![`Locales to be generated`ダイアログ](https://i.imgur.com/HMVJETO.png)
   *`Locales to be generated`ダイアログ*

3. デフォルトロケールの選択:
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

   ![`Configuring Locales`ダイアログ](https://i.imgur.com/WOg7MF3.png)
   *`Configuring Locales`ダイアログ*

4. ロケールの作成:
   `dpkg-reconfigure`が`locale`を作成します。
   以下のように、`ja_JP.UTF-8`が追加されていれば設定成功です。

   ```bash:
   Generating locales (this might take a while)...
   en_US.UTF-8... done
   ja_JP.UTF-8... done
   Generation complete.
   ```

以上で、日本語ロケールの設定は完了です。

#### 日本語ロケールの設定 (コマンドライン)

コマンドラインからの操作で、日本語ロケールを設定できます。
こちらの操作は、シェルスクリプト内で自動的に日本語化をしたいときに使用できます。

設定方法は、日本語ロケールをシステム設計に追加します。
その後、ロケールを再度作成します。

次の手順で、日本語ロケールを設定します。

1. 日本語ロケールの追加:
   `root`で次のコマンドを実行し、`ja_JP.UTF-8`をロケールに追加します。

   ```bash:
   sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/ig' /etc/locale.gen >/etc/locale.gen.new
   mv /etc/locale.gen.new /etc/locale.gen
   ```

2. ロケールの再作成:
   `root`で次のコマンドを実行して、`ja_JP.UTF-8`を含んだロケールを作成します。

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

   上記のようにロケールに`ja_JP.UTF-8`が含まれていれば、日本語ロケールが追加されています。

3. デフォルトロケールを日本語ロケールに設定:
   `update-locale`でデフォルトロケールを変更します。

   ```bash:
   /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```

以上で、日本語ロケールの設定は完了です。

### 3.2 タイムゾーンの設定

Debian を日本語環境にするため、タイムゾーンを設定します。
具体的には、タイムゾーンを`Asia/Tokyo (JST)`に設定します。
これにより、ログなどの時刻が日本時間で表示されるため、時間に関する混乱が少なくなります。

#### タイムゾーンの設定 (対話式)

次の手順で、タイムゾーンを`Asia/Tokyo` ('JST') に設定します。

1. `dpkg-reconfigure`の起動:
  コマンドラインで、次のコマンドを実行します。

   ```bash:
   sudo /usr/sbin/dpkg-reconfigure tzdata
   ```

   ![`tzdata`設定ダイアログ](https://i.imgur.com/DbvibFq.png)
   *`tzdata`設定ダイアログ*

2. `tzdata`の設定:
   `tzdata`に、`Asia`,`Tokyo`を選択します。

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/z5Fmt0R.png)
   *タイムゾーン設定ダイアログ*

3. タイムゾーンの設定:
   実行結果は、次のようになります。

   ```bash
   Current default time zone: 'Asia/Tokyo'
   Local time is now:      Fri Dec  8 08:57:31 JST 2023.
   Universal Time is now:  Thu Dec  7 23:57:31 UTC 2023.
   ```

以上で、タイムゾーンが日本になります。

#### タイムゾーンの設定 (コマンドライン)

タイムゾーンは、`/etc/localtime`に保存されています。
このファイルは、システムのタイムゾーン情報をリンクしています。

次の手順で、タイムゾーンを設定します。

1. 旧タイムゾーンの削除:
   旧タイムゾーンファイル`/etc/localtime`を削除します

   ```bash:
   sudo rm -f /etc/localtime
   ```

2. 新タイムゾーンの設定:
   `Asia/Tokyo`のタイムゾーンファイルを`/etc/localtime`にリンクします

   ```bash:
   sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
   ```

3. タイムゾーンの確認:
   `date`コマンドを実行し、タイムゾーンが`JST`になっているかを確認します。

   ```bash:
   date
   Mon Dec  4 06:48:59 PM JST 2023
   ```

   上記のように、`JST`と出力されていれば、タイムゾーンは日本標準時になっています。

以上で、タイムゾーンの設定は終了です。

## 4. Debianの再起動

Debian を再起動します。
これにより、設定したロケールとタイムゾーンがシステム全体に反映され、システムメッセージやエラーメッセージが日本語で表示されるようになります。

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

上記の手順により、`WSL`上の Debian の日本語かに成功しました。
これにより、Debian が出力するシステムメッセージやエラーメッセージが日本語で表示されるようになりました。
システムメッセージやエラーメッセージが日本語で表示されることで、開発中に問題が発生したときに迅速に原因を理解できます。

また、日本語を使ったアプリケーションが開発可能になりました。
国内外向けのソフトウェアを 1つの環境で効率的に開発できます。

日本語化した Debian を活用し、より効率的な開発体験を楽しんでください。
それでは、Happy Hacking!
