---
title: "MakefileでOSを判定してOS別のビルドを行う方法"
emoji: "🔧"
type: "tech"
topics: [ "Makefile", "ビルドツール", "make", "OS判定" ]
published: false
---

## はじめに

プログラムをコンパイル・ビルドするときに、OS によってコンパイラオプションや出力ファイルが異なります。
これらを、毎回手動で切り替えるのは手間がかかり、誤りの可能性があります。

開発ツールにこの処理を任せることで、手間を減らしエラーを防止できます。

この記事では、ビルドツール"make"を使って OS 別にビルドさせる方法を紹介します。
自動的に判定されるので、ファイルの書き換えや問題が発生しません。

## 1. 前提環境

この記事では、以下の環境を前提としています。

- ``GNU Make``を使用する
- `uname`コマンドが使用できる

`uname`コマンドはシステムの動作環境を取得するコマンドですが、UNIX系のツールなの Windows には入っていません。
Windows 環境の場合は、[WindowsにUNIX系ツールをインストールする方法](https://zenn.dev/atsushifx/articles/winhack-unixutils-install)を参照してツールをインストールする必要があります。

## 2. makeとは

### 2.1. makeとはなにか

"`make`"はビルドツールの 1つで、`Makefile`に基づいてビルドを行います。
`Makefile`はビルドを自動化するために、ソースファイルなどの依存関係やコンパイルオプションなどを記述したテキストファイルです。

make を実行すると、まず`Makefile`を読み込みます。その後、ファイルの依存関係から新しくなったソースファイルをコンパイルし、最終的に実行ファイルを作製します。

### 2.2. makeとMakefile

Makefile はビルドを自動化するために使用されるテキストファイルであり、ソースファイルや依存関係、コンパイルオプションなどが記述されます。
依存関係は、ビルドに必要なソースファイル間の関係を示し、コンパイルオプションはコンパイラへの指示を表します。これらの詳細な設定は Makefile に記述され、ビルドプロセスを自動化し、ヒューマンエラーを防ぐことができます。

たとえば、`Go`で"Hello,World!"を出力するプログラムの場合、
Makefile は、つぎのようになります。

``` Makefile
hello.exe: hello.go
    go build hello.go

```

この Makefile について説明すると:

- hello.exe: ターゲット: 作成するファイルを記述します
- hello.go: 依存関係: ターゲットである`hello.exe`の作成元となるファイルの一覧です
- go build hello.go: コマンド: 依存関係のファイルからターゲットを作成するコマンドを記述します

make ではターゲットと依存関係の作成日時を比較します。依存関係のファイルの方が新しいときにコマンドを実行し、ターゲットを作成します。
ターゲットの方が新しいときには。コマンドによるコンパイル・ビルドは行いません。
これにより、効率的にビルドできます。

## 3. Makefileの作成

この記事での`Makefile`は、OS/アーキテクチャの判定とそれによる振り分けを行います。
実際のビルド方法は OS ごとに別の Makefile に記述します。

### 3.1. OSの判定

Windows 環境では、環境変数 OS に起動した OS が記録され、`Windows_NT` となります。
一方、Linux/Mac 環境では OS 環境変数は利用できません。その代わり、name -s コマンドを使って実行中の OS を取得します。このコマンドは、`POSIX`標準にしたがって OS の名前を返すため、OS の種類を一貫性を持って判定することが可能となります。
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

### 3.2. アーキテクチャの判定

`uanme -m`コマンドで実行している CPU のアーキテクチャが取得できます。
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
最終的な`Makefile`は、つぎのようになります。

``` Makefile
# @(#) : Makefile for OS common
#
# @version  1.0.0
# @author   Furukawa, Atsushi <atsushifx@aglabo.com>
# @date     2023-05-29
# @license  MIT
#
# @desc<<
#
#<<
export

# go command
GOCMD   := go
GOBUILD := $(GOCMD) build
GOCLEAN := $(GOCMD) clean

# FLAGS
LDFLAGS="-s -w"

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


# set architecture
UNAME_MACHINE:=$(shell uname -m)
ifeq ($(UNAME_MACHINE),x86_64)
    export GOARCH := amd64
else ifeq (${UNAME_MACHINE},i686)
    export GOARCH := 386
else ifeq (${UNAME_MACHINE},aarch64)
    export GOARCH := arm64
else
    export GOARCH := unknown
endif

# set Makefile

.PHONY: env
env:
    ${MAKE} -f ${GOMAKEFILE} env

.PHONY: clean
clean:
    ${MAKE} -f ${GOMAKEFILE} go-clean

.PHONY: build
build:
    $(MAKE) -f  $(GOMAKEFILE) go-build

```

上記の Makefile は、`Go`プロジェクトの基本的なテンプレートです。プロジェクトに応じて適宜追加や修正をしてください。

<!-- markdownlint-disable -->
**注意**
<!-- markdownlint-enable -->

- ここでは見やすさを考慮し、インデントには空白を使用しています。しかし、実際の`Makefile`ではインデントにタブを使用する必要があります。したがって、この`Makefile`を使用する場合は、インデントをタブに変更してください。

## さいごに

この記事を通じて、Makefile を使って OS を自動的に判定し、それに応じて OS 別のビルドを行なう方法を学びました。
この技術は、複数のプラットフォームを対象としたプロジェクトにおいてとくに有用です。
これらの知識を活用して、ビルドプロセスの自動化を進め、効率的な開発を実現しましょう。

それでは、Happy Hacking!

## 技術用語と注釈

- `GNU Make`：ビルドツール
- Makefile：`make`コマンドで、ビルドプロセスを記述するファイル

## 参考資料

### Webサイト

- `GNU Make`: <https://www.gnu.org/software/make/>
