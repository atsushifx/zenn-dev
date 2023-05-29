---
title: "Makefileを使用してOSを判定し、OSごとに適切なビルドを行う方法"
emoji: "🔧"
type: "tech"
topics: [ "Makefile", "ビルドツール", "make", "OS判定" ]
published: true
---

## はじめに

この記事では、プログラムのコンパイルやビルドの際に使用する`make`コマンドと`Makefile`を使って OS を自動判定し、OS ごとに適切なビルドを行なう方法を詳細に解説します。
この方式を活用することで、OS の手動切り替えの手間を省き、ビルド中のエラーを防ぐことができます。

## 1. 前提環境

この記事では、以下の環境を前提としています:

- `GNU Make`を使用する
- UNIX系のコマンド、`uname`がインストールされていること

`uname`コマンドはシステムの動作環境を取得するコマンドですが、UNIX系のツールは Windows には含まれていません。
Windows 環境の場合は、[WindowsにUNIX系ツールをインストールする方法](https://zenn.dev/atsushifx/articles/winhack-unixutils-install)を参照して、必要なツールをインストールする必要があります。

## 2. makeとは

### 2.1. makeとはなんですか

`make`はビルドツールの 1つで、コンパイルやビルドを自動化します。
ファイルの依存関係やコンパイルオプションを記述した`Makefile`を使用して、ビルドプロセスを実行します。

`make`を実行すると、まず`Makefile`を読み込み、そこに記述されたビルドプロセスを開始します。
その過程で、新しく更新されたソースファイルを特定し、それらをコンパイルします。
すべてのコンパイルが終わった後、最終的な実行ファイルを作成します。

### 2.2. makeとMakefile

`Makefile`はビルドを自動化するためのテキストファイルです。その中にはソースファイルの依存関係やコンパイルオプションなどが記述されます。これらの設定はビルドプロセスを自動化し、ヒューマンエラーを防ぐことができます。

基本的な`Makefile`の形式は、つぎのようになります。

``` Makefile
ターゲット: 依存ファイル
    コマンド

```

この Makefile について説明すると:

- ターゲット: 作成するファイルを記述します
- 依存ファイル: ターゲットの作成元となるファイルの一覧です
- コマンド: 依存ファイルからターゲットを作成するコマンドを記述します

make ではターゲットと依存ファイルの日時を比較します。依存ファイルの方が新しい場合、にコマンドを実行してターゲットを作成します。
ターゲットの方が新しいときには。コマンドによるコンパイル・ビルドは行いません。
これにより、効率的にビルドできます。

## 3. Makefileの作成

この記事では、`Makefile`に OS/アーキテクチャの判定とそれに基づくビルドの振り分けを行います。実際のビルド方法は、各 OS ごとの`Makefile`に記述されます。

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
        GOOS:=unknown
        GOMAKEFILE:=make-unknown.mk
    endif
endif


```

このスクリプトを実行すると、`GOOS`には実行中の OS 名（`windows`,`linux`,`darwin`など）が入ります。また、`GOMAKEFILE` には、OS ごとの Makefile のファイル名が入ります。

OS が判別不可能な場合には、`GOOS`には`unknown`がセットされます。
この場合には、エラーメッセージを表示してビルドを中止すべきです。

### 3.2. アーキテクチャの判定

`uname -m`コマンドを使用して、実行中の CPU のアーキテクチャを判定します。
このコマンドの結果に基づいて、`GOARCH`には判定されたアーキテクチャ名が設定されます
`Makefile`のスクリプトは、以下のようになります。

``` Makefile
# set architecture
UNAME_MACHINE:=$(shell uname -m)
ifeq ($(UNAME_MACHINE),x86_64)
    GOARCH := amd64
else ifeq ($(UNAME_MACHINE),i686)
    GOARCH := 386
else ifeq ($(UNAME_MACHINE),aarch64)
    GOARCH := arm64
else
    GOARCH := unknown
endif

```

上記のスクリプトでは、`GOARCH`に判定したアーキテクチャが設定されます。

### 3.3. 環境の引き継ぎ

取得した OS、アーキテクチャは、各 OS ごとの Makefile に架橋変数として引き継がれます。
そのため、ファイルの先頭に`export`を記述します。

### 3.4. 最終的なMakefileの作成

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

本記事を通じて、`make`コマンドと`Makefile`を使った OS の自動判定とそれに対応するビルド方法について解説しました。
これにより、さまざまな OS でのビルドを簡単に管理することが可能になります。
この方法を適用することで、開発者は手動での OS 切り替えから解放され、より効率的に作業を進めることができます。

それでは、Happy Hacking!

## 技術用語と注釈

- `uname`: UNIX系オペレーティングシステムのコマンドで、システム情報を出力する
- `GNU Make`: ビルドツールの 1つで、`Makefile`に記述されたルールにしたがってビルドを実行する
- Makefile: `make`コマンドが使用するファイルで、ビルドプロセスを記述する

## 参考資料

### Webサイト

- `GNU Make`: <https://www.gnu.org/software/make/>
