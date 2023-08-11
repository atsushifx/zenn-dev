---
title: "開発環境: プログラミング学習のためのGit設定"
emoji: "🔧"
type: "tech"
topics: [ "環境構築", "開発環境", "VSCode", "GitHub" ]
published: false
---

## はじめに

Git は、現代のプログラミングで欠かせないツールとなりました。Git を使ってファイルをリポジトリに保存、あるいはリポジトリから復元することで、プログラミングの負担を軽減させられます。
とはいえ、初期設定のままでは不必要なファイルをリポジトリに保存したり、画像などのバイナリファイルが壊れたりするリスクがあります。

この記事では、Git を使い始める前にやっておくべき設定を紹介します。

## 1. Gitの設定

Git は"gitconfig"ファイルに各種設定を記述します。
これらの設定は、Git の`git config`コマンドで設定できます。
また、設定ファイルを書き換えることでも設定できます。

### 1.1. Gitの設定ファイル

Git では、各種設定を system、global、local の 3 段階で保存します。
各段階の設定の意味は次の通りです。

- system:
  "/etc/gitconfig"ファイルに保存され、システム全般の設定を記述します。通常、書き換える必要はありません。
   `Git for Windows`では、認証情報用のツール"`Git Credential Manager`"の設定などが記述されています。

- global:
  "~/.gitconfig"ファイル、または"~/.config/git/config"ファイルに保存され、ユーザーごとに各リポジトリ共通の設定を保存します。
  主に、ユーザー名やエディタなどを設定します。

- local:
  リポジトリの".git/config"ファイルに保存され、リポジトリごとの設定を記述します。
  リモートブランチなどを保存しています。

この記事では`XDG Base Directory`にしたがいます。
よって、"~/.config/git/config"ファイルに設定を記述します。同様に、属性は"~/.config/attributes"に、無視の設定は"~/.config/git/ignore"に記述します。

### 1.2. 基本設定

"git/config"では、\[core\]、\[user\]のようにセクションごとに設定を記述します。
\[core\]には、改行コードやシンボリックの扱いなどの Git の基本的な設定を記述します。
\[user\]には、Git で使うユーザー名やメールアドレスを記述します。

この章では、"git/config"の基本設定について解説します。

#### 改行コードと属性

テキ ストファイルの改行コードは、 UNIX/Linux 系の`LF`で統一します。
そのため、`autocrlf=input`としてコミット時に改行コードを`LF`に変更させます。

`/git/config'`ファイルは、以下のようになります:

``` ini: git/config
[core]
    autocrlf = input
```

上記の改行コード変換は、Git の属性で制御できます。`binary`属性を設定すると、コードを変換しません。
また、".gitattributes"を設定することで、あらかじめファイルに属性を設定できます。

ここでは、"git/config"に設定を追加して"git/attributes"ファイルで属性を設定させます。

``` ini: git/config
[core]
    attributesfile = ~/.config/git/attributes
```

このようにすることで、"git/attributes"ファイルで属性を設定できます。

#### git/attributes

"git/attributes"には、ファイルに設定する属性を記述します。
ファイルの指定に glob が使え、通常は拡張子ごとに属性を設定します。

この記事での"git/attributes"は以下のようになります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitattributes)

#### git/ignoreの設定

Git ではリポジトリで管理したくないファイルを無視できます。
"git/ignore"でファイルやディレクトリを指定すると、そのファイルはリポジトリに追加できなくなります。

"`git/ignore"の設定については、[gitignore documentation](https://git-scm.com/docs/gitignore)を参照してください。

この記事の"git/ignore"の場合は、OS などが作成するシステムファイルや一時ファイル、バックアップファイルなどを無視します。
同様に、`.ssh`下にある秘密鍵のような認証情報ファイルも無視します。

この記事での"git/ignore"ファイルは、以下のようになります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitignore)

### 1.3. ユーザーの設定

#### ユーザー設定

Git では、"\[user\]"セクションでユーザー名とメールアドレスを設定します。
設定したユーザー名とメールアドレスは、コミットログに`Author`として表示されます。

"git/config"は、以下のようになります:

```ini: git/config
[user]
    name = Furukawa, Atsushi
    email = atsushifx@example.com

```

### 1.4. ブランチの設定

#### デフォルトブランチ

Git はリポジトリを初期化するときに、指定されたブランチでリポジトリを作成します。
これをデフォルトブランチといい、"git/config"ファイルで指定できます。

次のようにして、デフォルトブランチを設定します。

``` ini: git/config
[init]
    defaultBranch = main

```

