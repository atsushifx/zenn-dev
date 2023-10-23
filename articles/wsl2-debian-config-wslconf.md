---
title: "wsl.confを使用してWSL2の動作をカスタマイズする方法"
emoji: "🐧"
type: "tech"
topics: [ "WSL2", "wslconf", "環境設定", "カスタマイズ" ]
published: false
---

## tl;dr

WSL2 の動作は、以下の手順で簡単にカスタマイズできます。

1. `/etc/wsl.conf`を作成し、![gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)の内容をコピー&ペーストする
2. `hostname`および`default`の値を自分の設定にあわせて書き換える
3. `wsl --shutdown`と入力して、WSL を再起動する

Enjoy!

## はじめに

WSL2[^1] は、Windows上で Linux の環境をスムーズに利用できる強力なツールです。
`/etc/wsl.conf` を使用して 、その動作をカスタマイズできます。

この記事では、WSL の基本的な動作の設定を紹介します。

[^1]: WSL2: WSL $_\text{(Windows Subsystem for Linux)}$ の第2バージョン

## 1. `wsl.conf` とは

`wsl.conf`[^2] は、Windows WSL の動作をカスタマイズするための設定ファイルです。
このファイルに設定を書き込むことで、WSL の動作を変更できます。

`wsl.conf`の設定の詳細は、[Microsoft Learn - WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)を参照してください。

[^2]: `wsl.conf`: WSL の動作をカスタマイズするファイル。ホスト名や WSL 起動時にログインするユーザー名などを設定できる

## 2. `wsl.conf` によるWSLの設定

### 2.1. `wsl.conf` の設定一覧

この記事では、以下のように WSL を設定します。

<!-- markdownlint-disable no-inline-html -->

| セクション | 設定項目 | 設定 | 備考 |
| --- | --- | --- | --- |
| `boot` | `systemd` | true | `systemd[^3] のサポートを有効にする<br/>(Linuxのサービスやデーモンの起動・管理をサポート) |
| `network` | `hostname`[^4] |  \<your-hostname> | WSLインスタンスごとの用途に応じて設定する |
| `interop`[^5] |  `appendWindowsPath`[^6]  | false | Windows側のPath設定を追加しない |
| `user` | `default` | \<your-username> | WSL起動時にログインするユーザー名を設定する |

<!-- markdownlint-enable -->

以上のように、WSL2 を設定します。

[^3]: `systemd`:  Linux のサービスやデーモンの管理を行なうシステムとサービスマネージャー。システムの初期化やサービスの管理などを行なう
[^4]: `hostname`: コンピュータネットワーク上でコンピューターを識別するための名前
[^5]: `interop`: ここでは、WSL と Windows との相互運用性に関する設定
[^6]: `appendWindowsPath`: WSL上に Windows 側の Path を設定するフラグ。True の時に、WSL 側に Windows 側の Path を追加する

### 2.2. 作成した`wsl.conf`

上記の設定にあわせて、`/etc/wsl.conf`を作成します。
`/etc/wsl.conf`は、次のようになります。

@[gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)

ホスト名は開発用に使うので`develop`、`ユーザー名`はいつも使っている`atsushifx`にしています。

### 2.3. `/etc/wsl.conf` のWSLへの設定方法

次の手順で、WSL を設定します。

1. `/etc/wsl.conf`の作成
   WSL2上の Debian で、次のコマンドを実行して`/etc/wsl.conf`を作成する。
   `/etc/wsl.conf`に[2.2.の節](#22-作成したwslconf)で作成した`wsl.conf`の内容をコピー＆ペーストする

   ```bash
   sudo vi /etc/wsl.conf
   ```

2. `/etc/wsl.conf`の設定
   自分の環境にあわせて、1．の\<your-hostname>、\<your-username>を書き換えて、`/etc/wsl.conf`を保存します。

3. Debian の再起動
   `/etc/wsl.conf`を作成した Debian を停止します。

   ```powershell
   wsl --shutdown
   ```

   その後、`Windows Terminal`[^7]で Debian を選択して、WSL を起動します。

   ```bash
   atsushifx@develop:~$

   ```

   プロンプトのホスト名を見ればわかるように、`wsl.conf`の設定が反映されています

以上で、`/etc/wsl.conf`の設定は終了です。

[^7]: `Windows Terminal`: Windows 公式のターミナルエミュレーター

## おわりに

この記事では、`wsl.conf`を使い WSL の基本動作を設定しました。
自分の設定例は、[gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)に保存されていますので、参考にしてください。

`wsl.conf`だけでなく、`.profile`,`.bashrc`[^8] などのシェルスクリプトやその他の Linux の設定もすることで、WSL をさらに効果的に活用できます。

また、WSL は自身の環境を別ディストリビューションに簡単にインポートできます。ベースとなる WSL を用意することで、目的ごとに WSL を活用できるでしょう。

それでは、Happy Hacking!

[^8]: `.profile`, `.bashrc`: Linux のシェルの設定ファイル。ユーザーがログインしたときに実行される

## 参考資料

### Microsoft Learn

- [WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)

### Webサイト

- [WSL 2 上の Debian で  systemd を有効化する方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-systemd-enable)
