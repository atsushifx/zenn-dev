---
title: "開発環境構築: Gitの効果的な活用を支援するグローバル設定"
emoji: "🔧"
type: "tech"
topics: [ "環境構築", "開発環境", "Git", "gitconfig", "SCM" ]
published: true
---

## はじめに

この記事では、エンジニアが効果的かつ安全に開発を行なうための Git のグローバル設定に焦点を当てます。
Git グローバル設定での具体的な設定方法について説明します。
さらに、Git を活用するためのサポートツールまでを解説します。

## 技術用語と注釈

この記事で使用する技術用語について簡潔に説明します。

- `Git`: プログラムの変更を管理するための分散型バージョン管理システム
- `gitconfig`: Git の設定ファイル
- `gitattributes`: ファイルごとに Git の動作を指定するための設定ファイル
- `gitignore`: Git の管理対象外とするファイルを指定する設定ファイル
- `XDG Base Directory`: 設定ファイルを保存するディレクトリの仕様
- `Scoop`: Windows 向けのパッケージマネージャー
- `リポジトリ`: バージョン管理しシステムでコードやのファイルの変更履歴を管理する場所
- `SCM`: ソフトウェア開発のためにソースコードやその他のファイルを管理するソフトウェア構成管理システム

## 1. Gitの設定の詳細

Git の設定は、3つの段階で管理されます。

- system: システム全体の設定を記述: (通常、変更不要)
- global: ユーザーごとの共通の設定を記述
- local: リポジトリごとの設定を記述

### 1.1. グローバル設定の詳細

**Git のグローバル設定**は、ユーザーごとの共通設定を記述します。
具体的には、ユーザー名などのユーザーごとの設定項目、改行コードなどの OS に付随する設定項目、gitignore などの Git を使ううえで基本となる設定項目などです。

### 1.2. グローバル設定の保存先

Git は、`XDG Base Directory`に対応しています。そのため、環境変数"XDG_CONFIG_HOME"以下に各設定ファイルを保存します。
設定ファイルの保存先は、以下の通りです。

 | 設定ファイル | 保存先 | 説明 |
 | --- | --- | --- |
 | gitconfig | $XDG_CONFIG_HOME/git/config | Gitの設定ファイル |
 | gitignore | $XDG_CONFIG_HOME/git/ignore | Gitの管理対象外となるファイルの設定ファイル |
 | gitattributes | $XDG_CONFIG_HOME/git/attributes | ファイルごとのGitの属性を設定するファイル |

以後、実際の保存先は上記のテーブルで示したものになります。

## 2. 基本設定

基本設定では、\[core\]セクションに設定を記述します。
\[core\]には、改行コードやシンボリックの扱いなどの Git の基本的な設定を記述します。

### 2.1. 改行コードと属性の設定

テキストファイルの改行コードは、`UNIX/Linux` の`LF`で統一します。
コミット時に改行コードを`LF`に変更するので`autocrlf=input`と設定します。

"gitconfig"ファイルは、以下のようになります:

```toml:  gitconfig
# gitの改行コード設定 / コミット時にLFに統一
[core]
    autocrlf = input

```

上記の改行コード変換は、Git の属性で制御できます。
Git で管理するファイルはそれぞれ属性を持ち、"text" 属性なら改行コードを変換します。逆に "binary" 属性ならば、コードの変換は行なわず、ファイルはもとのままです。

### 2.2. gitattributesの設定

`gitattributes`ファイルは、各ファイルに対する属性を設定するためのファイルです。
通常、ファイルの拡張子ごとに属性を設定します。以下は設定の一部例です:

```toml: gitattributes
###############################################################################
# Set default behavior to automatically normalize line endings.
###############################################################################
*  text=auto

## Audio

*.aif       binary
*.aiff      binary
*.it        binary

```

`* text=auto`は、ファイルが"text"か"binary"かを Git が判断するための設定です。
音声ファイルや画像ファイルは"binary"属性とします。これにより、ファイルが破損することなくリポジトリに登録されます。

