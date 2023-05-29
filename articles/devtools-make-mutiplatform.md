---
title: "MakefileでOSを判定してOS別のビルドを行う方法"
emoji: "🔧"
type: "tech"
topics: [ "Makefile", "ビルドツール", "make", "OS判定" ]
published: false
---

## はじめに

この記事では、`make`コマンドと`Makefile`を使って`OS`を自動判定し、OS ごとに適切なビルドを行なう方法を紹介します。

プログラムをコンパイル・ビルドするときに、OS によってコンパイラオプションや出力ファイルの設定が異なる場合があります。
これらを、毎回手動で切り替えるのは手間がかかり、手動で切り替える際に誤りが発生する可能性があります。

開発ツールにこの処理を任せることで、手間を減らしエラーを防止できます。

## 1. 前提環境

この記事では、以下の環境を前提としています。

- ``GNU Make``を使用する
- `uname`コマンドがインストールされていること

`uname`コマンドはシステムの動作環境を取得するコマンドですが、UNIX系のツールなの Windows には入っていません。
Windows 環境の場合は、[WindowsにUNIX系ツールをインストールする方法](https://zenn.dev/atsushifx/articles/winhack-unixutils-install)を参照してツールをインストールする必要があります。

## 2. makeとは

### 2.1. makeとはなにか

`make`はビルドツールの 1つで、`Makefile`に基づいてビルドを行います。
`Makefile`はビルドを自動化するために、ソースファイルなどの依存関係やコンパイルオプションなどを記述したテキストファイルです。

`make`を実行すると、まず Makefile を読み込み、ビルドプロセスを実行します。
その後、ファイルの依存関係から新しくなったソースファイルをコンパイルし、最終的に実行ファイルを作製します。

### 2.2. makeとMakefile

Makefile はビルドを自動化するために使用されるテキストファイルであり、[ソースファイル]や[依存関係]、[コンパイルオプション]などが記述されます。
[依存関係]は、ビルドに必要なソースファイル間の依存関係を示し、[コンパイルオプション]はコンパイラに渡されるオプションを指定します。これらの詳細な設定は Makefile に記述され、ビルドプロセスを自動化し、ヒューマンエラーを防ぐことができます。

Makefile は、つぎのようになります。

``` Makefile
ターゲット: 依存ファイル
    コマンド

```

この Makefile について説明すると:

- ターゲット: 作成するファイルを記述します
- 依存ファイル: ターゲットの作成元となるファイルの一覧です
- コマンド: 依存ファイルからターゲットを作成するコマンドを記述します

make ではターゲットと依存関係の作成日時を比較します。依存関係のファイルの方が新しいときにコマンドを実行し、ターゲットを作成します。
ターゲットの方が新しいときには。コマンドによるコンパイル・ビルドは行いません。
これにより、効率的にビルドできます。

## 3. Makefileの作成

この記事での`Makefile`は、OS/アーキテクチャの判定とそれによる振り分けを行います。実際のビルド方法は OS ごとに別の Makefile に記述します。

OS やアーキテクチャの判定は、プログラムが予期せぬ挙動を示すことを防ぐために重要です。ここでは、その方法について詳しく説明します。

### 3.1. OSの判定

Windows 環境では、環境変数 OS に起動した OS が記録され、`Windows_NT` となります。
一方、Linux/Mac 環境では OS 環境変数は利用できませんが、その代わり、`uname -s`コマンドを使って実行中の OS を取得できます。このコマンドは、`POSIX`標準にしたがって OS の名前を返すため、OS の種類を一貫性を持って判定することが可能となります。
また、`uname -s`は、多くの Unix系OS でサポートされており、その普遍性から採用しています。
これらをもとに、以下のような`Makefile`のスクリプトで OS を判定します。

``` Makefile
# set system envrion for Windows
ifeq ($(OS),Windows_NT)
    GOOS := windows
    GOMAKEFILE := make-windows.mk
else
    UNAME_OS := $(shell uname -s)
    ifeq ($(UNAME_OS),Linux)
        GOOS := linux
        GOMAKEFILE := make-linux.mk
    else ifeq ($(UNAME_OS),Darwin)
    GOOS := darwin
        GOMAKEFILE := make-mac.mk
    else
        GOOS := unknown
        GOMAKEFILE := make-unknown.mk
    endif
endif


```

このスクリプトを実行すると、`GOOS`に`windows`,`linux`,`darwin`などの OS 名が入ります。
また、`GOMAKEFILE`に OS ごとの`Makefile`のファイル名が入ります。

OS が判別不可能な場合には、`GOOS`には`unknown`が入ります。この場合には、その旨を表示してビルドを中止すべきです。

### 3.2. アーキテクチャの判定

`uname -m`コマンドで実行している CPU のアーキテクチャが取得できます。
これをもとに、アーキテクチャを設定します。
`Makefile`のスクリプトは、以下のようになります。

``` Makefile
# set architecture
UNAME_MACHINE:=$(shell uname -m)
ifeq ($(UNAME_MACHINE),x86_64)
  GOARCH := amd64
else ifeq (${UNAME_MACHINE},i686)
  GOARCH := 386
else ifeq (${UNAME_MACHINE},aarch64)
  GOARCH := arm64
else
  GOARCH := unknown
endif

```

上記のスクリプトでは、`GOARCH`に判定したアーキテクチャが設定されます。

### 3.3. 環境の引き継ぎ

取得した OS、アーキテクチャは、環境変数として各 OS ごとの Makefile に引き継ぎます。
そのため、ファイルの先頭に`export`を記述します。

### 3.4. 最終的なMakefile

上記のセクションをもとに`Makefile`を作成します。
作成した`Makefile`は、`OS`を自動的に判定して、それぞれの OS ごとに作成した`Makefile`を呼び出しています。

最終的な`Makefile`は、つぎのようになります。

@[gist](https://gist.github.com/atsushifx/d3027771549acaf801e9b86f62214ac8)

上記の Makefile は、`Go`プロジェクトの基本的なテンプレートです。プロジェクトに応じて適宜追加や修正をしてください。

<!-- markdownlint-disable -->
**注意**
<!-- markdownlint-enable -->

- 見やすさを考慮しインデントには空白を使用していますが、実際の`Makefile`ではインデントにタブを使用する必要があります。この`Makefile`を使用する場合は、インデントをタブに変更してください。
  たとえば、`Visual Studio Code`の場合は「インデントをタブの変換」でタブに変換できます。

## さいごに

以上で、Makefile を使用して OS を自動的に判定し、OS ごとに適切なビルドを行なう方法を学びました。
これらの知識を活用すれば、マルチプラットフォームに対応したソフトウェアの開発時に、OS 判定とそれに基づくビルド処理を自動化できます。
これにより、開発効率を大幅に向上させることが可能になります。

それでは、Happy Hacking!

## 技術用語と注釈

- `uname`: UNIX系オペレーティングシステムのコマンドで、システム情報を出力する
- `GNU Make`: ビルドツールの 1つで、`Makefile`に記述されたルールにしたがってビルドを実行する
- Makefile: `make`コマンドが使用するファイルで、ビルドプロセスを記述する

## 参考資料

### Webサイト

- `GNU Make`: <https://www.gnu.org/software/make/>
