---
title: "WSL開発環境: 作業用ディレクトリの作成"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "XDGBase", "workspaces", "ディレクトリ" ]
published: false
---

## はじめに

WSL に Debian をインストールした直後では、ホームディレクトリになんのディレクトリも作成されていません。
作業に支障が出るため、まず作業用のディレクトリを作成します。

## 1. 作成するディレクトリ

### 1.1 基本ディレクトリ

ユーザー用の基本ディレクトリとして、`bin`ディレクトリと `temp`ディレクトリを作成します。
これらのディレクトリの用途は、次のとおりです。

- `~/bin`: ユーザー個人が使うスクリプトやコマンドを保存
- `~/temp`: 一時的な作業や一時ファイルを保存

ディレクトリを作成するために、次のコマンドを実行します:

```bash
mkdir ~/bin ~/temp
```

### `XDG Base Directory`ディレクトリ

WSL 環境では、`XDG Base Directory`にしたがって設定ファイルやデータファイルを保存します。
そのため、あらかじめ`XDG Base Directory`仕様のディレクトリを作成しておく必要があります。

`XDG Base Directory`仕様のディレクトリは次の通りです。

| 環境変数 | ディレクトリ | 説明 | 備考 |
| --- | --- | --- | --- |
| XDG_CONFIG_HOME | `~/.config` | ユーザー別の設定を保存 | `dotfiles`組み込み時には、シンボリックリンクとなる |
| XDG_CACHE_HOME | `~/.local/cache` | ユーザー-ごとの重要でない(キャッシュ)データを保存 |  |
| XDG_DATA_HOME | `~/.local/share` | ユーザー別のデータファイルを保存 |  gitの認証情報などを保存 |
| XDG_STATE_HOME | `~/.local/states` | ユーザー別の状態ファイルを保存 | シェルのヒストリーなどを保存 |

**注意**:
実際に`XDG Base Directory`にしたがってファイルを保存するには、上記の各環境変数を設定する必要があります。
`dotfiles`組み込み済みの場合は、`/opt/etc/envrc`で設定されます。

次のコマンドで、`XDG Base Directory`  を作成します:

```bash
mkdir -p \
  ~/.config \
  ~/.local/cache \
  ~/.local/share/git \
  ~/.local/states
```

### `workspaces`ディレクトリ

`workspaces`は、プログラミングなどの実際の作業のためのディレクトリです。
個々のプロジェクトにあわせてサブディレクトリを作成し、そこで作業します。

`workspaces/temp`ディレクトリは、一時的なプログラミングなどの作業用ディレクトリです。

次のコマンドで、`workspaces`ディレクトリを作成します:

```bash
mkdir -p ~/workspaces/temp
```

## 2. 作成したディレクトリ

ディレクトリを作成すると、以下のようなツリーになります。

```bash
├─ .config
├─ .local
│    ├─ cache
│    ├─ share
│    │    ├── git
│    └─ states
├─ bin
├─ temp
└─ workspaces
        └─ temp
```

## おわりに

以上で、作業用ディレクトリの作成は終了です。
今後は、各ディレクトリを活用して効率的な開発をしてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

-`XDG Base Directory' (`Arch Wiki`):`
  <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
