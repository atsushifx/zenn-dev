---
title: "開発環境構築: プログラミングのための Git グローバル設定ガイド"
emoji: "🔧"
type: "tech"
topics: [ "環境構築", "開発環境", "Git", "gitconfig", "SCM" ]
published: false
---

## はじめに

開発環境でのプログラミングにおいて、Git は不可欠なツールです。
ソースコードの変更履歴を管理し、チームでの協力作業をスムーズに行なうために重要な役割を果たします。
この記事は、Git のグローバル設定に焦点をあて、エンジニアが効率的で安全な開発を行なうための手助けをおこないます。

また、Git を使いこなすための便利なサポートツールを紹介します。

## 技術用語と注釈

この記事で使用する技術用語とその注釈を掲載します。

- `Git`: コードの変更を管理する分散型バージョン管理システム
- `gitconfig`: Git の各種コマンドや動作についての設定が記述されている設定ファイル
- `gitattributes`: 各ファイルに Git の属性を付加するための設定ファイル
- `gitignore`: git のリポジトリに追加せず無視するファイルを記述した設定ファイル
- `XDG Base Directory`: 各種ツールの設定ファイルを保存するディレクトリを決めるための仕様
- `Scoop`: Windows のコマンドラインでツールの管理、インストールを行なうパッケージマネージャー
- `リポジトリ`: Git のようなバージョン管理しシステムにおいてコードなどのファイルを保存し、変更履歴を管理する場所

## 1. Gitの設定について

Git の設定は、`gitconfig`ファイルに記述されます。これらの設定は`git config`コマンドを使用するか、設定ファイルを直接編集して行います。

### 1.1. 設定ファイルの階層構造

Git の設定は、以下の 3つの段階で管理されます:

- system:
  "/etc/gitconfig"ファイルに保存され、システム全般の設定を記述します。通常、変更する必要はありません。

- global:
  "~/.gitconfig"ファイル、または"~/.config/git/config"ファイルに保存され、ユーザーごとのに各リポジトリ共通の設定を記述します。

- local:
  リポジトリの".git/config"ファイルに保存され、リポジトリごとの設定を記述します。

この記事では、上記のうち、`global`の設定について紹介します。

なお、設定ファイルは`XDG Base Directory`にしたがい、`~/.config/gitconfig`ファイルに記述します。

### 1.2. グローバル設定の詳細

Git のグローバル設定は、ユーザーごとに設定され各リポジトリ共通の設定を記述します。
具体的には、ユーザー名などのユーザーごとの設定、改行コードなどの OS に付随する設定、gitignore などの Git を使ううえで基本となる設定などです。

これらを設定することで、Git を複数人で使ったりするうえで問題が起こらないようにします。

次の章からは、グローバル設定の具体例について紹介します。

## 2. 基本設定

"git/config"では、\[core\]、\[user\]のようにセクションごとに設定を記述します。

\[core\]には、改行コードやシンボリックの扱いなどの Git の基本的な設定を記述します。\[user\]には、Git で使うユーザー名やメールアドレスを記述します。

### 2.1. 改行コードと属性

テキストファイルの改行コードは、 UNIX/Linux 系の`LF`で統一します。
そのため、コミット時に改行コードを`LF`に変更するように`autocrlf=input`と設定します。

"gitconfig"ファイルは、以下のようになります:

```toml:  gitconfig
[core]
    autocrlf = input
```

 上記の改行コード変換は、Git の属性で制御できます。
 Git で管理するファイルはそれぞれ属性を持ち、"text"属性なら改行コードを変換します。逆に"binary"属性ならば、コードの変換は行わず、ファイルはもとのままです。

たとえば、`.js`, `.ts`のようなソースファイルは"text"属性です。これらは、コミット時に改行コードを変更します。
逆に、`.png`,`.jpg`のような画像ファイルは"binary"属性です。これらは、コミット時にファイルを変更しません。

次に、gitattributes の設定をします。
gitattributes は、ファイルごとにどのような属性をつけるかを設定するファイルです。
[gitattributes documentation](https://www.git-scm.com/docs/gitattributes)によると、グローバル設定では"${XDG_CONFIG_HOME}/git/attributes"ファイルに設定を記述します。

この記事では、確実を期するため、明示的に"gitattributes"ファイルを指定します。

```toml: git/config
[core]
    attributesfile = ~/.config/git/attributes
```

上記のように設定することで、"~/.config/git/attributes"ファイルで属性を設定できます。

### 2.2. gitattributes

"git/attributes"には、ファイルに設定する属性を記述します。
ファイルの指定に glob が使え、通常は拡張子ごとに属性を設定します。

例をあげましょう。
下記は、"git/attributes"の冒頭部です:

```toml: git/attributes
###############################################################################
# Set default behavior to automatically normalize line endings.
###############################################################################
*  text=auto

## Audio

*.aif       binary
*.aiff      binary
*.it          binary

```

まず、`*  text=auto`としています。この、`text=auto`というイディオムは指定したファイルが"text"か"binary"かは、Git 自身が判断するという意味です。
大抵のファイルは、これで問題なく動きます。

そのあとの、"`*.aif`"などがファイルを指定するパターンです。この場合、拡張子が"`.aif`"のファイルは"binary"属性としています。

このように、音声ファイル、画像ファイルなどを"binary"属性にすることで、ファイルを壊さないでリポジトリに登録できます。

これらの設定をまとめた、この記事での設定ファイルは下記の通りです:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitattributes)

