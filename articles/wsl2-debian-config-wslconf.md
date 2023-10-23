---
title: "wsl.confを使用してWSL2の動作をカスタマイズする方法"
emoji: "🐧"
type: "tech"
topics: [ "WSL2", "wslconf", "環境設定", "カスタマイズ" ]
published: false
---

## tl;dr

次の手順で、WSL の動作を簡単にカスタマイズできます。

1. `/etc/wsl.conf`を作成し、![gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)の内容をコピー&ペーストする
2. ホスト名およびデフォルトユーザー名を自分の設定にあわせて書き換える
3. `Windows Terminal`に戻り、WSL を再起動する

以上で、この記事の基本動作を設定した WSL が作成できます。
Enjoy!

## はじめに

WSL $_\text{(Windows Subsystem for Linux)}$ の動作は`/etc/wsl.conf`でカスタマイズできます。
この記事では、WSL の基本動作用に使っている設定を紹介します。

## 1. `wsl.conf` とは

`wsl.conf`は、Windows WSL の動作をカスタマイズするための設定ファイルです。
このファイルに所定の型式で、動作オプションを設定することで WSL の動作をカスタマイズできます。

`wsl.conf`の設定の詳細は、[Microsoft Learn - WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)を参照してください。

## 2. `wsl.conf` によるWSLの設定

### 2.1. `wsl.conf` の設定一覧

この記事では、以下のように WSL を設定します。

<!-- markdownlint-disable no-inline-html -->

| セクション | 設定項目 | 設定 | 備考 |
| --- | --- | --- | --- |
| `boot` ||| **ブート設定** |
|  | `systemd` | true | `systemd`のサポートを有効にする<br/>(Linuxのサービスやデーモンの起動・管理をサポート) |
| `network` ||| **ネットワーク設定** |
| | `hostname`|  \<myhostname> | WSLインスタンスごとに用途に応じて設定する |
| `interop` ||| **相互運用の設定** |
| |  `appendWindowsPath`  | false | Windows側のPath設定を追加しない |
| `user` ||| **ユーザー設定** |
| | `default` | \<myusername> | WSL起動時にログインするユーザー名を設定する |

<!-- markdownlint-enable -->

以上のように、WSL2 を設定します。

### 2.2. 作成した`wsl.conf`

上記の設定にあわせて、`/etc/wsl.conf`を作成します。
`/etc/wsl.conf`は、次のようになります。

@[gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)

ホスト名は開発用に使うので`develop`、`ユーザー名`はいつも使っている`atsushifx`にしています。

### 2.3. WSLに`/etc/wsl.conf` を設定する

次の手順で、WSL を設定します。

1. `/etc/wsl.conf`の作成
   WSL2上の Debian で、次のコマンドを実行して`/etc/wsl.conf`を作成します

   ```bash
   sudo vi /etc/wsl.conf
   ```

2. `/etc/wsl.conf`の設定
   作成した`/etc/wsl.conf`に[2.2.の節](#22-作成したwslconf)で作成した`wsl.conf`の内容をコピー＆ペースとして保存します

3. Debian の再起動
   `/etc/wsl.conf`を作成した Debian を再起動します
   `wsl.conf`の設定が反映されています

以上で、`/etc/wsl.conf`の設定は終了です。

## おわりに

この記事では、`wsl.conf`を使い WSL の基本動作を設定しました。
自分の設定例は、[gist](https://gist.github.com/atsushifx/c6d69609133c12788986e882b9782017?file=wsl.conf)に保存されていますので、参考にしてください。

`wsl.conf`だけでなく、`.profile`や`.bashrc`などのシェルスクリプトやその他の Linux の設定もすることで、WSL をさらに効果的に活用できます。

また、WSL は自信の環境を別ディストリビューションに簡単にインポートできます。ベースとなる WSL を用意することで、目的ごとに WSL を活用できるでしょう。

それでは、Happy Hacking!

## 参考資料

### Microsoft Learn

- [WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)

### Webサイト

- [WSL 2 上の Debian で  systemd を有効化する方法](wsl2-debian-config-systemd-enable)
