---
title: "WSL上のDebianを日本語化する方法"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "apt", "日本語", "開発環境" ]
published: true
---

## はじめに

この記事では、**Windows Subsystem for Linux (WSL)** 上の Debian を日本語化し、システムメッセージやエラーメッセージを日本語で出力する方法について解説します。

インストール直後の`WSL`上の Debian は、英語ロケールに設定されています。
そのため、診断やデバッグの際にシステムメッセージやエラーメッセージが英語で出力されるため、理解するまでに時間がかかります。
それらの問題を解消するために、Debian を日本語化して、システムメッセージやエラーメッセージを日本語にします。

## 用語解説

- **Windows Subsystem for Linux (WSL)**:
  Windows 上で　Linux バイナリを実行させるための仮想実行環境

- **Debian**:
  自由ソフトウェアを基にオープンなモデルで開発された Linux ディストリビューション

- **ロケール** (`locale`):
  特定地域の言語と習慣に基づく情報を含むデータベース

- **デフォルトロケール**
  システム全体で使用されるデフォルトのロケール

- **タイムゾーン** (`timeZone`):
  地球上の標準時間を定義するための地域ごとの区分

- **`apt`**:
  `Debian`および派生ディストリビューションで使われているパッケージ管理システム。ソフトウェアのインストール、アップデート、削除などを行なえる

- **`dpkg-reconfigure`**:
  Debian において、インストール済みのパッケージの設定を対話形式で再設定するコマンド

- **`task-japanese`**:
  日本語環境の構築に必要なユーティリティや日本語フォントなどの各種パッケージを一括でインストールするためのメタパッケージ

## 1. Debianの日本語化手順の概要

以下の手順に沿って`WSL`上の Debian を日本語化します。

1. Debian上でコマンド`sudo apt`を使い、日本語対応パッケージ`task-japanese`をインストール
2. 日本語ロケールを追加し、`デフォルトロケール`を日本語ロケール (`ja_JP.UTF-8`)に設定
3. タイムゾーンを日本時間 (`Asia/Tokyo`)に設定
4. 設定を反映させるために、Debian を再起動

以上の手順で、Debian を日本語化できます。

## 2. 日本語対応パッケージ`task-japanese`の導入

Debian には、日本語環境の設定に特化したパッケージ`task-japanese`があります。
`task-japanese`は、日本語対応用の機能を追加するために、日本語対応したユーティリティや日本語フォントなどのパッケージを 1つにまとめたメタパッケージです。

### 2.1 日本語対応パッケージ`task-japanese`を導入する

Debian を日本語対応にするための追加パッケージ`task-japanese`をインストールします。
`bash`上で次のコマンドを実行します:

```bash
sudo apt install -y task-japanese
```

実行結果は、次のとおりです。

```bash
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

## 3. Debianの日本語ロケールとタイムゾーンの設定

Debian を日本語化するためには、以下の 2つの設定が必要です。

1. デフォルトロケールを日本語 (`ja_JP.UTF-8`)に設定すること
2. `タイムゾーン`を日本標準時 (`Asia/Tokyo`, `JST`)に設定すること

以下のセクションで、それぞれの設定方法を解説します。

### 3.1 日本語ロケールの設定

Debian に日本語ロケール (`ja_JP.UTF-8`)を追加して、これを`デフォルトロケール`として設定します。
日本語ロケールを追加することで、システムメッセージなどが日本語で出力できるようになります。
デフォルトロケールを日本語にすることで、通常使用の時にメッセージが日本語になります。

#### 日本語ロケールの設定 (対話式)

次の手順で、ロケールを日本語に設定します。

1. `dpkg-reconfigure` の起動:
   コマンドラインで次のコマンドを実行します。

   ```bash
   sudo /usr/sbin/dpkg-reconfigure locales
   ```

   ![localesダイアログ - 生成するためのロケールのリストアップ](https://i.imgur.com/fVyJZ74.png)
   *図: `locales`ダイアログ*

2. 日本語ロケールの選択:
  ダイアログの`Locales to be generated`項目の`ja_JP.UTF8 UTF-8`をチェックして、\[OK]をクリックします。
   ![`Locales to be generated`ダイアログ - 生成するロケールの選択](https://i.imgur.com/HMVJETO.png)
   *図: `Locales to be generated`ダイアログ*

3. デフォルトロケールの選択:
   `Configuring Locales`ダイアログが表示されます。
    `ja_JP.UTF-8`を選択して、\[OK]をクリックします。

   ![`Configuring Locales`ダイアログ - デフォルトロケールの選択](https://i.imgur.com/WOg7MF3.png)
   *図: `Configuring Locales`ダイアログ*

4. ロケールの作成:
   `dpkg-reconfigure`が`locale`を作成します。
   以下のように、`ja_JP.UTF-8`が追加されていれば設定成功です。

   ```bash
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
   次のコマンドを実行し、`ja_JP.UTF-8`をロケールに追加します。

   ```bash
   sudo sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/ig' /etc/locale.gen >/etc/locale.gen.new
   sudo mv /etc/locale.gen.new /etc/locale.gen
   # sedで日本語ロケールのコメントを外し、/etc/locale.genに書き戻す
   ```

   ここでは、`sed`を使って`/etc/locale.gen`から日本語ロケールのコメントを外しています。
   本来は、`/etc/locale.gen.new`を`mv`する前に、日本語ロケールが追加されているかを確認すべきです。