### 2.3.  gitignore

Git ではリポジトリで管理したくないファイルを無視できます。
このように無視したいファイルを設定したファイルが、"gitignore"です。

グローバル設定では、"gitignore"は"$XDG_CONFIG_HOME/git/ignore"ファイルに記述します。環境変数"XDG_CONFIG_HOME"を設定していなければ、"$HOME/.config/git/ignore"に記述します。

"gitignore"の設定については、"[gitignore documentation](https://git-scm.com/docs/gitignore)"を参照してください。

#### OS別ファイルの無視

Windows での"thumbs.db"のように、OS が自動的に作成するファイルは、リポジトリに登録すべきではありません。
そのため、"gitignore"に下記のように記述します:

```:gitignore
##
# OS created files
#
.DS_Store
thumbs.db

```

#### 一時ファイル／バックアップの無視

エディタやそのほかのツールが作成する一時ファイル、バックアップファイルも、リポジトリに登録すべきではありません。そのため、"gitignore"に下記のように記述します:

```:gitignore
##
# backup
$~*
~*
*~
*tmp
*swp

```

#### 機密ファイルの無視

`ssh`で使う秘密鍵、`gnupg` が作成する機密ファイルなどもリポジトリに登録すべきではありません。
上記のファイルを無視する設定は下記のようになります:

``` gitignore
##
# credential files
# private key, etc
#
**/.ssh/
**/.gnupg/*
**/.dbus-keyrings/
*credential*

```

#### その他の無視ファイル

その他、ヒストリーやログファイル、patch 用のファイルなどを無視します。
上記のファイルを無視する設定は下記のようになります:

``` gitignore
##
# shell & app created files

# history & info
.*hist*
.*info*

# Log Files
*.log

# ignore programming
#  patch
*.diff
*.patch

```

#### まとめ

これまでの、ファイルを無視する設定をまとめて"gist"にあげました。
gist に載せた"gitignore"ファイルは、下記になります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitignore)

### 2.4. エディタの設定

Git 操作時のエディタを設定できます。
設定しない場合は、環境変数"EDITOR"で指定したエディタを使用します。

たとえば、Git で`Visual Studio Code`を使いたい場合は以下のように設定します。

```toml: git/config
[core]
    editor = "code --wait "

```

上記のようにすると、コミット時に`VS Code`でコミットメッセージを編集できます。
"--wait"オプションをつけることで、`VS Code`でメッセージの編集が終わるまで`Git{`が待つことになります。

## 3. ユーザーの設定

Git では、"\[user\]"セクションでユーザー名とメールアドレスを設定します。
設定したユーザー名とメールアドレスは、コミットログに`Author`として表示されます。

"git/config"は、以下のようになります:

```toml: git/config
[user]
    name = Furukawa, Atsushi
    email = atsushifx@example.com

```

__注意:__
上記のコードブロックの内容はサンプルです。実際の設定は、自身の設定内容に書き換える必要があります。

## 4.. ブランチの設定

Git では、機能の開発などをブランチに分けることで効率的に開発しています。
この章では Git におけるブランチの設定について解説します。

### 4.1. デフォルトブランチの設定

Git はリポジトリを初期化するときに、指定されたブランチでリポジトリを作成します。
これをデフォルトブランチといい、"git/config"ファイルで指定できます。

次のようにして、デフォルトブランチを設定します。

```toml:  git/config
[init]
    defaultBranch = main

```

このように設定すると、`git init`でリポジトリを初期化したとき、リポジトリは"main"ブランチとなります。

### 4.2. pushするブランチの設定

"git/config"では、`git push`時にブランチをどう扱うかを指定できます。

`push.default = current`とすると、同名のリモートブランチに push します。ブランチがない場合は、新たに同名のブランチを作成して、そのブランチに push します。

`push.autoSetupRemote = true`で push 時に upstream のトラックをします。

これらをまとめた、"git/config"は以下のようになります:

```toml git/config
[push]
    default = current
    autoSetupRemote = true

```

### 4.3. pull/merge関連

`git pull`、`git merge`を実行したときに、`fast forward`をどうするかを指定します。
`pull`の場合は、`ff = only`として HEAD の位置を移動します。
`merge`の場合は、`ff = false`として`fast forward`を行いません。

