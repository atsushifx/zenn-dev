---
title: "wsl.conf を使用して WSL2 の動作をカスタマイズする方法"
emoji: "🐧"
type: "tech"
topics: [ "WSL2", "wslconf", "環境設定", "カスタマイズ" ]
published: false
---

## tl;dr

WSL2 の動作は以下の手順で簡単にカスタマイズできます。

<!-- markdownlint-disable line-length -->

1. `/etc/wsl.conf`を作成し[こちらのgist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)の内容をコピー & ペーストする
2. `hostname`および`default`の値を自分の設定にあわせて書き換える
3. `wsl --shutdown`と入力して WSL2 を停止し、`Windows Terminal`から再度 WSL2 を起動する

<!-- markdownlint-enable -->

Enjoy!

## はじめに

WSL2[^1] は Windows 上で Linux の環境をスムーズに利用できる強力なツールです。
`/etc/wsl.conf` を使用して、WSL2 の動作をカスタマイズできます。

この記事では、WSL2 の基本的な設定を紹介します。

[^1]: WSL2: WSL $_\text{(Windows Subsystem for Linux)}$ の第2バージョン

## 1. `wsl.conf` とは

`wsl.conf`[^2] は、WSL の動作をカスタマイズするための設定ファイルです。
このファイルに設定を書き込むことで WSL2 の動作を変更できます。

`wsl.conf`の設定の詳細は[Microsoft Learn - WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)を参照してください。

[^2]: `wsl.conf`: WSL の動作をカスタマイズするファイル。WSL 起動時に実行するコマンドなどが指定できる

## 2. `wsl.conf` によるWSLの設定

### 2.1. `wsl.conf` の設定一覧

この記事では、以下のように WSL を設定します。

<!-- markdownlint-disable no-inline-html -->

| セクション | 設定項目 | 設定 | 備考 |
| --- | --- | --- | --- |
| `boot` | `systemd` | true | `systemd`[^3] のサポートを有効にする  |
| `network` | `hostname`[^4] |  \<your-hostname> | WSLインスタンスのホスト名、用途に応じて設定する |
| `interop`[^5] |  `appendWindowsPath`[^6]  | false | Windows側のPath設定を追加しない |
| `user` | `default` | \<your-username> | WSL起動時にログインするユーザー名を設定する |

<!-- markdownlint-enable -->

以上のように、WSL2 を設定します。

[^3]: `systemd`:  Linux のサービスやデーモンを管理するシステムとサービスマネージャー
[^4]: `hostname`: コンピュータネットワーク上でコンピューターを識別するための名前
[^5]: `interop`: ここでは、WSL と Windows との相互運用性に関する設定
[^6]: `appendWindowsPath`: WSL上に Windows 側の Path を設定するフラグ。True の時に、WSL 側に Windows 側の Path を追加する

### 2.2. 作成した`wsl.conf`

上記の設定にあわせて、`/etc/wsl.conf`を作成します。
`/etc/wsl.conf` は次の通りです。

@[gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)

### 2.3. `/etc/wsl.conf` のWSL への設定方法

次の手順で、WSL を設定します。

1. `/etc/wsl.conf`の作成
   WSL2上の Debian で、次のコマンドを実行して`/etc/wsl.conf`を作成する。
   `/etc/wsl.conf` に 2.2.の節で作成した `wsl.conf` の内容をコピー＆ペーストする

   以下のコマンドを実行してください

   ```bash
   sudo vi /etc/wsl.conf
   ```

2. `/etc/wsl.conf`の設定
   自分の環境にあわせて、1. の\<your-hostname>、\<your-username>を書き換えて、`/etc/wsl.conf`を保存します。

3. Debian の再起動
   `/etc/wsl.conf`を作成した Debian を停止します。

   以下のコマンドを実行してください

   ```powershell
   wsl --shutdown
   ```

   その後、`Windows Terminal`[^7] で Debian を選択して、WSL2 を起動します。
   プロンプトは、`atsushifx@develop:~$`のように表示され、`wsl.conf`の設定が反映されています

以上で、`/etc/wsl.conf`への設定は終了です。

[^7]: `Windows Terminal`: Windows 公式のターミナルエミュレーター

## おわりに

この記事では、`wsl.conf`を使い WSL の基本動作を設定しました。
自分の設定例は[こちらのgist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)に保存されていますので、参考にしてください。

`wsl.conf` だけでなく、`.profile`,`.bashrc`[^8] などのシェルスクリプトやその他の Linux の設定もすることで、WSL2 をより効果的に活用できます。

それでは、Happy Hacking!

[^8]: `.profile`, `.bashrc`: Linux のシェルの設定ファイル。ユーザーがログインしたときに読み込まれる

## 参考資料

### Microsoft Learn

- [WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)

### Webサイト

- [WSL 2 上の Debian で  systemd を有効化する方法](https://zenn.dev/atsushifx/articles/wsl2-debian-config-systemd-enable)