これらの設定をまとめた、この記事での設定例は下記の通りとなります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitattributes)

### 2.3.  gitignoreの設定

`gitignore`ファイルは、リポジトリで管理したくないファイルを無視するためのファイルです。
以下は異なるカテゴリの無視ファイルの設定例です。

#### OS別ファイルの無視

OS が自動的に作成するファイル (例: `thumbs.db`) はリポジトリに登録すべきではありません。
これらを無視するための設定は以下の通りです:

```:gitignore
##
# OS created files
#
.DS_Store
thumbs.db

```

#### 一時ファイル／バックアップの無視

エディタやツールが作成する一時ファイルやバックアップファイルもリポジトリに登録すべきではありません。
これらを無視するための設定は以下の通りです:

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
これらを無視するための設定は以下の通りです:

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

#### その他のファイル

その他、ヒストリーやログファイル、patch 用のファイルなどを無視します。
これらを無視するための設定は以下の通りです:

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

#### gitignore の設定例

上記の無視ファイルの設定は、リポジトリの整理を助けるために重要です。
設定例は以下の通りです:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitignore)

### 2.4. エディタの設定

Git では、コミットメッセージの編集などの処理にエディタを使用します。
通常、ユーザーがデフォルトとして設定したエディタが使われますが、"gitconfig"で設定もできます。

#### デフォルトエディタ

デフォルトエディタは、コマンドラインで何かの処理をするときにファイルの編集用に起動するエディタです。
環境変数"EDITOR"によって設定されます。
Git では、"gitconfig"でエディタを指定しない限り、上記のデフォルトエディタが使われます。
環境変数"EDITOR"が設定されていない場合、`Git for Windows`に組み込まれている`vi`エディタが使用されます。

#### gitconfigでのエディタ指定

Git が使用するエディタを"gitconfig"で指定できます。
たとえば、Git で`Visual Studio Code`を使いたい場合は以下のように設定します。

```toml: git/config
[core]
    editor = "code --wait "

```

上記のようにすると、コミット時に`VS Code`でコミットメッセージを編集できます。
"--wait"オプションをつけることで、`VS Code`でメッセージの編集が終わるまで`Git`が待つことになります。

## 3. ユーザー設定

ユーザーの設定は、\[user\]セクションで行ないます。ここで設定されたユーザー情報は、コミットログに表示されます。
これにより、コミットの履歴がわかりやすくなります。

"gitconfig"ファイル内の[user]セクションに以下のように設定します:

```toml: gitconfig
[user]
    name = Your Name
    email = yourname@example.com

```

**注意:**
上記のコードブロックの内容はサンプルです。実際の設定は、自身の設定内容に書き換える必要があります。

## 4. ブランチの設定

Git では、ブランチを使用して機能の開発などを分けることができます。
グローバル設定では、リポジトリのメインとなるデフォルトブランチや、ブランチをローカルからリモートへ push するときのブランチの扱いなどを設定します。

### 4.1. デフォルトブランチの設定

リポジトリを初期化する際に作成されるデフォルトブランチを設定できます。
"gitconfig"ファイル内\[init\]セクションに以下のように設定します:

```toml:  gitconfig
[init]
    defaultBranch = main

```

このように設定すると、`git init`でリポジトリを初期化したとき、リポジトリは"main"ブランチとなります。

### 4.2. pushするブランチの設定

"git/config"では、`git push`時にブランチをどう扱うかを指定できます。

`push.default = current` とすると、同名のリモートブランチに push します。
もしリモートに同名のブランチが存在しない場合、新たに同名のブランチを作成して、そのブランチに push します。

`push.autoSetupRemote = true`で push 時に upstream のトラックをします。

これらをまとめた、"git/config"は以下のようになります:

```toml git/config
[push]
    default = current
    autoSetupRemote = true

```

### 4.3. pull/merge関連