#### pushするブランチの設定

"git/config"では、`git push`時にブランチをどう扱うかを指定できます。

`push.default = current`とすると、同名のリモートブランチに push します。ブランチがない場合は、新たに同名のブランチを作成して、そのブランチに push します。

`push.autoSetupRemote = true`で push 時に upstream のトラックをします。

これらをまとめた、"git/config"は以下のようになります:

```ini: git/config
[push]
    default = current
    autoSetupRemote = true

```

#### pull/merge関連

`git pull`、`git merge`を実行したときに、`fast forward`をどうするかを指定します。
`pull`の場合は、`ff = only`として HEAD の位置を移動します。
`merge`の場合は、`ff = false`として`fast forward`を行いません。

上記の設定の、"git/config"は以下のようになります:

```ini: git/config
[merge]
    ff = false

[pull]
    ff = only

```

### 1.5. エイリアスの設定

Git では、コマンドラインを別名で保存するエイリアス機能があります。
エイリアスでは、よく使うコマンドの短縮版を登録したり、オプション付きのコマンドを設定できます。

#### エイリアスの設定  (短縮コマンド)

よく使うコマンドやオプションをエイリアスとして設定します。
エイリアスは、次のようになります:

```ini: git/config
[alias]
    ss = status -s
    br = branch
    co = checkout
    sw = switch
    pr = pull -r
    ps = push
    co = checkout
    st = status
    fixit = commit --amend --no-edit

```

#### エイリアスの設定 (コミットログ)

`git log`コマンドは、さまざまなオプションがありコミット履歴をビジュアルに表示できます。
オプションを覚えるのは大変なので、これもエイリアスにします。

エイリアスは、次のようになります:

```ini: git/config
[alias]
    l = log --graph --all --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset'
    ll = log --stat --abbrev-commit
    lg = log --color --graph --pretty=format:'%C(bold white)%h%Creset -%C(bold green)%d%Creset %s %C(bold green)(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    llg = log --color --graph --pretty=format:'%C(bold white)%H %d%Creset%n%s%n%+b%C(bold blue)%an <%ae>%Creset %C(bold green)%cr (%ci)' --abbrev-commit

```

#### エイリアスの一覧

設定したエイリアスの一覧を取得するコマンドもあります。これもエイリアスとして設定します。
エイリアスは、次のようになります:

```ini: git/config
[alias]
    aliases = !git config --get-regexp '^alias\\.' | sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\\t => \\2/' | sort

```

### 1.6. まとめ

ここまでの設定を 1つにまとめると、オススメの"git/config"になります。
作成した"git/config"は、以下のようになります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitconfig)

## 2. Gitを使いこなすためのツール

Git をさらに使いこなすには、下記で紹介したツールが使えます。

### 2.1. 機能拡張ツール

#### posh-git

`posh-git`は、Git にタブ補完機能などを追加する PowerShell の機能拡張です。
インストールは、`Scoop`で簡単にできます。

次の手順で、`posh-git`をインストールします。

1. scoop に extras bucket を追加する:

   ```powershell
    scoop bucket add extras
    ```

2. scoop で`posh-git`を人ストールする:

   ```powershell
   scoop install posh-git
   ```

3. $profile に`import-module posh-git`を追加:

   ``` powershell:$profile
   Import-module posh-git
   ```

以上で、インストールは終了です。
PowerShell を立ち上げ直すと、タブ補完機能が使えます。

### 2.2. 設定用ツール

#### gibo

`gibo`は GitHub のテンプレートから、入力したキーワードに対応するテンプレートを出力するツールです。
開発環境にあわせてキーワードを選ぶことで、一気に gitignore を設定できます。

`gibo`は、`scoop`でインストールできます。
次の手順で、`gibo`をインストールします。

1. scoop で `gibo`をインストールする:}

   ```powershell
   scoop install gibo
   ```

以上で、`gibo`のインストールは終了です。

## おわりに

この記事では、"git/config"、"git/attributes"、"git/ignore"の設定について解説しました。
上記ファイルを"~/.config/git"下に保存し、ユーザー名などを自分に合わせて変更すれば、Git の設定は終了です。

これらを利用して、効率よくプログラミングを始めるといいでしょう。

それでは、Happy Hacking!

## 参考資料

### 本/Webブック

- [Pro Git 2nd Edition](https://git-scm.com/book/en/v2)

### Webサイト

- [gitignore documentation](https://git-scm.com/docs/gitignore)
- [posh-git](https://github.com/dahlbyk/posh-git)
