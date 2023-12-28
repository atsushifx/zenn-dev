---
title: "WSL 開発環境構築: whatコマンドで、スクリプト、設定ファイルを管理する"
emoji: "🐕"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [ "shellscrypt", "コメント", "bash", "what", ]
published: false
---

## はじめに

拙作、[`agla shell utils`](https://github.com/atsushifx/agla-shell-utils)には、シェルスクリプト管理用コマンド`what`が含まれています。
この記事では、`what`の使い方を紹介するとともに、`what`用のヘッダーコメントの書き方を解説します。

`what`コマンドは、`.editorconfig`のような設定ファイルも対象にします。

シェルスクリプトや設定ファイルに`what`用コメントを追加して、開発環境を充実させましょう。

## 1. whatコマンド とは

### 1.1 whatコマンドの機能

what コマンドは、`agla shell utils`に含まれるシェルスクリプト管理用のユーティリティです。
このコマンドは、シェルスクリプトや設定ファイルのバージョン情報と簡単な説明を表示する役割を果たします。

シェルスクリプトを管理し、コードの迅速に理解するのに役立ちます。

### 1.2 whatコマンドの使い方 (short desc)

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

### 1.3 whatコマンドの使い方 (long desc)

'-d'オプションで、コマンドに関する長い説明が表示されます。
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

## 2. whatのインストール

### 2.1. whatのインストール手順

what コマンドは、次の手順でインストールします:

1. what コマンドのダウンロード
   下記のコマンドを実行して、what コマンドをダウンロードする。

   ```bash
   wget https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what
   ```

2. what コマンドのインストール
   ダウンロードした what コマンドを`path`のとおったディレクトリにコピーする。

   ```bash
   cp what ~/bin
   ```

3. 実行権限の追加:
   コピーした what コマンドに実行権限を追加する。

   ```bash
   chmod +x ~/bin/what
   ```

以上で、what コマンドが使えるようになります。

## 3. whatdocコメント

what コマンドでコマンドの説明を出力するには、ファイル内に適切なコメントを追加する必要があります。
このコメントを`whatdoc`コメントと呼びます。
このセクションでは、what コマンド用のコメントの書き方を説明します。

### 3.1 基本的なコメントフォーマット

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
# @description <<
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
#<<

```

**注意事情**:
whatdocコメントはヘッダー部に記述します。`shebang`のあとに`#`コメントを続ける必要があります。

whatdocコメントは、`@(#)`からはじまります。
`@(#)`は、`SCSS`という UNIX系OS で使われてたバージョン管理システム用のヘッダーです。
ここから、ヘッダーコメントの最終行までが whatdocコメントになります。

### 2.2 short desc

`@(#)`ではじまるコメントは、コマンドの簡単な説明となります。
`what <ファイル名>`で出力される説明は、ここのコメントとなります。

### 2.3 コメントタグ

whatdoc コメントでは、`@`から始まるキーワードをコメントタグとして認識します。
現在、what コマンドでは`@version`しか使っていません。
シェルスクリプトの管理のためには、`@author`などのほかのタグも書いておくといいでしょう。

コメントタグの一覧を下記に載せておきます:

| コメントタグ | 記法 | 説明 | 備考 |
| --- | --- | --- | --- |
| @version | @version <バージョン番号> | バージョン番号をセマンティックバージョニングで記述する | what の short descにバージョン番号を出力 |
| @author | @author <氏名> | スクリプトの作成者を記述  |  |
| @date | @date <日時> | スクリプトの作成日時を記述 | |
| @license |  @license <ライセンス> | 主に`OSS`のライセンスを略号で記述 | |
| @desc | @desc << ... << | スクリプトの長い説明をヒアドキュメントで記述 | 詳細は、[後述](#24-long-desc) |

### 2.4 long desc

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

what コマンドや whatdoc コメントを使い、WSL や Linux での生産性を向上させましょう。

それでは、Happy Hacking!

## 参考資料

- `agla shell utils`: <https://github.com/atsushifx/agla-shell-utils>