上記の設定をまとめた"git/config"は以下のようになります:

```toml: git/config
[merge]
    ff = false

[pull]
    ff = only

```

## 5.. エイリアスの設定

Git では、コマンドラインを別名で保存するエイリアス機能があります。
エイリアスを使うと、よく使うコマンドを 2 文字程度に短縮して実行させたり、オプション付きの長いコマンドをわかりやすい別名で実行できます。

### 5.1.コマンドのエイリアス  (短縮コマンド)

よく使うコマンドやオプションをエイリアスとして設定します。
また、"`fixit`"というエイリアスを追加することで、コミットを修正する際に便利なオプションを設定できます。
エイリアスは、次のようになります:

```toml: git/config
[alias]
    st = status
    ss = status -s
    co = checkout
    br = branch
    sw = switch
    pr = pull -r
    ps = push
    fixit = commit --amend --no-edit

```

### 5.2. コミットログのエイリアス (ビジュアライズ)

`git log`コマンドは、さまざまなオプションがありコミット履歴をビジュアルに表示できます。
オプションを覚えるのは大変なので、これもエイリアスにします。

エイリアスは、次のようになります:

<!-- markdownlint-disable line-length  -->
```toml: git/config
[alias]
    l = log --graph --all --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset'
    ll = log --stat --abbrev-commit
    lg = log --color --graph --pretty=format:'%C(bold white)%h%Creset -%C(bold green)%d%Creset %s %C(bold green)(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    llg = log --color --graph --pretty=format:'%C(bold white)%H %d%Creset%n%s%n%+b%C(bold blue)%an <%ae>%Creset %C(bold green)%cr (%ci)' --abbrev-commit

```
<!-- markdownlint-enable line-length  -->

### 5.3. エイリアスの一覧表示

設定したエイリアスの一覧を取得するコマンドもあります。これもエイリアスとして設定します。
エイリアスは、次のようになります:

```toml: git/config
[alias]
    aliases = !git config --get-regexp '^alias\\.' | sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\\t => \\2/' | sort

```

## 6. まとめ

ここまでの設定を 1つにまとめると、オススメの"git/config"になります。
作成した"git/config"は、以下のようになります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitconfig)

## 7. Gitを使いこなすためのサポートツール

Git をさらに使いこなすには、下記で紹介したツールが使えます。

### 7.1. Windows用ツール: Scoop

`Scoop`は、Windows 用のオープンソースのパッケージマネージャーです。
OSS の開発ツールや、GitHub に掲載されたツールが多く載っていることが特徴で、Git の機能を拡張するツールも多く載っています。

Scoop のインストールについては、拙記事、[Scoopをディレクトリ指定つきでインストールする方法](winhack-scoop-install-withdir)を参照してください。

### 7.2. Git機能拡張ツール: posh-git

`posh-git`は、Git にタブ補完機能などを追加する PowerShell のモジュールです。
インストールは、`Scoop`で簡単にできます。

次の手順で、`posh-git`をインストールします。

1. scoop に extras bucket を追加する:

   ```powershell
    scoop bucket add extras
    ```

2. scoop を使用して`posh-git`を人ストールする:

   ```powershell
   scoop install posh-git
   ```

3. $profile に以下の行を追加して、`posh=git`モジュールをインポートする:

   ``` powershell: $profile
   Import-module posh-git
   ```

以上で、インストールは終了です。
PowerShell を立ち上げ直すと、タブ補完機能が使えます。

### 7.3. Git設定用ツール: gibo

`gibo`は GitHub のテンプレートから、入力したキーワードに対応するテンプレートを出力するツールです。
開発環境にあわせてキーワードを選ぶことで、一気に gitignore を設定できます。

`gibo`は、`scoop`でインストールできます。
次の手順で、`gibo`をインストールします。

1. scoop で `gibo`をインストールする:

   ```powershell
   scoop install gibo
   ```

以上で、`gibo`のインストールは終了です。

## おわりに

この記事を参考にして、Git の設定を行なうことで、より安全に Git を利用できます。
設定ファイルは MIT ライセンスのもとで提供されているため、自由にコピーして使用できます。

こういった設定は一から調べて設定するのは大変です。
この記事の設定やツールを使えば、効率的にプログラミングをはじめられます。
記事やツールを活用し、ソフトウェア開発の効率化や品質の向上に役立ててください。

それでは、Happy Hacking!

## 参考資料

### 本/Webブック

- [Pro Git 2nd Edition](https://git-scm.com/book/en/v2)

### Webサイト

- [gitignore documentation](https://git-scm.com/docs/gitignore)
- [gitattributes documentation)](https://www.git-scm.com/docs/gitattributes)
- [Scoop](https://scoop.sh)
- [posh-git](https://github.com/dahlbyk/posh-git)
- [gibo](https://github.com/simonwhitaker/gibo)
