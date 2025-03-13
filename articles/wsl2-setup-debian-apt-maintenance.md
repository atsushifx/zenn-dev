---
title: "WSL 2: APT設定と、Debianメンテナンスガイド"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "APT", "ソースリスト" ]
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

この記事が、`WSL 2`上の Debian を快適に運用するためのツールとなれば幸いです。
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

### 1.4 追加のコンポーネント

Debian では、`main` 以外にも `contrib` や `non-free` などのコンポーネントが存在します。
これらのコンポーネントを `sources.list` に追加することで、より多くのパッケージを利用できるようになります。

| コンポーネント | 概要 |　ソフトウェアの例 |
| --- | --- | --- |
| `main` | Debian の公式パッケージで、完全にフリーなソフトウェアのみを含む | `gcc`. `bash`, `vim` |
| `contrib` | 自由なソフトウェアだが、動作に非自由なソフトウェアが必要なもの | `VirtualBox` |
| `non-free` | 非自由なライセンスのソフトウェアを含む | `rar`, `unrar`,|
| `non-free-firmware` | 非自由なファームウェアが必要なドライバなど | `firmware-linux`, `firmware-amd-graphics`,  `firmware-iwlwifi` |

例えば、`contrib` や `non-free` を有効にするには、以下のように `sources.list` を編集します。

```ini:/etc/apt/sources.list
# official sources.list with contrib and non-free

deb https://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb https://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
```

設定後、次のコマンドでパッケージリストを更新します。

```bash
sudo apt update
```

これにより、`contrib` や `non-free` に含まれるパッケージもインストール可能になります。

### 1.5 `apt`でよく使うコマンド一覧

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
