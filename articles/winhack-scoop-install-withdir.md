---
title: "Windows: Scoopをディレクトリ指定つきでインストールする方法"
emoji: "⛏️"
type: "tech"
topics: ["Windows", "Scoop", "環境構築", "インストール" ]
published: false
---

## はじめに

この記事では、`Scoop`をディレクトリ指定付きでインストールする方法について解説します。

[Scoop公式サイト](https://scoop.sh)などの解説では、インストール先がデフォルトのディレクトリで固定されています。
しかし、一度インストーラーをダウンロードしてからオプションを指定してインストールすることで、指定したディレクトリにインストールできます。
このときに、グローバルインストール時のインストール先やパッケージをキャッシュするディレクトリも指定できます。

ここでは、上記のディレクトリを指定したインストール方法を詳しく解説します。

## 1. Scoopとは

Scoop は、Windows上で動作するパッケージマネージャーです。パッケージマネージャーとは、ソフトウェアのインストール、アップデート、削除などを管理し、これらのプロセスを自動化するツールのことを指します。

Scoop の特徴は、豊富な開発ツールを提供していることと、個人用のパッケージ管理リポジトリを容易に設立できることです。

プログラマーやエンジニアにとって、開発ツールの管理を容易に行なうことが可能です。」

## 2. Scoopのインストール

### 2.1. インストールするディレクトリ

Scoop インストーラー`installer.ps1`のオプションで、パッケージのインストール先などのディレクトリが指定できます。
この記事では、下記の表の設定で`Scoop`をインストールします。

| 設定項目 | 設定値 | 説明 |
| --- | --- | --- |
| ScoopDir | C:\Users\<ユーザー名>\app\scoop | Scoopのインストール先ディレクトリ。 |
| ScoopGlobalDir | C:\app\scope | グローバルインストール時にパッケージを配置するディレクトリ |
| ScoopCacheDir |  C:\var\cache\scoop | scoop用キャッシュ: ダウンロードしたパッケージは、このディレクトリ下にキャッシュされる |

**注意**: `<ユーザー名>`は、自分のアカウント名に置き換えてください。

### 2.2. インストーラーのダウンロード

Scoop のインストーラーのスクリプトをダウンロードします。
以下の手順で、インストーラースクリプトをダウンロードします。

1. PowerShell を起動する

2. 作業用ディレクトリに移動する

   ``` powershell
   cd ~/temp
   ```

3. 以下のコマンドを実行して、スクリプトをダウンロードする

   ``` powershell
   Invoke-WebRequest -UseBasicParsing get.scoop.sh -Outfile installer.ps1
   ```

上記の手順で、カレントディレクトリに`installer.ps1`という名前でインストーラーを保存します。

### 2.3. ディレクトリ指定付きインストール

次の手順で、`Scoop`を指定したディレクトリにインストールします。

1. PowerShell を起動する

2. ディレクトリ指定付きで、インストーラーを起動する

   ``` PowerShell
   ./installer.ps1 -ScoopDir "C:\Users\<ユーザー名>\app\scope" -ScoopGlobalDir "C:\app\scoop" -ScoopCacheDir "C:\var\cache\scoop"
   ```

   **注意**: <ユーザー名>は、自分のアカウント名に置き換えてください。

### 2.4. インストールの確認

`scoop config`コマンドで、`Scoop`の設定が確認できます。
次の手順、`Scoop`の設定を確認します。

1. PowerShell を起動する

2. `Scoop`の設定を確認する

   ``` powershell
   > scoop config

   root_path    : C:\Users\<ユーザー名>\app\scoop\
   global_path  : C:\app\scoop\
   cache_path   : C:\var\cache\scoop\
   last_update  : 2023/05/31 7:56:21
   scoop_repo   : https://github.com/ScoopInstaller/Scoop
   scoop_branch : master

   ```

上記のように、指定したディレクトリが表示されていれば、正常にインストールされていることが確認できます。

## 3. 指定ディレクトリの変更

ディレクトリ指定を間違えた場合など、ディレクトリを変更したいときは`Scoop`の設定ファイルを書き換えます。

### 3.1. Scoopの設定ファイル

`Scoop`の設定ファイルは、`%USERPROFILE%/.config/scoop/config.json`です。
このファイルを書き換えると、ディレクトリなどを変更できます。

config.json の中身は、つぎのようになっています。

``` json: ${USERPROFILE}/.config/scoop/config.json
{
  "root_path": "C:\\Users\\<ユーザー名>\\app\\scoop\\",
  "global_path": "C:\\app\\scoop\\",
  "cache_path": "C:\\var\\cache\\scoop\\",
  "scoop_repo": "https://github.com/ScoopInstaller/Scoop",
  "scoop_branch": "master",
  "last_update": "2023-05-31T07:56:21.9231246+09:00"
}

```

**注意**: "<ユーザー名>"には、実際には自身のアカウント名が入ります。

### 3.2. 設定ファイルの書き換え

設定ファイル`config.json`は、json形式のテキストファイルです。
以下の手順で、設定ファイルを編集してディレクトリを変更します。

1. テキストエディタで config.json を開く

2. root_path、global_path、cache_path の値を変更する

   ``` json: config.json
   {
     "root_path": "C:\\Users\\<ユーザー名>\\app\\scoop\\",
     "global_path": "C:\\app\\scoop\\",
     "cache_path": "C:\\var\\cache\\scoop\\",
     ...
   }
   ```

   **注意**: 実際の設定ファイルでは、`"`で囲うため、"\\"とエスケープしている。

3. 設定ファイル`config.json`を保存する

4. `scoop config`コマンドを実行して、変更したディレクトリが反映されているか確認します。

   ``` powershell
   scoop config
   ```

   ``` powershell
   root_path    : C:\Users\<ユーザー名>\app\scoop\
   global_path  : C:\app\scoop\
   cache_path   : C:\var\cache\scoop\
   last_update  : 2023/05/31 7:56:21
   scoop_repo   : https://github.com/ScoopInstaller/Scoop
   scoop_branch : master
   ```

   上記のように、変更したディレクトリが表示されれば、設定の変更が正常に行われています。

### 3.3. pathの修正

`root_path`, `global_path`の設定を変更したときには、実行ファイルのインストール先も変わります。
これに合わせて、Path の設定も変更する必要があります。

次の手順で、Path を修正します。

1. Windows の「システムのプロパティ」を開きます。
2. 「詳細設定」タブを選択し、「環境変数」をクリックします。
3. "ユーザー環境変数"もしくは"システム環境変数"の"Path"を探し、"編集"をクリックします。
4. "新規"をクリックし、追加したい Path を入力します。
5. "OK"をクリックして、ダイアログを閉じます。

### 3.4. 変更したディレクトリの確認

再度、`scoop config`を実行して、変更したディレクトリになっているか確認します。

``` powershell
> scoop config

root_path    : C:\Users\<ユーザー名>\app\scoop\
global_path  : C:\app\scoop\
cache_path   : C:\var\cache\scoop\
last_update  : 2023/05/31 7:56:21
scoop_repo   : https://github.com/ScoopInstaller/Scoop
scoop_branch : master

```

上記のようになっていれば、修正できています。

## さいごに

以上で、Scoop のディレクトリ指定つきインストール方法とディレクトリの変更方法について解説しました。
Scoop は便利なパッケージマネージャーであり、開発ツールの管理を簡単に行えます。

なにか疑問があれば、この記事のコメント欄に気軽に書き込んでください。

それでは。Happy Hacking!

## 技術用語と注釈

- Scoop: Windows 用のパッケージマネージャーです。Scoop上のコマンドを使用して、ソフトウェアのインストール、アップデート、アンインストールを簡単に行えます
- パッケージマネージャー: ソフトウェアのインストール、アップデート、削除などを管理し、これらのプロセスを自動化するツールのこと。

## 参考資料

### Webサイト

- Scoop: <https://scoop.sh/>
- Scoop (GitHub): <https://github.com/ScoopInstaller/Scoop>
- Scoop Installer: <https://github.com/ScoopInstaller/Install>
