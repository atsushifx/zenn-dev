---
title: "WSL開発環境: whatコマンドによるスクリプト管理"
emoji: "🐧"
type: "tech"
topics: [ "Linux", "shellscript", "コメント", "what", "whatdoc", ]
published: true
---

## はじめに

スクリプトの管理に役立つ`what`コマンドの使い方を紹介します。
`what`コマンドは、`whatdoc`コメントという特定のフォーマットのコメントをもとに、スクリプトのバージョンや説明を出力します。
`what`コマンドと`whatdoc`コメントを活用することで、スクリプトの理解が容易になります。

## キーワード

以下で、使用する重要なキーワードを説明します。

- `what`コマンド:
  ファイルのメタデータ (バージョン、説明など)を出力するコマンド。メタデータは、ファイル内の`whatdoc`コメントで記述される。

- `whatdoc`コメント:
  スクリプト内に記述される特定のフォーマットのコメント。メタデータ (バージョン・作成日・説明など) の提供に利用される。

- `SCCS` (`Source Code Control System`):
  旧来の UNIX系OS で使われていたバージョン管理システム。`what`コマンドの起源となっている。

- メタデータ:
  スクリプト、設定ファイルのバージョンや説明などを指す。

- シェルスクリプト:
  コマンドラインで実行するスクリプト言語であり、Unix/Linux系OS で広く利用される。

## 1. `what`コマンドの概要

`what`コマンドは、シェルスクリプトや設定ファイルのメタデータ (バージョン、説明など) を出力するコマンドです。
`whatdoc`コメントという特定のフォーマットで書かれたコメントをもとに、スクリプトのバージョンや説明を出力します。

**注意**
`whatdoc`コメントに関しては、[4. `whatdoc`コメントの基本](#4-whatdocコメントの基本)を参照してください。

## 2. `what`コマンドのインストール方法

WSL上の Debian に`what`コマンドをインストールする方法を説明します。

### 2.1 `what`コマンドのインストール手順

`what`コマンドは、次の手順でインストールします:

1. `what`コマンドのダウンロード
   下記のコマンドを実行して、what コマンドをダウンロードする。

   ```bash
   wget https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what
   ```

2. `what`コマンドのインストール
   ダウンロードした`what`コマンドを`path`の通ったディレクトリにコピーする。

   ```bash
   sudo cp what /opt/bin
   ```

3. 実行権限の追加:
   コピーした `what`コマンドに実行権限を追加する。

   ```bash
   sudo chmod +x /opt/bin/what
   ```

以上で、`what`コマンドが使えるようになります。

## 3. `what`コマンド の基本機能

`what`コマンドは、指定したファイルに関するメタデータ (バージョン、説明など) を出力します。
このセクションでは、`what`コマンドの使用方法を説明します。

### 3.1 `what`コマンドの基本操作

`what`コマンドの基本的な使い方は以下のとおりです。

```bash
what <ファイル名>
```

で、指定したファイルのバージョンと 1行説明を出力します。

下記のような`whatdoc`コメントがファイルの場合では、

```bash: sample.sh
#!/usr/bin/env bash
#
# @(#) : Sample script to demonstrate whatdoc
# 注意: このスクリプトは`whatdoc`のデモンストレーションです
#
# @version  1.0.0
#
```

`what`コマンドの実行結果は、次のようになります。

```bash
$ what sample.sh
sample.sh: (v 1.0.0) :  Sample script to demonstrate whatdoc

```

このように、シェルスクリプトに関する情報を簡単に得ることができます。

### 3.2 `what`コマンドの応用操作

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

## 4. `whatdoc`コメントの基本

`what`コマンドでコマンドの説明を出力するには、ファイル内に適切な`whatdoc`コメントを追加する必要があります。
`whatdoc`コメントを適切に使用することで、スクリプトの目的、使用方法などが簡単に把握できます。
これにより、スクリプトのメンテナンスが格段に容易になります。

### 4.1 `whatdoc`コメントの基本フォーマット

whatdoc コメントは、以下のようなフォーマットで記述します:

```bash
#!/usr/bin/env bash
#
# @(#) : display shell script usage
#
# @version 1.0.0
# @author  Furukawa Atsushi <atsushifx@aglabo.com>
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

### 4.2 `whatdoc`コメントのヘッダー (`short desc`)

`@(#)`ではじまるコメントは、コマンドの簡単な説明となります。
`what <ファイル名>`で出力される説明は、ここのコメントとなります。

### 4.3 コメントタグの一覧

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
| @license |  @license <ライセンス> | スクリプトのライセンスを略号で記述 |   |
| @desc | @desc ... | スクリプトの長い説明を複数行のコメントで記述 | 詳細は、後述 |

### 4.4 @descタグ (`long desc`の使用  )

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
各種スクリプトや、`bashrc`などの設定ファイルに`whatdoc`コメントを記述すると、理解が容易になります。

この記事を活用して、あなたの Linux 環境のスクリプトや設定ファイルを効率的に管理しましょう。

それでは、Happy Hacking!

## 参考資料

- `agla shell utils`: <https://github.com/atsushifx/agla-shell-utils>
- `what` コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
- `SCCS`: <https://ja.wikipedia.org/wiki/Source_Code_Control_System>
