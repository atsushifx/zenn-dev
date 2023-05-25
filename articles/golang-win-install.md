---
title: "Windows: Windows環境でGo言語の開発環境を設定する方法"
emoji: "👟"
type: "tech"
Topics: [ "go", "インストール", "開発環境", "環境構築", "XDG" ]
published: false
---

## はじめに

この記事では、Windows 上に Go 言語の開発環境を設定する方法を説明します。
Go 言語のインストール自体は簡単ですが、デフォルトではインストール先が`C:\Program Files\Go`,GOPATH が`C:\Users\<ユーザー名>\.go`となります。

この場合、ディレクトリが空白を含んでいる。ホームディレクトリ直下に設定ファイルを置くといった問題があり、使い勝手がよくありません。

このため、今回は Go 言語を`C:\lang\go`にインストールし、`GOPATH`を`XDG Base Directory`に準じて`~/.local/share/go`に設定します。

## インストール環境

### インストール先`c:\lang`

プログラミング言語は基本的に`c:\lang\`下にインストールします。今回は Go 言語をインストールするので、`c:\lang\go`となります。

`C:\lang`は、Windows の一般的なインストール先である`C:\Program Files`とは異なり、ディレクトリ名に空白が含まれていません。これにより、一部のツールが空白を正しく扱えない問題を回避できます。

### XDG Base Directory

`XDG Base Directory は、ユーザーデータや設定ファイルを保存する統一的な場所を提供するための標準規格です。主に Unix/Linux 環境で利用されますが、Windows 環境でも活用できます。

Windows 環境で XDG Base Directory を利用するためには、事前に XDG の対応する環境変数を設定し、ディレクトリを準備する必要があります。

## Goのインストール

### wingetによるgoのインストール

`winget` (Windows パッケージマネージャー)を、コマンドラインから Windows の各種アプリをインストールするツールです。
Go 言語も`winget`に対応しているので、インストーラーをダウンロードして実行しなくても、コマンドラインから Go 言語をインストールできます。、

`winget`にはインストール先を指定する`--location`オプションがありますが、Go 言語インストーラーはこれを無視します。
そのため、`INSTALLDIR'という変数を利用します。

次のコマンドで、Go 言語をインストールします。

``` powershell
winget install GoLang.Go --override 'INSTALLDIR=c:\lang\go'

```

### 環境変数の設定

Go 言語を使用するためには、一部の環境変数を設定する必要があります。設定する環境変数とその値は以下の通りです。

| 環境変数 | 設定値 | 説明 |
| --- | --- | --- |
| GOPATH | `~/.local/share/go` | Go 言語のワークスペースのパスです。 XDG_DATA_HOME 下に設定します。|
| PATH | `...;c:\lang\go\bin;%GOPATH%\bin` | Go 言語の実行先と、作成したバイナリの保存先を追加して、コマンドライから実行できるようにします。 |

<!-- markdownlint-disable MD036 -->
**注**
<!-- markdownlint-enable MD036 -->
- GOPATH の設定で環境変数を参照していると、Path が go 実行ファイルをみつけられなくなる
- 設定を Windows に反映させるため、再起動をする必要がある

#### 環境変数の設定方法

環境変数の設定は、[システムのプロパティ]ダイアログから行えます。
以下に、Windows で環境変数を設定する手順を示します。

1. `Windows`+`I`キーを押して[設定]画面を開く

2. [システム > バージョン情報]を選択し、[システムの詳細設定]をクリック

3. "システムのプロパティ"ダイアログが表示されるので、[環境変数]をクリック

4. "環境変数"ダイアログが表示されるので、編集したい環境変数を選択し[編集]をクリック

5. 必要な環境変数を編集し、[OK]をクリック

6. 各ダイアログの[OK]をクリックしてダイアログを閉じる

以上で、環境変数の設定は終了です。
具体的な設定内容は、[環境変数の設定](#環境変数の設定)の表を参照してください。

### goの動作確認

環境変数が正しく設定されていれば、Go 言語は正常に動作します。
`go version`を実行して、Go 言語が正常に動作することを確認します。

``` powershell
go version
```

以下のようにバージョンが表示されれば、Go 言語は正常に動作しています。

```  powershell: Terminal
go version go1.20.4 windows/amd64

>

```

## はじめてのgoプログラミング

### Goで"Hello, World!!"

次の手順で、Go で"Hello, World!!"と出力するプログラムを作成します。

1. Go のモジュールディレクトリを作成する

   ``` powershell
   mkdir hello & cd hello
   
   ```

2. Go のモジュールを初期化する

   ``` powershell
   go mod init hello

   ```

3. `hello.go`ファイルを作成し、以下のようにコードを記述する

   ``` go:hello.go
   package main
   
   import "fmt"
   
   func main() {
     fmt.Println("Hello, World!!");
   }
   ```

4. `go run`コマンドで、goプログラムを実行する

   ``` powershell
   go run hello.go
   
   ```

5. "Hello, World!!"とメッセージが表示される

上記のようにメッセージが表示されれば、Go 言語でのプログラム作成 h は成功しています。

## さいごに

以上が、Windows 上に Go 言語の開発環境をセットアップする方法です。
これで、Go 言語を使ってプログラミングを始めることができます。

それでは、Happy Hacking!

## 技術用語と注釈

- GOPATH：Go 言語のワークスペースのディレクトリ。Go 言語のプロジェクトが格納される場所
- winget：Windows 用のパッケージマネージャー。 Windows のコマンドラインからアプリをインストールできる

## 参考資料

### Webサイト

- Go 公式ウェブサイト: <https://go.dev/>
- XDG Base Directory: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
