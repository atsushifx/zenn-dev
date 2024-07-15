---
title: "Bash: fzf-tab-completion を使ってタブ補完機能を強化する"
emoji: "🐚"
type: "tech"
topics: [ "bash", "fzf", "カスタマイズ", "補完", ]
published: false
---

## はじめに

`fzf` (`command-line fuzzy finder`)は`CLI` (`コマンドラインインターフェイス`) で使用できる高度なファジーファインダーです。
このツールは、大量のテキストから瞬時に目的の情報を見つける機能を提供し、開発者のコマンドラインでの作業効率を大幅に向上させます。

この記事では、`fzf-tab-completion`スクリプトを用いて、`bash`のタブ補完機能を`fzf`のファジーファインダー機能を使って拡張する方法を紹介します。
その結果、`bash`によるファイル名などの補完において、直感的で迅速な操作が可能になり、使い勝手が向上します。

## 1. `fzf`の基本

このセクションでは、`fzf`について紹介し、基本的な使い方について説明します。
また、`fzf-bash-completion.sh`についても紹介します。

## 1.1 `fzf`の使い方

`fzf`は、テキスト入力に基づいてリストから項目を動的に絞り込み、選択します。

たとえば、`GitHub`上のリポジトリを管理するコマンド`ghq`と組み合わせて使用すると、`ghq`が管理するリポジトリの一覧から素早く目的のディレクトリを検索し、選択して直接そのディレクトリに移動できます。
これにより、多くのリポジトリの中から必要なものを迅速に見つけ出すことができ、作業効率が向上します。

## 1.2 `fzf-tab-completion`の紹介

`fzf-tab-completion`は`bash`のタブ補完機能に、インタラクティブな検索と選択機能を追加するスクリプトです。
これを導入することで、ユーザーはコマンドラインでファイル名やコマンドのオプションを入力するときに、`fzf`の強力な機能を利用できます。
具体的には、ファイル名やコマンドのオプションを`fzf`の検索ウィンドウに表示し、キーワードで絞り込んで選択できます。
これにより、コマンドライン操作の効率が大幅に向上します。

## 2. セットアップ方法

`fzf-tab-completion`のインストールと設定方法について説明します。
このスクリプトを`bash`に組み込むことで、タブ補完機能を強化し、洗練されたコマンドライン操作を実現できます。
このセクションでは、スクリプトのダウンロードから配置、そして組み込みまでの手順を詳しく説明します。

### 2.1 `fzf-tab-completion`のインストール

`GitHub`から`fzf-bash-completion.sh`スクリプトをダウンロードし、ユーザーの`~/.config/bash/scripts/`ディレクトリに配置します。
具体的な手順は、次の通りです:

1. `スクリプト`の`クローン`:
   次のコマンドを実行し、`GitHub`のリポジトリから`fzf-bash-completion.sh`を`クローン`します。

   ```bash
   git clone https://github.com/lincheney/fzf-tab-completion.git
   ```

   実行結果は、次のようになります。

   ```bash
   Cloning into 'fzf-tab-completion'...

   remote: Enumerating objects: 1798, done.
   remote: Counting objects: 100% (610/610), done.
   remote: Compressing objects: 100% (270/270), done.
   remote: Total 1798 (delta 328), reused 423 (delta 300), pack-reused 1188
   Receiving objects: 100% (1798/1798), 328.76 KiB | 14.29 MiB/s, done.
   Resolving deltas: 100% (825/825), done.

   ```

2. `スクリプト`の配置:
   `クローン`したリポジトリ内の`fzf-bash-completion.sh`を `~/.config/bash/scripts/`にコピーします。
   次のコマンドを実行します。

   ```bash
   cd fzf-tab-completion/bash/
   cp fzf-bash-completion.sh ~/.config/bash/scripts/
   ```

以上で、スクリプトのインストールは終了です。
次に、組み込みスクリプトを作成して`fzf-tab-completion`を`bash`に組み込みます。

### 2.2 `fzf-tab-completion`の組み込み

`fzf-tab-completion`を使用するために、組み込みスクリプトを作成して`fzf-tab-completion`を`bash`に組み込みます。
その後、`bash`を再起動し、`fzf-tab-completion.sh`を読み込みます。

具体的な手順は、次の通りです:

1. 組み込みスクリプトの作成:
   `~/.config/bash/completion.d/`下に、下記の組み込みスクリプト `fzf-sethook.bash`を作成します。

   ```bash: fzf-sethook.bash
   # @(#) fzf completion with bash cli

   function fzf-sethook() {
     export FZF_DEFAULT_OPTS="--height 40% --border"
     . "${BASHSCRIPTS_DIR}/fzf-bash-completion.sh"
     bind -x '"\e[Z": fzf_bash_completion'
   }

   fzf --version >/dev/null 2>&1 && fzf-sethook
   unset fzf-sethook

   ```

2. `bash` の再起動:
   `bash` を再起動し、スクリプトを反映させます。

*要点*:

- $BASHSCRIPTS_DIR は、`fzf_bash_completion.sh`を配置したディレクトリ`~/.config/bash/scripts`が保存されています。
- このスクリプトでは、`fzfによる補完には`Shift+Tab`キーを割り当てています。
- `bashrc`は、`~/.config/bash/completion.d/`下の`.bash`スクリプトを自動的に実行しています。

## 3. `fzf`によるタブ補完機能の使い方

このセクションでは、`fzf`を活用したタブ補完機能の具体的な使い方について紹介します。
`fzf`による直感的な操作をコンソールに表示されるテキストや具体的なコマンドを使って説明し、いままでのタブ補完との違いを学びます。

この機能を使いこなすことで、ファイルやディレクトリ、コマンドのオプションを素早く正確に見つけることが可能となり、日々のコマンドライン作業が格段にスムーズになります。

## 3.1 タブ補完機能の使用例

`Shift+Tab`キーで、`fzf`を使った補完機能が使用できます。
たとえば、次のようにインタラクティブにディレクトリを移動できます:

1. `cd <ディレクトリ>`の入力:
   `cd ~/w`と入力し、`tab`キーで`workspaces`を補完します。

   ```bash
   > cd ~/w  # <~ <tab>キーを入力
     ↓
   > cd ~/workspaces

   ```

2. ディレクトリの選択:
   `Shift+Tab`キーで、サブディレクトリ一覧を表示し、移動したいディレクトリを選択します。

   ```bash
   ╭───────────────────────────────────────────────────────╮
   │  $ cd ~/workspaces/
   │    4/4 ────────────────────────────────────────────────
   │    ~/workspaces/develop/
   │    ~/workspaces/sandbox/
   │    ~/workspaces/education/
   │  > ~/workspaces/temp/


   ```

3. ディレクトリの選択結果:
   ディレクトリを選択すると、コマンドラインに反映されます。

   ```bash
   cd ~/workspaces/education/

   ```

4. ディレクトリの補完:
   ディレクトリが 1つだけの場合は、自動的にディレクトリを補完します。

   ```bash
   cd ~/workspaces/education/self-educations/

   ```

5. ディレクトリの移動:
   `Enter`キーで、入力したディレクトリに移動します。

   ```bash
   cd ~/workspaces/education/self-educations/

   [self-educations] $
   ```

以上です。
コマンドのオプション、ファイルの指定も同様に使用できます。

## おわりに

以上で、`fzf-tab-completions`の組み込みと使い方を説明しました。
`fzf-tab-completion`を使うことで、`bash`のコマンドライン操作がより直感的になり、使い勝手が向上します。

コマンドライン操作を`fzf`で効率的に行ない、自分はプログラミングに集中しましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語とその注釈です。

- `CLI` (`コマンドラインインターフェイス`):
  ユーザーがテキストコマンドを入力してコンピューターと対話するインターフェイス。

- `fzf`:
  `CLI` (`コマンドラインインターフェイス`) で使用されるファジーファインダー。

- `fzf-tab-completion`:
  `bash`に`fzf`の検索／選択機能を実装し、タブ補完機能を拡張するスクリプト。

- `ファジーファインダー`:
  曖昧な入力にもとづき、テキストから最適なマッチを提供するテキスト検索ツール。

- `プラグインスクリプト`:
  既存のツールを機能を追加するために書かれたスクリプト。

## 参考資料

### Webサイト

- [`fzf` (`command-line fuzzy finder`)](https://github.com/junegunn/fzf):
  `bash`などの`CLI`環境で、一覧の表示／絞り込み／選択を実現するツール。

- [`fzf-tab-completion`](https://github.com/lincheney/fzf-tab-completion):
  `bash`の`tab`補完機能に、`fzf`を組み込むプラグインスクリプト。