2. ロケールの再作成:
   `ja_JP.UTF-8`を含んだロケールを作成します。

   ```bash
   sudo /usr/sbin/locale-gen
   ```

   実行結果は、次のようになります:

   ```bash
   Generating locales (this might take a while)...
     en_US.UTF-8... done
     ja_JP.UTF-8... done
   Generation complete.
   ```

   上記のようにロケールに`ja_JP.UTF-8`が含まれていれば、日本語ロケールが追加されています。

3. デフォルトロケールを日本語ロケールに設定:
   `update-locale`でデフォルトロケールを変更します。

   ```bash
   sudo /usr/bin/update-locale LANG=ja_JP.UTF-8
   ```

以上で、日本語ロケールの設定は完了です。

### 3.2 タイムゾーンの設定

Debian を日本語環境にするため、タイムゾーンを設定します。
具体的には、タイムゾーンを日本時間 (`Asia/Tokyo`, `JST`)に設定します。
これにより、ログなどの時刻が日本時間で表示されるため、時間に関する混乱が少なくなります。

#### タイムゾーンの設定 (対話式)

次の手順で、タイムゾーンを`Asia/Tokyo` ('JST') に設定します。

1. `dpkg-reconfigure`の起動:
  コマンドラインで、次のコマンドを実行します。

   ```bash
   sudo /usr/sbin/dpkg-reconfigure tzdata
   ```

   ![`tzdata`設定ダイアログ](https://i.imgur.com/DbvibFq.png)
   *図: `tzdata`設定ダイアログ*

2. `tzdata`の設定:
   `tzdata`に、`Asia`,`Tokyo`を選択します。

   ![タイムゾーン設定ダイアログ](https://i.imgur.com/z5Fmt0R.png)
   *図: タイムゾーン設定ダイアログ*

3. タイムゾーンの設定:
   実行結果は、次のようになります。

   ```bash
   Current default time zone: 'Asia/Tokyo'
   Local time is now:      Fri Dec  8 08:57:31 JST 2023.
   Universal Time is now:  Thu Dec  7 23:57:31 UTC 2023.
   ```

以上で、タイムゾーンが日本時間になります。

#### タイムゾーンの設定 (コマンドライン)

タイムゾーンは、`/etc/localtime`に保存されている要素です。
このファイルは、システムのタイムゾーン情報をリンクしています。

次の手順で、タイムゾーンを設定します。

1. 旧タイムゾーンの削除:
   旧タイムゾーンファイル`/etc/localtime`を削除します

   ```bash
   sudo rm -f /etc/localtime
   ```

2. 新タイムゾーンの設定:
   `Asia/Tokyo`のタイムゾーンファイルを`/etc/localtime`にリンクします

   ```bash
   sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
   # タイムゾーン`Asia/Tokyo`を`localtime`に設定する
   ```

3. タイムゾーンの確認:
   `date`コマンドを実行し、タイムゾーンが`JST`になっているかを確認します。

   ```bash
   date
   Mon Dec  4 06:48:59 PM JST 2023
   ```

   上記のように、`JST`と出力されていれば、タイムゾーンは日本標準時になっています。

以上で、タイムゾーンが日本時間に設定しました。

## 4. Debianの再起動 (日本語設定の適用)

Debian を再起動します。
この操作により、設定したロケールとタイムゾーンがシステム全体に反映され、システムメッセージやエラーメッセージが日本語で表示されるようになります。

### 4.1 Debianを再起動する

次の手順で、Debian を再起動します。

1. Debian コンソールの終了
   `exit`を入力し、Debian コンソールを終了します

2. Debian の終了
   `PowerShell`上で次のコマンドを入力し、Debian を終了します

   ```powershell:
   wsl --terminate Debian
   ```

3. Debian の起動
   Debian コンソールを起動します。日本語化した Debian が起動します

以上で、Debian の再起動が終了しました。
再起動により、設定したロケールと`タイムゾーンがシステムに反映されます。

たとえば、`date`コマンドでは日時が次のように表示されます。

```bash
2023年 12月  8日 金曜日 11:34:06 JST
```

## おわりに

上記の手順を行なうことで、WSL上の Debian を日本語化できました。
これにより、Debian が出力するシステムメッセージやエラーメッセージが日本語で表示されるようになりました。
システムメッセージやエラーメッセージが日本語で表示されることで、開発中に問題が発生したときに迅速に原因を理解できます。

また、日本語を用いたアプリケーションの開発も可能になりました。
国内外向けのソフトウェアを 1つの環境で高効率に開発できます。

日本語化した Debian を利用することで、開発作業の効率が向上し、よりよい開発体験が得られます。
これからも、素敵なプログラミングライフをお過ごしください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL - Wikipedia: <https://ja.wikipedia.org/wiki/Windows_Subsystem_for_Linux>
- WSL - Microsoft learn: <https://learn.microsoft.com/ja-jp/windows/wsl/about>
- `task-japanese` - `Debian packages``: <https://packages.debian.org/ja/sid/task-japanese>
- Debian 管理者ハンドブック: <https://debian-handbook.info/browse/ja-JP/stable/>
