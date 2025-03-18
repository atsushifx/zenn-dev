---
title: "WSL 2: APT設定と、Debianメンテナンスガイド"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "APT", "ミラー", "トラブルシューティング" ]
published: false
---

## はじめに

atsushifx です。
この記事では、`WSL 2` (`Windows Subsystem for Linux 2`)環境で、Debian のパッケージマネージャー`APT`を活用したシステムメンテナンス方法を紹介します。
`APT` (`Advanced Package Tool`)は、Debian 系ディストリビューションのパッケージ管理ツールです。
Debian では、さまざまなツールやシステムをパッケージ単位で管理しており、適切な設定を行なうことで、より快適な開発環境を構築できます。

以下の内容について解説します:

- `APT` の基本設定とよく使うコマンド
- ソースリスト　(`sources.list`) の管理と、パフォーマンス向上のためのミラー設定
- `APT`を使った Debian のアップグレード方法
- `APT` に関する一般的なトラブルとその対処法

この記事が、WSL 2 上の Debian を快適に運用するためのツールとなれば幸いです。
Enjoy!

## 1. パッケージマネージャー `apt`

### 1.1 `apt`とは

`apt` (`Advanced Package Tool`) は`Debian`および、その派生ディストリビューションで使用されるパッケージ管理システムです。

### 1.2 `apt`とソースリスト

`apt`は、システム内のソースリストに記載されたリポジトリからパッケージ情報や更新を取得します。
これらのファイルは通常、`/etc/apt/sources.list`または`/etc/apt/sources.list.d/`配下に配置され、各リポジトリの設定内容が記述されています。

### 1.3. 公式ソースリスト

Debian では、`/etc/apt/sources.list`に公式のリポジトリが保存されています。
例えば、以下のような記述がなされます。

```ini:/etc/apt/sources.list
# official sources.list

deb https://deb.debian.org/debian bookworm main
deb https://deb.debian.org/debian bookworm-updates main
deb https://deb.debian.org/debian bookworm-backports main
deb https://security.debian.org/debian-security bookworm-security main
```

### 1.4 `apt`でよく使うコマンド一覧

`APT`では、パッケージの管理を効率的に行なうために、以下の基本コマンドを使用します。

| コマンド | 説明 |
|----------|------|
| `sudo apt update` | パッケージリストを最新の状態に更新する |
| `sudo apt upgrade -y` | 既存のパッケージを最新バージョンに更新する（依存関係は変更しない） |
| `sudo apt full-upgrade -y` | 必要に応じて新しいパッケージをインストール・削除しながらアップグレードする（推奨） |
| `sudo apt dist-upgrade -y` | `full-upgrade` とほぼ同じ動作をする（古い表記） |
| `sudo apt install <パッケージ名>` | 指定したパッケージをインストールする |
| `sudo apt remove <パッケージ名>` | 指定したパッケージを削除する（設定ファイルは残る） |
| `sudo apt purge <パッケージ名>` | 指定したパッケージを完全に削除する（設定ファイルも削除） |
| `sudo apt autoremove` | 依存関係の変更によって不要になったパッケージを削除する |
| `sudo apt clean` | `/var/cache/apt/archives/` に保存されたパッケージファイルをすべて削除する |
| `sudo apt autoclean` | すでに削除された古いパッケージのキャッシュを削除する |
| `apt show <パッケージ名>` | 指定したパッケージの詳細情報を表示する |
| `apt list --installed` | インストール済みのパッケージ一覧を表示する |
| `apt list --upgradable` | アップグレード可能なパッケージ一覧を表示する |
| `sudo apt search <キーワード>` | パッケージの名前や説明にキーワードを含むものを検索する |
| `sudo dpkg --configure -a` | 途中で中断されたパッケージの設定を再実行する |
| `sudo apt --fix-broken install` | 破損したパッケージの依存関係を修復する |

## 2. ソースリストミラーの追加

### 2.1 ソースリストミラーとは

ソースリストミラーとは、公式のリポジトリと同じ内容を保持し、パッケージを提供するサーバー群です。これにより、公式リポジトリの負荷分散や接続速度の向上、さらにはネットワーク障害時のバックアップとしての役割が期待されます。

Debian では、公式のリポジトリに加え、地理的に分散されたミラーサーバーが利用可能です。これらのミラーは、ユーザーの接続環境に合わせて最適なサーバーへ接続を自動的に切り替えることで、より迅速かつ安定したパッケージのダウンロードを実現します。

### 2.2  `Fastly CDN`ミラーの追加

通常、公式`sources.list`にアクセスすると CDN によって一番近いコンテンツプロパイダーの sources.list をアクセスします。
ただし、`CDN`を利用できない場合のために、`Fastly CDN`ミラーの`sources.list`を追加します。

次の手順で、`Fastly CDN`ミラーを追加します。

