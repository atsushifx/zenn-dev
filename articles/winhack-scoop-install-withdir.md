---
title: "Windows: Scoopをディレクトリを指定してインストールする方法"
emoji: "⛏️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Windows", "Scoop", "環境構築", "インストール" ]
published: false
---

## はじめに

この記事では、Scoop インストーラーにオプションを指定して、特定のディレクトリにインストールする方法について解説します。

[Scoop公式サイト](https:scoop.sh)などの解説では、インストール先がデフォルトのディレクトリで固定されています。
しかし、一度インストーラーをダウンロードしてからオプションを指定してインストールすることで、指定したディレクトリにインストールできます。

ここでは、オプション付きのインストール方法を詳しく解説します。

## Scoopとは

Scoop は Windows 用のパッケージマネージャーです。Windows 公式の`winget`を比べると、`Scoop`開発ツールが充実している、個人用のパッケージ管理リポジトリが簡単に作成できる、といった特徴があります。

## Scoopのインストール

### インストーラーのダウンロード

Scoop のインストーラーのスクリプトをダウンロードします。
以下の手順で、インストーラースクリプトをダウンロードします。

``` powershell
irm get.scoop.sh -Outfile installer.ps1
```

### インストーラーのオプション

`./installer.ps1 -?`でインストーラーのオプションが確認できます。

この記事で使用するオプションは、下記の表のようになります。

| オプション | 設定値 | 説明 |
| --- | --- | --- |
| ScoopDir | C:\Users\<ユーザー名>\app\scoop | Scoopのインストール先ディレクトリ。 ユーザー名には自信のアカウントが入る |
| ScoopGlobalDir | C:\app\scope | グローバルインストール時にパッケージを配置するディレクトリ |
| ScoopCacheDir |  C:\var\cache\scoop | scoop用キャッシュ: ダウンロードしたパッケージは、このディレクトリ下にキャッシュされる |

### ディレクトリ指定付きインストール

次の手順で、`Scoop`をインストールします。

``` PowerShell
./installer.ps1 -ScoopDir C:\Users\<ユーザー名>\app\scope -ScoopGlobalDir c:\app\scoop -ScoopCacheDir c:\var\cache\scoop
```

<!-- markdownlint-disable-next-line -->
**注意**

- <ユーザー名>は、自分のアカウントに書き換える

### インストールの確認

`scoop config`コマンドで、`Scoop`の設定が確認できます。
次のコマンドで、`Scoop`の設定を確認します。

``` powershell
> scoop config

root_path    : C:\Users\<ユーザー名>\app\scoop
global_path  : C:\app\scoop\
cache_path   : C:\var\cache\scoop\
last_update  : 2023/05/31 7:56:21
scoop_repo   : https://github.com/ScoopInstaller/Scoop
scoop_branch : master

```

上記のように、指定したディレクトリが表示されれば、正常にインストールできています。

## 指定ディレクトリの変更

ディレクトリ指定を間違えた場合など、ディレクトリを変更したいときは`Scoop`の設定ファイルを書き換えます。

### Scoopの設定ファイル

`Scoop`の設定ファイルは、`${USERPROFILE}/.config/scoop/config.json`となります。
`scoop config`コマンドは、`config.json`を読んで設定内容を出力しています。

### 設定ファイルの書き換え

設定ファイル`config.json`は、json形式のテキストファイルです。
`config.json`の該当部分を書き換えることで、キャッシュディレクトリなどを変更できます。

`config.json`の項目はつぎのようになります。

| 設定項目 | 設定値 | 説明 |
| --- | --- | --- |
| root_path | C:\\Users\\<ユーザー名>\\app\\scoop | Scoopのインストール先ディレクトリ |
| global_path | C:\\app\\scoop\\ | グローバルインストール時のインストール先ディレクトリ |
| cache_path | C:\\var\\cache\\scoop\\ | Scoop用キャッシュディレクトリ |

### pathの修正

`root_path`, `global_path`の設定を変更したときには、実行ファイルのインストール先も変わります。
これに合わせて、Path の設定も変更する必要があります。

つぎのように`Path`を修正します。

| 設定項目 | 設定値 | Path |
| --- | --- | --- |
| root_path | C:\\Users\\<ユーザー名>\\app\scope | C:\Users\<ユーザー名>\app\scope\shims |
| global_path | C:\\app\\scope\\ | C:\app\scope\shims |

以上で、インストールしたパッケージがコマンドラインから使えるようになります。

### 変更したディレクトリの確認

さいど、`scoop config`を実行して、変更したディレクトリになっているか確認します。

``` powershell
> scoop config

root_path    : C:\Users\<ユーザー名>\app\scoop
global_path  : C:\app\scoop\
cache_path   : C:\var\cache\scoop\
last_update  : 2023/05/31 7:56:21
scoop_repo   : https://github.com/ScoopInstaller/Scoop
scoop_branch : master

```

上記のようになっていれば、修正できています。

## さいごに

以上で、`Scoop`のインストールは終了です。
最後の章のようにインストールあとでもインストール先のディレクトリは変更可能なので、ぜひ、Scoop をインストールしてみてください。

それでは。Happy Hacking!

## 参考資料

### Webサイト

- Scoop: <https://scoop.sh/>
- Scoop (GitHub): <https://github.com/ScoopInstaller/Scoop>
- Scoop Installer: <https://github.com/ScoopInstaller/Install>
