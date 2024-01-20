---
title: "WSL開発環境: 作業用ディレクトリの作成"
emoji: "🐧"
type: "tech"
topics: [ "WSL", "XDGBase", "workspaces", "ディレクトリ" ]
published: false
---

## はじめに

Debian を WSL上で使用する際には、作業用ディレクトリの準備が必要です。
これにより、作業やファイル管理が容易になります。

## 1. 作成するディレクトリ

### 1.1 基本ディレクトリ

ユーザーの基本ディレクトリとして、`bin`と `temp`を作成します。
`~/bin`ディレクトリにはユーザー個別の実行ファイルを置き、`~/temp`ディレクトリには一時的な作業や一時ファイルの保存に使用します。

次のコマンドで、ディレクトリを作成します:

```bash
mkdir ~/bin ~/temp
```

### `XDG Base Directory`ディレクトリ

WSL 環境での設定ファイルの管理を効率化するために、`XDG Base Directory`[^1]仕様にしたがってディレクトリを作成します。
これにより、設定やデータの整理が効率化され、システムの整合性が向上します。

`XDG Base Directory`仕様のディレクトリは次の通りです。

| 環境変数 | ディレクトリ | 説明 | 備考 |
| --- | --- | --- | --- |
| XDG_CONFIG_HOME | `~/.config` | ユーザー別の設定を保存 | `dotfiles`組み込み時には、シンボリックリンクとなる |
| XDG_CACHE_HOME | `~/.local/cache` | ユーザーごとの重要でない (キャッシュ)データを保存 |  |
| XDG_DATA_HOME | `~/.local/share` | ユーザー別のデータファイルを保存 |  |
| XDG_STATE_HOME | `~/.local/states` | ユーザー別の状態ファイルを保存 |  |

**注意**:

- 実際に`XDG Base Directory`にしたがってファイルを保存するには、上記の各環境変数を設定する必要があります。
- `dotfiles`組み込み済みの場合は、`/opt/etc/envrc`で設定されます。

次のコマンドで、`XDG Base Directory`  を作成します:

```bash
mkdir -p \
  ~/.config \
  ~/.local/cache \
  ~/.local/share/git \
  ~/.local/states
```

[^1]: `XDG Base Directory`: Linux におけるユーザーの設定ファイル、データファイル、キャッシュファイルなどを管理するための規格

### `workspaces`ディレクトリ

`workspaces`は、各プロジェクトごとにサブディレクトリを作成し、そこで作業するためのディレクトリです。
これにより、プロジェクトごとにファイルやデータを整理しやすくなります。

`workspaces/temp`ディレクトリは、試験的なコードの作成に使用します。

次のコマンドで、`workspaces`ディレクトリを作成します:

```bash
mkdir -p ~/workspaces/temp
```

## 2. 作成したディレクトリ

上記のセクションで作成されるディレクトリツリーは以下の通りです。
これにより、ファイルやディレクトリの整理が容易になります。

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

これで作業用ディレクトリの準備は完了です。
これらのディレクトリを利用して作業を進めましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- `XDG Base Directory` ('Arch Wiki'):
  <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
