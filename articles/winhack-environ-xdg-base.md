---
title: "Windows: Windowsに'XDG Base Directory'を導入する"
emoji: "🪟"
type: "tech"
topics: [ Windows,環境構築,環境変数, XDG]
published: false
---

## はじめに

Windows で開発環境を構築するときは、`Git`など Linux系のツールをよく使います。
これらのツールは、大抵、`/home/<ユーザー名>`下に設定ファイルを保存しています。
`/home/<ユーザー名>`下は、少々使い勝手が悪いです。`ドキュメント`などの`Windows`が使うフォルダを含んでいるため、そのままでは`Git`を使ってバージョン管理ができません。

Linux では、`XDG Base Directory`という仕様にしたがって設定ファイルを`$HOME`下から移す動きが広がってきています。そこで、 Windows でも、この仕様に準拠して設定ファイルを配置することで、Git でバージョン管理できるように押します。

## もっと詳しく

### XDG Base Directory について

`XDG Base Directory`は、各種ツールの設定ファイルなどを保存するディレクトリを決めたものです。これらのディレクトリは`XDG_`ではじまる環境変数に絶対パスで保存されています。
`XDG Base Directory`については、[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)を見てください。
また、日本語の概要が[XDG Base Directory - ArchLinux wiki](https://wiki.archlinux.jp/index.php/XDG_Base_Directory#.E4.BB.95.E6.A7.98)に載っています。

### XDGの環境変数

Windows では、次の環境変数を使います。

| 環境変数 | 説明 | デフォルトの設定[^1]| 設定ファイルの例 | 備考 |
| --- | --- | --- | --- | --- |
| XDG_CONFIG_HOME | アプリごとの設定ファイルを保存 | ~/.config | ${XDG_CONDIF_HOME}/git/ignore | |
| XDG_DATA_HOME | アプリの各種データファイルを保存 | ~/.local/share | ${XDG_DATA_FILE}/tig/history | |
| XDG_CACHE_HOME | アプリが一時的に作成するデータファイル(キャッシュ)を保存 | ~/.cache | ${XDG_CACHE_HOME}/vim/_viminfo | |
| XDG_STATE_HOME | アプリの状態ファイルを保存 | ~/.local/state | ${XDG_STATE_HOME}/lesshst | |

各種ツールの設定ファイルは、基本的に"${\<XDG 環境変数\>}/<アプリ名>/<設定ファイル>"の形式で設定ファイルを保存します。

[^1]:Linux の場合に限ります。Windows ではツールごとに設定する必要があります。

## XDGを設定する

### XDG Base Directory を設定する

[XDGの環境変数](#xdgの環境変数)で書いた 4つの環境変数を設定します。あわせて、環境変数"`HOME`"も設定します。
Windows では、環境変数"`USERPROFILE`"で示したディレクトリが自分のホームディレクトリです。Linux/Unix系ツールでは"`HOME`"を使うため、"XDG Base Directory"に対応していないツールでも、これで対応できることがあります。
もちろん、Windows 対応で"`USERPROFILE`"を見るツールもあるので、すべて対応できるわけではありません。

次のように、環境変数を設定します。

| 環境変数 | 設定値 | 備考 |
| --- | --- | --- |
| XDG_CONFIG_HOME | C:\Users\<ユーザー名>\.config | |
| XDG_DATA_HOME | C:\Users\<ユーザー名>\.local\share | |
| XDG_CACHE_HOME | C:\Users\<ユーザー名>\.local\cache | |
| XDG_STATE_HOME | C:\Users\<ユーザー名>\.local\state | |
| HOME | C:\Users\<ユーザー名>\.config | __(`XDG_CONFIG_HOME'と一致させる)__ |

以後、各種ツールの環境変数は、上記の`XDG_...`環境変数にしたがって値を設定します。

### ツールを設定する (XDG 対応済み)

`XDG Base Directory'に対応済みのツールの場合は、とくになにかを設定する必要はありません。
そのかわり、`XDG Base Directory`で指定されたディレクトリに設定ファイルを移動する必要があります。

Windows 用パッケージマネージャ`Scoop`は`XDG Base Directory`に対応しています。
上記のように`XDG_...`環境変数を設定すると、`${XDG_CONFIG_HOME}/scoop/config.json`に`Scoop`の設定を保存します。

### ツールを設定する (HOMEによる対応)

この記事では、環境変数`HOME`を書き換えて`XDG_CONFIG_HOME`と同じディレクトリーを指すようにしています。
このため、設定ファイルを`$HOME`下に置くツールなら自動的に`XDG Base Directory`に対応します。

たとえば、Vim を Windows で使う場合、`$HOME/vimfiles/`下に設定ファイル置きます。
この記事のように`HOME`を設定すると、`$XDG_CONFIG_HOME/vimfiles`/下に設定ファイルを置きます。

### ツールを設定する (環境変数による設定)

上記以外のツールでは、環境変数を設定して設定ファイルの位置を指定します。
コーディング計測ツール`wakatime`は、デフォルトでは`$USERPROFILE`直下に各種設定ファイルを保存します。これは、`XDG..`の環境変数を設定してもかわりません。
環境変数`WAKATIME_HOME`で`$XDG_DATA_HOME`/wakatime`と設定し、該当するディレクトリを作成します。
以後、`$WAKATIME_HOME`下に各種設定ファイル、ログファイルを保存します

## さいごに

このように`$XDG_CONFIG_HOME`下に各ツールの設定ファイルを保存すると、設定ファイルのリビジョン管理が楽になります。
実際、自分はGitHubで各種設定ファイルを管理しています。

各ツールの対応状況や、設定の方法は"[XDG Base Directory - ArchLinux wiki](https://wiki.archlinux.jp/index.php/XDG_Base_Directory#.E4.BB.95.E6.A7.98)"に載っていますので、参考にしてください。

それでは、Happy Hacking!

## 参考資料

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [XDG Base Directory - ArchLinux wiki](https://wiki.archlinux.jp/index.php/XDG_Base_Directory#.E4.BB.95.E6.A7.98)
