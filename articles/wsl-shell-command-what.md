---
title: "Linux開発環境構築: `what`コマンドによるスクリプト管理と文書化"
emoji: "🐕"
type: "tech"
topics: [ "Linux", "shellscript", "コメント", "what", "whatdoc", ]
published: true
---

## はじめに

この記事では、[`agla shell utils`](https://github.com/atsushifx/agla-shell-utils)に含まれる`what`コマンドを使って、スクリプトを管理する方法を紹介します。
`what`コマンドは、`whatdoc`コメントを解釈し、各シェルスクリプトの説明を提供し、スクリプトの理解を容易にします。

この記事では、`what`の使い方を紹介するとともに、`what`コマンド用コメント`whatdoc`の書き方を解説します。
各種スクリプトや設定ファイルに`whatdoc`コメントを追加して、これらのファイルの理解を容易にしましょう。

## キーワード

以下で、使用する重要なキーワードを説明します。

- `what`コマンド:
  スクリプト内の`whatdoc`コメントを解析して情報を表示するツール。スクリプトの目的や使用方法を簡単に把握できる

- `whatdoc`コメント:
  特定のフォーマットで書かれたコメント、スクリプトの説明やバージョン情報などを含み、スクリプトの理解を容易にする

- `SCCS` (`Source Code Control System`):
  UNIX系OS で使われていたバージョン管理システム。`what`コマンドの由来となっている

## 1. whatコマンド の基本機能

`what`コマンドは、指定したシェルスクリプトに関する情報を出力します。
このセクションでは、`what`コマンドの使用方法を説明します。

### 1.1 whatコマンドの基本

what コマンドは、`agla shell utils`に含まれるシェルスクリプト管理用のユーティリティです。
このコマンドは、シェルスクリプトや設定ファイル中の`whatdoc`コメントを解釈し、ファイルの情報を提供します。

次のように`whatdoc`コメントを追加したスクリプトを`what`コマンドで解析することで、スクリプトの概要を簡単に表示できます。

```bash: sample.sh
#!/usr/bin/env bash
#
# @(#) : Sample script to demonstrate whatdoc
# 注意: このスクリプトは`whatdoc`のデモンストレーションです

```

このスクリプトに対して、`what`コマンドを実行すると次のようになります:

```bash
$ what sample.sh
sample.sh: (v 1.0.0) :  Sample script to demonstrate whatdoc

```

このように、シェルスクリプトに関する情報を簡単に得ることができます。

### 1.2 whatコマンドの基本操作

what コマンドの使い方は簡単です。

```bash
what <ファイル名>
```

で、指定したファイルのバージョンと簡単な説明を出力します。

`what`コマンドの場合は:

```bash
$ what what
what ( v0.0.5 ) : display shell script usage
```

となります。

### 1.3 whatコマンドの応用操作

'-d'オプションで、スクリプトの詳細な説明を表示します。
これにより、より深い理解が可能になります。

このときのコマンドは:

```bash
what -d <ファイル名>
```

となります。

what コマンドの場合は:

```bash
$ what -d what

what <file>
print shell script usage

-d    print usage created by header
-v    print version
-h -? print this usage

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

```

となります。

## 2. whatコマンドのインストール方法

### 2.1. whatコマンドのインストール手順

what コマンドは、次の手順でインストールします:

1. what コマンドのダウンロード
   下記のコマンドを実行して、what コマンドをダウンロードする。

   ```bash
   wget https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what
   ```

2. what コマンドのインストール
   ダウンロードした`what`コマンドを`path`のとおったディレクトリにコピーする。

   ```bash
   cp what ~/bin
   ```

3. 実行権限の追加:
   コピーした `what`コマンドに実行権限を追加する。

   ```bash
   chmod +x ~/bin/what
   ```

以上で、`what`コマンドが使えるようになります。

## 3. `whatdoc`コメントの基本

`what`コマンドでコマンドの説明を出力するには、ファイル内に適切な`whatdoc`コメントを追加する必要があります。
`whatdoc`コメントを適切に使用することで、スクリプトの目的、使用方法などが簡単に把握できます。
これにより、スクリプトのメンテナンスが格段に容易になります。

### 3.1 `whatdoc`コメントの基本フォーマット

whatdoc コメントは、以下のようなフォーマットで記述します:

```bash
#!/usr/bin/env bash
#
# @(#) : display shell script usage
#
# @version 1.0.0
# @author  Furukawa, Atsushi <atsushifx@aglabo.com>
# @date    2023-12-27
# @license MIT
#
# @desc
#
# what <file>
#  print shell script usage
#
# -d    print usage created by header
# -v    print version
# -h -? print this usage
#
#
###
#
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
# THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#
#

```

**注意事情**:
whatdoc コメントはヘッダー部に記述します。`shebang`のあとに`#`コメントを続ける必要があります。

whatdoc コメントは、`@(#)`からはじまります。
`@(#)`は、`SCCS`という UNIX系OS で使われてたバージョン管理システム用のヘッダーです。
ここから、ヘッダーコメントの最終行までが whatdoc コメントになります。

### 2.2 `whatdoc`コメントのヘッダー (`short desc`)

`@(#)`ではじまるコメントは、コマンドの簡単な説明となります。
`what <ファイル名>`で出力される説明は、ここのコメントとなります。

### 2.3 コメントタグの一覧

whatdoc コメントでは、`@`から始まるキーワードをコメントタグとして認識します。
現在、what コマンドでは`@version`しか使っていません。
シェルスクリプトの管理のためには、`@author`などのほかのタグも書いておくといいでしょう。

コメントタグの一覧を下記に載せておきます:

| コメントタグ | 記法 | 説明 | 備考 |
| --- | --- | --- | --- |
| @(#) |  @(#) : \<短い説明> | シェルスクリプトの簡単な説明 | `what`コマンドで、スクリプトの簡単な説明として利用される |
| @version | @version <バージョン番号> | バージョン番号をセマンティックバージョニングで記述する | what の short descにバージョン番号を出力 |
| @author | @author <氏名> | スクリプトの作成者を記述  |  |
| @date | @date <日時> | スクリプトの作成日時を記述 | |
| @license |  @license <ライセンス> | 主に`OSS`のライセンスを略号で記述 |  ライセンス情報を提供する |
| @desc | @desc ... | スクリプトの長い説明を複数行のコメントで記述 | 詳細は、後述 |

### 2.4 @descタグ (`long desc`の使用  )

`@desc`タグは特殊で、複数行に渡ってコメントを記述します。
`@desc`タグ以降の、行頭に`#`をつけたコメントをヒアドキュメントとして認識し、残りのヘッダコメント
が`@desc`タグによるドキュメントとなります。

  ```bash
    # @author  Furukawa, Atsushi <atsushifx@aglabo.com>
    # @date    2023-12-27
    # @license MIT
    #
    # @desc
  +-#
  | # what <file>
  | #  print shell script usage
  | #
  +-##
      .
      .
     <以下、shellscript本文>
  ```

上記の、`+` ... `+`の行が、`long desc`です。

**注意**:
`@desc`タグは、whatdoc コメントの最後につける必要があります。

## おわりに

この記事では、`what`コマンドの使い方と、コマンドを使うためのコメントの書き方を紹介しました。
各種スクリプトや`、bashrc`などの設定ファイルに whatdoc コメントを記述することで、スクリプトや設定ファイルの理解が容易になります。

`what`コマンドを活用すれば、Linux 環境の生産性を向上できます。

それでは、Happy Hacking!

## 参考資料

- `agla shell utils`: <https://github.com/atsushifx/agla-shell-utils>
- `what` コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
- `SCCS`: <https://ja.wikipedia.org/wiki/Source_Code_Control_System>