1. [`Debian mirrors backed by Fastly CDN`](https://deb.debian.org/)にアクセスして、適切な`source`をコピーします

2. `/etc/apt/sources.list.d/cdn-fastly.list`ファイルにコピーした内容を貼り付けます
   内容は、次の通りになります

   ```ini:/etc/apt/sources.list.d/cdn-fastly.list
   # fastly cdn mirror

   deb https://cdn-fastly.deb.debian.org/debian stable main
   deb https://cdn-fastly.deb.debian.org/debian-security stable-security main
   deb https://cdn-fastly.deb.debian.org/debian-security-debug stable-security-debug main
   ```

これで、`Fastly CDN`ミラーの追加は完了です。

### 2.3 日本ミラーの追加

日本ミラーは、日本にある Debian ミラーサーバーによるソースリストミラーです。
日本国内の Debian ユーザーにとっては、地域的に近い日本ミラーを使用することで、迅速なアップグレードが可能です。

次の手順で、日本のミラーを追加します。

1. `sources.list`のコピー:
   [CDN 対応ミラーの設定](https://www.debian.or.jp/community/push-mirror.html)にアクセスし、適切な`sources.list`をコピーします。

2. ミラーリストの作成:
  `/etc/apt/sources.list.d/jpn.list`ファイルに上記の`source`を貼り付けます。
   内容は、次の通りになります。

   ```ini:/etc/apt/sources.list.d/jpn.list
   # Japan official mirror
   deb http://ftp.jp.debian.org/debian/ bookworm main
   deb http://ftp.jp.debian.org/debian/ bookworm-updates main
   deb http://ftp.jp.debian.org/debian/ bookworm-backports main
   ```

   :::message
   bookworm 以外にも、stable、testing といった Debian 公式ミラーで提供されている名前も利用できます
   :::

以上で、日本のミラーの追加は完了です。

## 3. Debian のアップグレード

Debian のアップグレードとは、システムにインストールされているパッケージを最新の状態に更新するプロセスです。WSL 環境では、安定した環境を維持しつつ定期的なアップデートを行なうことで、セキュリティリスクを低減し、最新の機能を利用できます。

### 3.1 アップグレードとは

Debian のアップグレードとは、システムにインストールされているパッケージを最新の状態に更新するプロセスを指します。アップグレードには既存のパッケージを更新する`apt upgrade`とシステム全体のアップグレードを行なう`apt full-upgrade`があります。

<!-- markdownlint-disable line-length -->
| アップグレードの種類 | 概要 | 影響・特性 | 使用すべき場面 |
| --- | --- | --- | --- |
| 通常のアップグレード (apt upgrade) | 既存のパッケージを更新し、システムの安定性を維持する | 依存関係を変更せず、パッケージの追加・削除は行なわない | 日常的な更新、セキュリティ更新 |
| フルアップグレード (apt full-upgrade) | システム全体をアップグレードし、必要に応じて新しいパッケージを追加・不要なパッケージを削除する | 依存関係の変更を許可し、大規模なアップグレードが可能 | メジャーアップグレード時、新しい機能の適用が必要な場合 |

<!-- markdownlint-enable -->

**重要な違い**:

- `apt upgrade` は**安全な更新**で、システムの安定性を優先する。
- `apt full-upgrade` は**影響の大きい更新**を含み、パッケージの追加や削除がありうる。
- `full-upgrade` を実行する前に、アップグレードされるパッケージの一覧を確認することを推奨する。

  ```bash
  apt list --upgradable
  ```

- `full-upgrade` を実行すると、場合によっては古いパッケージが削除されるため、慎重に実行する必要がある。

### 3.2 ソースリストのアップデート

Debian を最新の状態に維持するためには、ソースリストも最新の状態である必要があります。
ソースリストの更新には、`apt update`コマンドを実行します。
これにより、登録されているミラーから最新のパッケージ情報が取得され、アップグレードやセキュリティ更新の対象パッケージが正確に把握されます。

特に、ミラーの追加や設定変更後には、このコマンドを実行することが推奨されます。

次の手順で、ソースリストをアップデートします。

1. `update`コマンド:
   以下のコマンドを実行します。

   ```bash
   sudo apt update
   ```

2. 実行結果:
   以下のメッセージが出力されます。

   ```bash
   Hit:1 http://deb.debian.org/debian bookworm InRelease
   Get:2 <http://deb.debian.org/debian> bookworm-updates InRelease [55.4 kB]
   Get:3 <http://security.debian.org/debian-security> bookworm-security InRelease [48.0 kB]
    .
    .
    .
   Fetched 39.0 MB in 5s (7,607 kB/s)
   Reading package lists... Done
   Building dependency tree... Done
   2 packages can be upgraded. Run 'apt list --upgradable' to see them.
   ```

以上で、ソースリストのアップデートは完了です。

### 3.3 Debian のアップグレード

Debian のアップグレードは、システムにインストールされているパッケージを最新にするプロセスです。
次の手順で、Debian をアップグレードします。

1. アップグレードの実行:

   ```bash
   sudo apt upgrade -y
   ```

2. 実行結果:
   画面には、次のようなメッセージが出力されます。

   ```bash
   Reading package lists... Done
   Building dependency tree... Done
   Calculating upgrade... Done
   The following packages will be upgraded:
    .
    .
    .
   Setting up libgnutls30:amd64 (3.7.9-2+deb12u4) ...
   Processing triggers for libc-bin (2.36-9+deb12u9) ...
   ```

上記のようなメッセージがでれば、アップグレードは完了です。
なお、アップグレードするパッケージによってメッセージは異なります。

### 3.4 Debian のフルアップグレード (`full-upgrade`)

システムアップグレード (`full-upgrade`) は、通常の `upgrade` と異なり、システム全体のパッケージを最新の状態に更新するアップグレード方法です。
アップグレード時に、依存関係が変化したパッケージを追加・削除します。

以下の手順で、システムアップグレードします。

1. **システムの現在の状態を確認**
   Debian のバージョンを確認:

   ```bash
   cat /etc/debian_version
   ```

   アップグレード可能なパッケージ一覧を確認:

   ```bash
   apt list --upgradable
   ```

   削除対象の確認:

   ```bash
   sudo apt full-upgrade --dry-run
   ```

2. **システムの更新**
   パッケージリストを更新:

   ```bash
   sudo apt update
   ```

   `full-upgrade`を実行:

   ```bash
   sudo apt full-upgrade -y
   ```

3. **アップグレード後のクリーンアップ**
   不要なパッケージを削除:

   ```bash
   sudo apt autoremove
   ```

    キャッシュのクリア:

    ```bash
    sudo apt clean
    ```

4. **再起動** (必要な場合)
   カーネルやシステム関連のパッケージが更新された場合は、再起動が必要です。

   WSL環境 (Windows Terminal 上で実行):

   ```powershell
   wsl --shutdown
   ```

### 3.5 アップグレードとシステムアップグレードとの違い

通常の `apt upgrade` と `apt full-upgrade` には次の違いがあります。

| コマンド | 説明 |
| --- | --- |
| `apt upgrade` | 既存のパッケージを更新するが、依存関係は変更しない |
| `apt full-upgrade` | 依存関係が変わる場合も含めて、パッケージを更新・削除・追加する |

例えば、新しいバージョンのパッケージが別のパッケージに置き換えられる場合、`apt upgrade` では変更されませんが、`apt full-upgrade` では適用されます。

アップグレード前に、影響を確認するために以下のコマンドを実行するとよいでしょう。

```bash
apt list --upgradable
sudo apt full-upgrade --dry-run
```

`--dry-run` オプションをつけることで、実際に変更が適用される前にどのようなパッケージが影響を受けるかを確認できます。

### 3.6 セキュリティアップデートとアップグレード

Debian では、セキュリティ更新を迅速に適用することが推奨されています。`WSL`環境でも、以下のコマンドを実行することで、セキュリティ関連のパッケージを優先的に更新できます。

```bash
sudo apt update
sudo apt upgrade -y
```

これにより、`sources.list`に登録されたリポジトリから最新のパッケージ情報を取得し、必要なパッケージを更新できます。

## 4. トラブルシューティング

この章では、`apt`関連のよくあるトラブルと対処法を掲載します。

### 4.1 代表的なトラブルシューティング

#### [SHOT-001] ソースリストの確認、修正

- **原因**:
  - リポジトリに`typo` (スペルミス・入力ミス) がある。
  - 古い Debian のため、リポジトリが廃止された。
    (例: `buster` 以前のリポジトリは `archive.debian.org` に移行されているため、通常のミラーではアクセスできない)

- **対策**:
  リポジトリを確認し、正しいリポジトリに修正する。

  1. リポジトリの確認:
     `cat`コマンドで、現在のリポジトリを確認する。

     ```bash
     cat -n /etc/apt/sources.list
     ```

     追加のリスト (`/etc/apt/sources.list.d`下の設定ファイル) も確認する。

     ```bash
     ls /etc/apt/sources.list.d/
     cat -n /etc/apt/sources.list.d/*.list
     ```

  2. リポジトリの修正:
     エディターで、間違っていたリポジトリを修正する。

     例: `bookworm-backportss` (誤) → `bookworm-backports` (正)

     ```bash
     # バックアップを作成する
     sudo cp /etc/apt/sources.list /etc/apt/sources.list.old
     sudo vi /etc/apt/sources.list
     ```

  3. 更新の確認:
     `apt update`を実行し、リポジトリが正しく動作するかを確認する。

     ```bash
     sudo apt update
     ```

      コンソールに、以下のような出力があれば正常に動作している。

      ```bash
      Hit:1 https://deb.debian.org/debian bookworm InRelease
      Hit:2 https://security.debian.org/debian-security bookworm-security InRelease
      ```

      以上、エラーが出なければ修正は完了です。

#### [SHOT-002] ミラーの変更

- **エラーメッセージ**:
  - `Failed to fetch http://deb.debian.org/debian/dists/bookworm/InRelease  404 Not Found`
  - `The repository 'http://deb.debian.org/debian bookworm InRelease' does not have a Release file.`
  - `Could not resolve 'deb.debian.org'`

- **原因**:
  リポジトリにアクセスできない。
  以下の原因が考えられる

  1. サーバーがダウンしている
  2. DNS 解決に失敗している
  3. リポジトリの URL が変更されている
  4. ネットワークの問題（企業ネットワークの制限など）

- **対策**:
  1. 別のミラーのリポジトリに変更する:
     1.1 リポジトリを日本の公式ミラーに変更する。
         公式がダウンしていた場合や、ダウンロード速度向上のために物理的に近い日本国内のミラーを選ぶことで、高速なダウンロードでのメンテナンスができます。

        1. エディターによる修正

           ```bash
           # バックアップを作成する
           sudo cp /etc/apt/sources.list /etc/apt/sources.list.old
           sudo vi /etc/apt/sources.list
           ```

           ソースリスト:

           ```ini:/etc/apt/sources.list
           # 変更前
           deb https://deb.debian.org/debian bookworm main
           deb https://deb.debian.org/debian bookworm-updates main
           deb https://deb.debian.org/debian bookworm-backports main
           deb https://security.debian.org/debian-security bookworm-security main

           # 変更後
           deb https://ftp.jp.debian.org/debian/ bookworm main
           deb https://ftp.jp.debian.org/debian/ bookworm-updates main
           deb https://ftp.jp.debian.org/debian/ bookworm-backports main
           deb https://security.debian.org/debian-security bookworm-security main
           ```

        2. `sed`による修正:

           ```bash
           sudo sed -e 's|deb.debian.org|ftp.jp.debian.org|' /etc/apt/sources.list > /etc/apt/sources.list.new
           mv /etc/apt/sources.list.new /etc/apt/sources.list
           cat /etc/apt/sources.list
           ```

           上記のコマンドを実行し、リポジトリが　`ftp.jp.debian.org`　になっていれば完了。

     1.2 リポジトリを`Fastly CND`ミラーに変更する
         現在、`httpredir`サービスは、`Fastly CDN`に統合されている。
         そのため、`Fastly CDN`ミラーにドメインを変更する。

        1. エディターによる変更:

           ```bash
           # バックアップを作成する
           sudo cp /etc/apt/sources.list /etc/apt/sources.list.old
           sudo vi /etc/apt/sources.list
           ```

           ソースリスト:

           ```ini:/etc/apt/sources.list
           # 変更前
           deb https://deb.debian.org/debian bookworm main
           deb https://deb.debian.org/debian bookworm-updates main
           deb https://deb.debian.org/debian bookworm-backports main
           deb https://security.debian.org/debian-security bookworm-security main

           # 変更後
           deb https://cdn-fastly.deb.debian.org/debian/ bookworm main
           deb https://cdn-fastly.deb.debian.org/debian/ bookworm-updates main
           deb https://cdn-fastly.deb.debian.org/debian/ bookworm-backports main
           deb https://cdn-fastly.deb.debian.org/debian-security bookworm-security main
           ```

        2. `sed`による変更:

           ```bash
           sudo sed -e 's|deb.debian.org|cdn-fastly.deb.debian.org|' /etc/apt/sources.list > /etc/apt/sources.list.new
           mv /etc/apt/sources.list.new /etc/apt/sources.list
           cat /etc/apt/sources.list
           ```

           上記のコマンドを実行し、リポジトリが　`cdn-fastly.deb.debian.org`　になっていれば完了。

  2. リポジトリの更新:
     `apr update`を実行し、リポジトリを更新する

     ```bash
     sudo apt update
     ```

     エラーが起きなければ、正常終了。

#### [SHOT-003] `archive`への変更

#### [SHOT-004] キャッシュのクリア、再構築

#### [SHOT-005] 再試行

### 4.2 ネットワーク関連 (NET)

#### [NET-001] 名前解決エラー (DNSの問題)

- **トラブル**: `エラーで`apt`リポジトリが更新できない
- **コマンド**: `sudo apt update`
- **エラーメッセージ:**
  - `Err: http://security.debian.org/debian-security> bookworm-security InRelease`
      `Temporary failure resolving 'security.debian.org'`
    `エラー: http://security.debian.org/debian-security> bookworm-security InRelease`
      `'security.debian.org'の名前解決に一時的に失敗しました`
  - `Failed to fetch http://deb.debian.org/debian/dists/bookworm/InRelease`
      `Temporary failure resolving 'deb.debian.org'`
    `http://deb.debian.org/debian/dists/bookworm/InRelease の取得に失敗しました`
      `'deb.debian.org'の名前解決に一時的に失敗しました`

- **原因**:
　ネットワーク接続に問題や DNS サーバーに問題があり、ホストの名前解決に失敗している。

- **対処法**:
  次の手順で、問題に対処します。

  1. ネットワーク接続の確認:
     `ping`コマンドで、外部インターネットへの接続を確認します。
     (例: `ping 8.8.8.8`を実行し、パケットが返ってくるかを確認)

  2. DNS 設定の確認:
     (例: `dig google.com`で IP アドレスが解決できるかを確認)

  3. DNS サーバーの変更または追加:
     信頼性の高いパブリック DNS (例: Google の 8.8.8.8、Cloudflare の 1.1.1.1) に変更または追加します。
     `/etc/resolv.conf`、以下の記述を追加します。

     ```conf:/etc/resolv.conf
     nameserver 8.8.8.8
     nameserver 1.1.1.1
     ```

  4. ネットワークサービスの再起動:
     設定の変更をシステムに反映させるため、ネットワークを再起動します。

     ```bash
     sudo /bin/systemctl restart networking
     ```

  5. 再度確認:
     `sudo apt update`を実行し、エラーが解消されているか確認します。

#### [NET-002] 404エラー (リポジトリのファイルが見つからない)

- **トラブル**: `apt update` を実行した際に、リポジトリの URL にアクセスできない、または対象のファイルが見つからない
- **コマンド**: `sudo apt update`
- **エラーメッセージ:**
  - `Err: http://ftp.debian.org/debian bookworm-backportss Release`
      `404 Not Found [IP: xxx.xxx.xxx.xxx 80]`
    `エラー: http://ftp.debian.org/debian bookworm-backportss Release``
      `404 ファイルが見つかりません[IP: xxx.xxx.xxx.xxx 80]`
  - `Err: http://security.debian.or.jp/debian-security bookworm-security InRelease`
      `Could not resolve 'security.debian.or.jp'`
    `エラー: http://security.debian.or.jp/debian-security bookworm-security InRelease`
      `'security.debian.or.jp'の名前解決に失敗しました`

- **原因:**
  1. **タイポ (入力ミス)**
     - `sources.list` に誤ったリポジトリURL が記載されている可能性があります。
       例: `bookworm-backportss` (誤) → `bookworm-backports` (正)

  2. **リポジトリの廃止**
     - 古い Debian のリリース (`oldstable` など) では、一部のミラーが利用不能になる場合があります。
     - `security.debian.or.jp` のようなドメインが失効した可能性もあります。

  3. **ミラーサーバーの同期遅れ**
     - ミラーサーバーの同期が完了する前にアクセスすると、パッケージを取得できない場合があります。

- **対処法:**
  1. **`sources.list` を確認し、誤りがないかチェック**:
     次のコマンドを実行し、リポジトリの設定を確認します。

     ```bash
     cat /etc/apt/sources.list
     ```

     または、カスタムリストを確認：

     ```bash
     ls /etc/apt/sources.list.d/
     cat /etc/apt/sources.list.d/*.list
     ```

     誤った URL が含まれている場合は、公式の `sources.list` に修正します。

     ```ini:/etc/apt/sources.list
     deb http://deb.debian.org/debian bookworm main
     deb http://deb.debian.org/debian bookworm-updates main
     deb http://security.debian.org/debian-security bookworm-security main
     ```

  2. **リポジトリのミラーを変更**:
     日本の公式ミラーに変更する:

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://ftp.jp.debian.org|' /etc/apt/sources.list
     ```

     古いリリース向けに `archive.debian.org` を使用:

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://archive.debian.org|' /etc/apt/sources.list
     ```

  3. **キャッシュをクリア**:
     `apt clean`を実行する:

     ```bash
     sudo apt clean
     sudo rm -rf /var/lib/apt/lists/*
     sudo apt update
     ```

  4. **`httpredir.debian.org` を試す**:
     `httpredir`で最適なミラーを自動選択：

     ```bash
     deb http://httpredir.debian.org/debian bookworm main contrib non-free
     ```

  5. **Debian のリリースバージョンを確認**:
     リリースバージョンを確認:

     ```bash
     cat /etc/debian_version
     ```

     リリースが古すぎる場合、oldstable のミラーに変更:

     ```bash
     deb http://deb.debian.org/debian oldstable main contrib non-free
     deb http://security.debian.org/debian-security oldstable-security main contrib non-free
     ```

#### [NET-003] Releaseファイル期限切れエラー

- **トラブル:** `apt update`時に`Release`ファイルが原因でエラーが発生する
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Release file for http://deb.debian.org/debian/dists/bookworm-updates/InRelease is expired`
      `(invalid since 10d 2h 30min 15s).`
    `http://deb.debian.org/debian/dists/bookworm-updates/InRelease のリリースファイルの有効期限が切れています (10日2時間30分15秒前から無効)`
  - `Updates for this repository will not be applied.`
    `このリポジトリへの更新は適用されません。`

- **原因:**
  1. システムの日時がズレている
     システムの時計がリポジトリの `Release`ファイルのタイムスタンプと合っていない場合、期限切れと誤認識されることがあります。

  2. リポジトリのメンテナンス遅延
     Debian のミラーサーバーの更新が遅れている場合、古い `Release`ファイルが提供され続けてしまうことがあります。

  3. ローカルのキャッシュが古い
    `apt update` のキャッシュが古いために、新しい `Release`ファイルが取得されていない可能性があります。

- **対処法:**
  1. **システムの日時を確認し、修正する**
     現在の日時を確認する:

     ```bash
     date
     ```

     日時が大きくズレている場合は、以下のコマンドで NTP サーバーと同期する:

     ```bash
     sudo ntpdate -u ntp.nict.jp
     ```

     または、`systemd-timesyncd` を利用する場合:

     ```bash
     sudo systemctl restart systemd-timesyncd
     ```

  2. **キャッシュの再構築**
     以下のコマンドで、`apt`のキャッシュをクリア、再構築する:

     ```bash
     sudo rm -rf /var/lib/apt/lists/*
     sudo apt clean
     sudo apt update
     ```

  3. **リポジトリのミラーを変更**
     日本のミラーに変更する：

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://ftp.jp.debian.org|' /etc/apt/sources.list
     ```

     標準ミラーが問題を起こしている場合は、`httpredir.debian.org` を使用して最適なミラーを自動選択する:

     ```ini:/etc/apt/sources.list
     deb http://httpredir.debian.org/debian bookworm main contrib non-free
     ```

  4. **システムのリブート:**
     Debian を再起動して、上記の修正を反映させる:

     ```bash
     sudo reboot
     ```

#### [NET-004] Releaseファイル不在エラー (ミラーの問題)

- **トラブル:** リポジトリをダウンロードするときに`Release`ファイルが見つからなかった
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**<!-- textlint-disable ja-technical-writing/sentence-length -->
  - `The repository 'http://ftp.debian.org/debian bookworm-backportss Release' does not have a Release file.`
    `リポジトリ 'http://ftp.debian.org/debian' bookworm-backportss Release' にリリースファイルが存在しません`
  - `Updating from such a repository can't be done securely, and is therefore disabled by default.`
    `このリポジトリからのアップデートは安全に行えないため、デフォルトで無効化されています`
    <!-- textlint-enable -->

- **原因:**
  1. リポジトリのミラー設定ミス
     `sources.list の記述が誤っている。`
     例: bookworm-backportss (誤) → bookworm-backports (正)

  2. リポジトリの廃止
     古い Debian リリースでは、一部のミラーが利用不能になっている可能性がある。

  3. ミラーサーバーの同期遅延
     ミラーサーバーのデータが最新でないため、一時的に`Release`ファイルを見つけられない場合がある。

- **対処法:**
  1. **ソースリストの確認**
     `sources.list`を確認し、誤りがないかチェック:

     ```bash
     cat /etc/apt/sources.list
     ```

     カスタムリストがある場合:

     ```bash
     ls /etc/apt/sources.list.d/
     cat /etc/apt/sources.list.d/*.list
     ```

     正しい記述の例:

     ```ini:/etc/apt/sources.list
     deb http://deb.debian.org/debian bookworm main contrib non-free
     deb http://deb.debian.org/debian bookworm-updates main contrib non-free
     deb http://security.debian.org/debian-security bookworm-security main contrib non-free
     ```

  2. **リポジトリのミラーを変更**
     - 日本の公式ミラーに変更:

       ```bash
       sudo sed -i 's|http://deb.debian.org|http://ftp.jp.debian.org|' /etc/apt/sources.list
       ```

     - 古いリリース向けに `archive.debian.org` を使用:

       ```bash
       sudo sed -i 's|http://deb.debian.org|http://archive.debian.org|' /etc/apt/sources.list
       ```

  3. **キャッシュのクリア、再構築**
     `apt`のキャッシュをクリア、再構築する:

     ```bash
     sudo apt clean
     sudo rm -rf /var/lib/apt/lists/*
     sudo apt update
     ```

  4. **`httpredir.debian.org`を試す**
     `httpredir` を利用して、最適なミラーが自動選択する:

     ```ini:/etc/apt/sources.list
     deb http://httpredir.debian.org/debian bookworm main contrib non-free
     ```

  5. **Debian のリリースバージョンを確認**
     Debian のバージョンを確認:

     ```bash
     cat /etc/debian_version
     ```

     古いリリースの場合、`oldstable` に変更:

      ```ini:/etc/apt/sources.list
      deb http://deb.debian.org/debian oldstable main contrib non-free
      deb http://security.debian.org/debian-security oldstable-security main contrib non-free
      ```

  6. **ミラーが復旧するまで待つ**
     一時的なミラーの同期遅延である可能性もあるため、数時間後に再試行する。

### 4.3 APTの設定関連 (APT)

#### [APT-001] ソースリスト不正エラー (sources.list の記述ミス)

- **トラブル:** `apt update`時に、ソースリストからがリポジトリ情報を正しく読み込めない。
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Malformed entry 1 in list file /etc/apt/sources.list (Component)`
    `リストファイル /etc/apt/sources.list のエントリ 1 に誤りがあります (コンポーネントの問題)`
  - `The list of sources could not be read.`
    `ソースリストを読み取ることができませんでした。`

- **原因:**
  - ソースリストの記述ミス (例: スペルミス、構文ミス)
  - 不適切な文字や空白が含まれている
  - 無効なリポジトリURL を指定している

- **対処法:**
  1. **ソースリストの確認**
     ソースリストを行番号付きで出力し、構文エラーがある行を特定する:

     ```bash
     cat -n /etc/apt/sources.list
     ```

  2. **正しいフォーマットの確認**
     - 正しい `sources.list` の例:

       ```ini:/etc/apt/sources.list
       deb http://deb.debian.org/debian bookworm main contrib non-free
       deb http://security.debian.org/debian-security bookworm-security main contrib non-free
       deb http://deb.debian.org/debian bookworm-updates main contrib non-free
       ```

     - 間違った例:

       ```ini:/etc/apt/sources.list
       deb http://deb.debian.org/debian/bookworm main contrib non-free  # debianの後の'/'が不要
       deb http://security.debian.org/debian-security bookworm security # "security" は不要
       ```

  3. **ソースリストの修正**
     エディターを使用して、`sources.list` を編集:

     ```bash
     sudo vi /etc/apt/sources.list
     ```

     誤った行を修正して、保存。　(`[ESC]:wq → [Enter]`)

  4. **フォーマットの修正**
     リストのフォーマットを修正:

     ```bash
     sudo sed -i '/^#/d' /etc/apt/sources.list        # コメント行を削除
     sudo sed -i 's/\s\s*/ /g'  /etc/apt/sources.list # 余分な空白を削除
     ```

  5. **`apt update`の実行**
     ソースリストを修正後に、再度、`apt update`を実行:

     ```bash
     sudo apt update
     ```

#### [APT-002] 公式リポジトリの署名エラー (公開鍵エラー)

- **トラブル:** `apt update`時に、`GPG error`が発生する
- **コマンド:** `sudo apt update`
<!-- markdownlint-disable line-length -->
- **エラーメッセージ:** <!-- textlint-disable ja-technical-writing/sentence-length -->
  - `GPG error: http://example.com/debian bookworm InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 1234567890ABCDEF`
    `GPG エラー: http://example.com/debian bookworm InRelease: 次の署名を検証できませんでした。公開鍵 '1234567890ABCDEF' が利用できません:`
  - `The repository 'http://example.com/debian bookworm InRelease' is not signed.`
    `リポジトリ 'http://example.com/debian bookworm InRelease' は署名されていません。`
  <!-- textlint-enable -->
<!-- markdownlint-enable -->

- **原因:**
  - 公式リポジトリの GPG 公開鍵が登録されていない
  - ミラーサイトの GPG 鍵が変更された
  - `sources.list` に未署名のリポジトリが含まれている

- **対処法:**
  1. **GPG 鍵の追加**
     GPG 鍵を取得し、`.gpg`として追加:

     ```bash
     sudo gpg --export 1234567890ABCDEF | sudo tee /etc/apt/trusted.gpg.d/external-repo-key.gpg > /dev/null
     ```

  2. **署名の更新**
     リポジトリの署名を手動で更新する:

     ```bash
     sudo apt update --allow-releaseinfo-change
     ```

  3. **リストの更新**
     再度、リストを更新する:

     ```bash
     sudo apt update
     ```

  4. **未署名リポジトリの削除**
     ソースリストから、未署名リポジトリを削除:

     ```bash
     sudo vi /etc/apt/sources.list
     ```

     `deb http://example.com/debian bookworm main` のような未署名リポジトリを削除。

#### [APT-003] ミラーの同期問題 (ハッシュサム不一致)

- **トラブル:** ミラーサイトのファイルが破損している、または、同期が不完全
- **コマンド:** `sudo apt update`
- **エラーメッセージ:** <!-- textlint-disable ja-technical-writing/sentence-length -->
  - `Err: http://deb.debian.org/debian bookworm/main amd64 Packages`
    `エラー: http://deb.debian.org/debian bookworm/main amd64 パッケージ`
  - `Hash Sum mismatch`
    `ハッシュサム 不一致`
  - `Failed to fetch http://deb.debian.org/debian/dists/bookworm/main/binary-amd64/Packages.xz`
      `Hash Sum mismatch`
    `http://deb.debian.org/debian/dists/bookworm/main/binary-amd64/Packages.xz の取得に失敗しました。 ハッシュサム 不一致`
  <!-- textlint-enable -->

- **原因:**
  - ミラーサイト上のパッケージファイルが破損している
  - ミラーサーバーとの同期が不完全で、正しいハッシュ値が取得できていない
  - 一時的なネットワーク障害やダウンロードの不具合によって、ファイルの内容が不完全または破損している
  - 古いキャッシュが原因で、最新のハッシュ情報と一致していない

- **対処法:**
  1. **キャッシュのクリア**
     `apt`のキャッシュをクリアし、古いキャッシュにより問題が起こる可能性を排除します:

     ```bash
     sudo apt clean
     sudo rm -rf /var/lib/apt/lists/*
     ```

  2. **再度、更新**
     `apt update`を実行し、リストを更新する:

     ```bash
     sudo apt update
     ```

  3. **ミラーの変更**
     別のミラーに変更するか、公式の自動選択ミラー (例:`httpredir.debian.org`) を利用する:

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://ftp.jp.debian.org|' /etc/apt/sources.list
     ```

  4. **時間をおいて再試行**
     ミラーサーバーの同期が遅れている場合は、時間をおいて、再度更新します。

     ```bash
     sudo apt update
     ```

      場合によっては、これで問題が解決します。

#### [APT-004] ミラーの同期問題 (ファイルサイズ不一致)

<!-- markdownlint-disable line-length -->>
- **トラブル**: ミラーファイルのサイズが予期されたものと異なっている
- **コマンド:** `sudo apt update`
- **エラーメッセージ:** <!--textlint-disable ja-technical-writing/sentence-length -->
  - `Err: http://deb.debian.org/debian bookworm/main Sources`
    `エラー: http://deb.debian.org/debian bookworm/main Sources`
  - `File has unexpected size (8636652 != 8633788). Mirror sync in progress?`
    `予期しないファイルサイズ (8636652 != 8633788) です。ミラーの同期が進行中の可能性があります。`
  - `Failed to fetch http://deb.debian.org/debian/dists/bookworm/main/source/Sources.gz File has unexpected size (8636652 != 8633788)`
    `http://deb.debian.org/debian/dists/bookworm/main/source/Sources.gz の取得に失敗しました。ファイルサイズが予期しない値 (8636652 != 8633788) です。`/
  <!-- textlint-enable -->
<!-- markdownlint-enable -->

- **原因:**
  - ミラーサーバーの同期中に、ファイルサイズが正しく反映されていない可能性
  - 一時的な同期遅延によるサイズの不一致

- **対処法:**
  1. **キャッシュのクリアと再構築**

     ```bash
     sudo apt clean
     sudo rm -rf /var/lib/apt/lists/*
     sudo apt update
     ```

  2. **数時間後に再試行:**
     ミラーの同期が完了しているか確認するため、数時間後に再度 `sudo apt update` を実行する:

     ```bash
     sudo apt update
     ```

  3. **ミラーの変更**
     別のミラーサーバーへ変更するか、自動選択ミラー (例: `httpredir.debian.org`) を利用する:

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://ftp.jp.debian.org|' /etc/apt/sources.list
     ```

#### [APT-005] 特定のリポジトリが無効 (不適切な sources.list 設定)

- **トラブル:** 存在しないリポジトリ、無効なリポジトリにアクセスしようとした
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `The repository 'http://archive.debian.org/debian bookworm Release' does not have a Release file.`
    `リポジトリ 'http://archive.debian.org/debian bookworm Release' には Releaseファイルがありません。`

- **原因:**
  1. **リポジトリの URL が間違っている**
     `/etc/apt/sources.list` や `/etc/apt/sources.list.d/`下のファイルに誤ったリポジトリ URL が記述されている。
     (例: `bookworm` の代わりに `buster` などの古いバージョンを指定している。)

  2. **リポジトリが削除または移動された**
     旧バージョンのリポジトリが `archive.debian.org` に移動されている場合がある。

  3. **署名の問題**
     - Debian のリポジトリには `Release` ファイルが含まれるが、署名を必要とする場合がある。
     - `InRelease` ファイルが見つからない場合、GPG キーの問題が影響していることもある。

- **対処法:**
  1. **ソースリストの確認と修正**
     ソースリストを確認する:

     ```bash
     cat -n /etc/apt/sources.list
     ```

     追加のリストを確認する:

     ```bash
     ls /etc/apt/sources.list.d/
     cat -n /etc/apt/sources.list.d/*.list
     ```

     正しいフォーマットの例:

     ```ini:/etc/apt/sources.list
     deb http://deb.debian.org/debian bookworm main contrib non-free
     deb http://security.debian.org/debian-security bookworm-security main contrib non-free
     deb http://deb.debian.org/debian bookworm-updates main contrib non-free
     ```

     ソースファイルの修正:

     ```bash
     sudo vi /etc/apt/sources.list
     ```

     誤ったリポジトリを修正後、`:wq`でファイルを保存します。

  2. **`archive`の利用**
     古いバージョンの Debian (例:`buster`, `stretch`) を利用している場合は、公式の `archive.debian.org` を利用する必要があります。

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://archive.debian.org|' /etc/apt/sources.list
     ```

  3. ミラーの変更 (自動選択ミラー)
     `Debian`では、最適なミラーを自動選択する`httpredir.debian.org`を利用できます。

     ```bash
     sudo sed -i 's|http://deb.debian.org|http://httpredir.debian.org|' /etc/apt/sources.list
     ```

  4. GPG キーの更新
     GPG キーが原因でエラーが発生する場合、以下のコマンドで鍵を追加します:

     <!-- markdownlint-disable line-length -->
     ```bash
     echo "de [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg http://deb.debian.org/debian bookworm main" | sudo tee /etc/apt/sources.list.d/debian.list
     ```
     <!-- markdownlint-enable -->

  5. **キャッシュのクリアと再構築**
     `apt`のキャッシュをクリアし、再構築する：

     ```bash
     sudo apt clean
     sudo rm -rf /var/lib/apt/lists/*
     sudo apt update
     ```

  以上で、特定のリポジトリが無効になっている問題を解決できます。

### 4.4 Debian システム関連 (SYS)

#### [SYS-001] dpkg中断エラー (前回の処理が中断された)

- **トラブル:** 前回の処理が中断された状態で、新しい操作をしようとした
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.`

#### [SYS-002] 依存関係エラー (パッケージ間の依存関係未解決)

- **トラブル:** `apt update`時に、`Unmet dependencies`となって終了する。
- **コマンド:**　`sudo apt update`
- **エラーメッセージ:**
  - `The following packages have unmet dependencies:`
  - `npm : Depends: nodejs but it is not going to be installed`
  - `Unmet dependencies. Try 'apt --fix-broken install' with no packages (or specify a solution).`

#### [SYS-003] ロック競合エラー (別プロセスがロックを使用中)

- **トラブル:** `apt update`時に、ロックに失敗する
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)`
  - `Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?`

#### [SYS-004] ロック権限エラー (root権限不足)

- **トラブル:** `aot update`時に、ロックに失敗する(`Permission denied`)
- **コマンド:** `apt update`
- **エラーメッセージ:**
  - `Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)`
  - `Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?`

#### [SYS-005] 空き容量不足エラー (ディスク容量不足)

- **トラブル:** 空き容量不足でコマンドが実行できない
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `You don't have enough free space in /var/cache/apt/archives/.`

### 4.5 パッケージ関連 (PKG)

#### [PKG-001] 依存関係エラー (パッケージのバージョン問題)

- **トラブル:** 依存関係の問題で、パッケージがインストールできない
- **コマンド:** `sudo apt install <package>`
- **エラーメッセージ:**
  - `Unmet dependencies. Try 'apt --fix-broken install' with no packages (or specify a solution).`

#### [PKG-002] 必須パッケージが削除されたエラー (パッケージ削除により apt upgrade 失敗)

- **トラブル:** システムに必須なパッケージを削除してしまった。
- **コマンド:** `apt remove <package>`
- **エラーメッセージ:**
  - `The package 'xyz' needs to be reinstalled, but I can't find an archive for it.`

### 4.6 キャッシュ関連 (CACH)

#### [CACH-001] キャッシュ破損 (/var/lib/apt/lists/ や /var/cache/apt/archives/ の破損)

- **トラブル:** キャッシュの問題で、`apt update`ができない
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Failed to fetch http://deb.debian.org/debian/dists/bookworm/InRelease`
  - `Some index files failed to download. They have been ignored, or old ones used instead.`

#### [CACH-002] キャッシュの不整合 (apt update 直後にエラー発生)

- **トラブル:** `apt update`時に`Unable to parse`エラーが出る
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Unable to parse package file /var/lib/apt/lists/...`
  - `The package lists or status file could not be parsed or opened.`

### 4.7 その他 (MISC)

#### [MISC-001] システム時計ずれ (HTTPSリポジトリの証明書エラー)

- **トラブル:** `apt update`時に証明書などでエラーが発生する
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Failed to fetch https://example.com/debian/dists/bookworm/InRelease`
  - `SSL: certificate date invalid`

#### [MISC-002] 特殊な環境依存エラー (WSL, Docker, Proxmox など)

- **トラブル:** `WSL`,`Docker`などの環境に依存するエラー
- **コマンド:** `sudo apt update`
- **エラーメッセージ:**
  - `Unable to locate package xyz`
  - `Package 'xyz' has no installation candidate`

####

## おわりに

## 参考資料

### Webサイト

- [第2章 Debian パッケージ管理](https://www.debian.org/doc/manuals/debian-reference/ch02.ja.html):
  公式リファレンスによる、Debian のパッケージ管理方法

- [Debian mirrors backed by Fastly CDN](https://deb.debian.org/):
  Fastly が提供する CDN ミラー

- [CDN 対応ミラーの設定](https://www.debian.or.jp/community/push-mirror.html):
  Debian 日本サイトの CDN ミラー

- [Debian SourcesList](https://wiki.debian.org/SourcesList):
  Debian Wiki による、sources.list の解説