git pull コマンドを実行する際に、fast forward の動作をどのようにするかを指定できます。また、git merge コマンドを実行した際にも、fast forward の挙動を指定できます。

pull の場合は、`ff = only` として HEAD の位置を移動します。
merge の場合は、`ff = false` として fast forward を行ないません。
上記の設定をまとめた"git/config"は以下のようになります:

```toml: gitconfig
[merge]
    ff = false

[pull]
    ff = only

```

## 5. エイリアスの設定

Git では、コマンドラインを別名で保存するエイリアス機能があります。
エイリアスを使うと、よく使うコマンドを 2 文字程度に短縮して実行させたり、オプション付きの長いコマンドをわかりやすい別名で実行できます。

### 5.1.コマンドのエイリアス  (短縮コマンド)

 よく使うコマンドやオプションをエイリアスとして設定することで、短縮したコマンドや見やすい名前でコマンドを実行できま。
また、下記の"`fixit`"というエイリアスは、コミットメッセージを編集せずに新たな修正を追加するコマンドです。このように、Git で行ないたい操作をエイリアスを使うことで、1つのコマンドとして実装できます。

上記のエイリアスまとめた"gitconfig"は、次のようになります:

```toml: gitconfig
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
```toml: gitconfig
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

```toml: gitconfig
[alias]
    aliases = !git config --get-regexp '^alias\\.' | sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\\t => \\2/' | sort

```

## 6. まとめ

ここまでの設定を 1つにまとめると、オススメの"gitconfig"になります。
作成した"gitconfig"は、以下のようになります:

@[gist](https://gist.github.com/atsushifx/da90cf2d7de1a9de897935f6776b0598?file=gitconfig)

## 7. Gitを使いこなすためのサポートツール

Git をさらに使いこなすには、下記で紹介したツールが使用できます。

### 7.1. Windows用ツール: Scoop

`Scoop`は、Windows 向けのオープンソースパッケージマネージャーです。
GitHub に掲載されたツールや、開発ツールなどが豊富に含まれており、Git の機能を拡張するツールも多く提供されています。

Scoop のインストールについては、拙記事、[Scoopをディレクトリ指定つきでインストールする方法](winhack-scoop-install-withdir)を参照してください。

### 7.2. Git機能拡張ツール: posh-git

`posh-git`は、Git にタブ補完機能などを追加する PowerShellモジュールです。
次の手順で、Scoop を使って`posh-git`をインストールします。

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

以上で、インストールは終了です。PowerShell を立ち上げ直すと、タブ補完機能が使えます。

### 7.3. Git設定用ツール: gibo

`gibo は、GitHub のテンプレートを使用して、指定したキーワードに対応する gitignore テンプレートを生成するツールです。
開発環境に合わせて選択したキーワードを使用することで、簡単に gitignore を設定できます。

`gibo`は、`scoop`を使用して簡単にインストールできます。
以下は`gibo`をインストールする手順です:

1. scoop で `gibo`をインストールする:

   ```powershell
   scoop install gibo
   ```

以上の手順で、`gibo`を使用して gitignore テンプレートを簡単に生成できるようになります。

## おわりに

この記事を参考にして、Git の設定を行なうことで、より安全に Git を活用できます。
提供されている設定ファイルは MITライセンスの下で自由に使用できます。

ここで紹介した設定やツールを活用することで、効率的なプログラミングを始めることができます。
ソフトウェア開発の効率化と品質向上に役立ててください。

それでは、Happy Hacking!

## 参考資料

### 本

- [Pro Git 2nd Edition](https://git-scm.com/book/en/v2) : Git に関する詳細な解説が掲載されています。

### Webサイト

- [gitignore documentation](https://git-scm.com/docs/gitignore)
- [gitattributes documentation](https://www.git-scm.com/docs/gitattributes)
- [Scoop](https://scoop.sh)
- [posh-git](https://github.com/dahlbyk/posh-git)
- [gibo](https://github.com/simonwhitaker/gibo)
