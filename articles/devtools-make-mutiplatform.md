---
title: "make: MakefileでOSを判定してOS別のビルドを行う方法"
emoji: "🔧"
type: "tech"
topics: [ "Makefile", "ビルド", "OS", "Go" ]
published: false
---

## はじめに

プログラムをビルドするときに、OS によってコンパイラオプションや実行ファイルの名前を変更する必要があります。
手動でこれらを切り替えるのは手間がかかる作業です。

この記事では、ビルドツール"make"で OS と CPU を判定し、OS 別にプログラムをビルドする方法を紹介します。

## 前提環境

この記事では、以下の環境を前提としています。

- `GNU Make`を使用する
- `uname`コマンドが使用できる

Windows 環境の場合は、[WindowsにUNIX系ツールをインストールする方法](https://zenn.dev/atsushifx/articles/winhack-unixutils-install)を参照してツールをインストールする必要があります。

## make について

### makeとは

"`make`"はビルドツールの 1つで、`Makefile`に基づいてビルドを行います。
`Makefile`はビルドを自動化するために、ソースファイルなどの依存関係やコンパイルオプションなどを記述したテキストファイルです。

make を実行すると、まず`Makefile`を読み込みます。その後、ファイルの依存関係から新しくなったソースファイルをコンパイルし、最終的に実行ファイルを作製します。

### makeとMakefile

Makefile は、メタデータの一種で、ビルドプロセスの一部を表現するファイルです。Makefile には、ビルドするソースコードのファイル名、コンパイルするコマンド、コンパイル時のオプションなどが定義されています。Makefile を作成すると、ビルド時の手作業の作業を自動化できます。

Makefile は、以下のようなルールで構成されています。

``` Makefile
ターゲット: 依存ファイル
    コマンド
```

- ターゲット：生成するファイル名やルール名などを指定します。
- 依存ファイル：ターゲットを作る際に必要なファイル名を指定します。
- コマンド：ビルドの際に実行されるコマンドを指定します。

たとえば、`Go`で"Hello,World!"プログラムをビルドするには:

``` Makefile
hello.exe: hello.go
    go build .

``

のように書けます。

## Makefileの作成

この記事での`Makefile`は、OS/アーキテクチャの判定とそれによる振り分けを行います。
実際のビルド方法は OS 別の Makefile に記述します。

### OSの判定

Make では、実行した OS が自動変数"$(OS)"に記録されます。`uname -s`コマンドで OS が取得できます。
これらから OS を判定する`Makefile`のスクリプトは、以下のようになります。

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
    endif
    ifeq ($(UNAME_OS),Darwin)
        GOOS := darwin
        GOMAKEFILE := make-mac.mk
    endif
endif

```

このスクリプトを実行すると、`GOOS`に`windows`,`linux`,`darwin`などの OS 名が入ります。
また、`GOMAKEFILE`に OS ごとの`Makefile`のファイル名がはいります。

### アーキテクチャの判定

`uanme -m`コマンドで実行している CPU が取得できます。
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

上記のスクリプトでは、`GOARCH`に判定したアーキテクチャを記録しています。

### 環境の引き継ぎ

取得した OS、アーキテクチャは、環境変数として OS 別の Makefile に引き継ぎます。
そのため、ファイルの先頭に`export`を記述します。

### 最終的なMakefile

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
    endif
    ifeq ($(UNAME_OS),Darwin)
        GOOS := darwin
        GOMAKEFILE := make-mac.mk
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

上記の`Makefile`は、`Go`プロジェクトの基本的なものです。
実際には、`Makefile`に記述を追加しています。

<!-- markdownlint-disable -->
**注意**
<!-- markdownlint-enable -->

- `Zenn`用に空白でインデントしています。実際に使うには、空白をタブに置き換える必要があります。

## さいごに

この記事では、OS 別の`Makefile`を自動的に起動する方法を紹介しました。
マルチプラットフォームのプロジェクトだと、このような OS 別のビルドが役に立つでしょう。

それでは、Happy Hacking!

## 技術用語と注釈

- GNU Make：ビルドツール
- Makefile：`make`コマンドで、ビルドプロセスを記述するファイル

## 参考資料

### Webサイト

- GNU Make: <https://www.gnu.org/software/make/>
