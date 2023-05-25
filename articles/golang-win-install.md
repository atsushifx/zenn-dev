---
title: "WindowsでGo言語をインストールして開発環境を構築する方法"
emoji: "👟"
type: "tech"
Topics: [ "go", "インストール", "開発環境", "環境構築", "XDG" ]
published: false
---

## はじめに

この記事では、Windows 上に Go 言語の開発環境を導入する方法について説明します。
Go 言語のインストール自体は簡単です。
が、デフォルトではインストール先が`C:\Program Files\Go`,GOPATH が`C:\Users\<ユーザー名>\.go`となり、使い勝手がよくありません。

Go 言語を`C:\lang\go`にインストールし、`GOPATH`を`XDG Base Directory`にあわせて`~/.local/share/go`に設定します。
参照先のディレクトリに空白や全角文字を含まないため、問題が起きにくくなるはずです。

## インストール環境

### インストール先`c:\lang`

とくに問題がない限りプログラミング言語を`c:\lang\`下にインストールしています。
今回は Go 言語なので、`c:\lang\go`となります。

`C:\lang`は、Windows の一般的なインストール先である`Programming Files`と異なり空白がありません。
インストール後に問題が起きにくくなっています。

### XDG Base Directory

`XDG Base Directory`は、Unix/Linux 環境で採用されている設定ファイルの保存先を決める仕様です。
Windows 環境でも XDG の環境変数を設定することで、各種設定ファイルを整理して保存できます。

## Goのインストール

### wingetによるgoのインストール

`winget`にはインストール先を指定する`--location`オプションがありますが、Go 言語インストーラーはこれを無視します。
その代わり変数`INSTALLDIR'が使えるので、これを利用します。

次のコマンドで、Go 言語をインストールします。

``` powershell
winget install GoLang.Go --override 'INSTALLDIR=c:\lang\go'

```

### 環境変数の設定

Go 言語を使うために、環境変数を設定します。
設定する環境変数は、以下の表の通りとなります。

| 環境変数 | 設定値 | 適用 | 備考 |
| --- | --- | --- | --- |
| GOPATH | `~/.local/share/go` | Go workspaceのパス | `XDG_DATA_HOME`下に設定する。|
| PATH | `...;c:\lang\go\bin;%GOPATH%\bin` | Go実行ファイル保存先 | S |

<!-- markdownlint-disable MD036 -->
**注**
<!-- markdownlint-enable MD036 -->
- GOPATH の設定で環境変数を参照していると、Path が go 実行ファイルをみつけられなくなる
- 設定を Windows に反映させるため、再起動をする必要がある

#### 環境変数の設定方法

環境変数の設定は、[システムのプロパティオ]ダイアログから行えます。

1. `Windows`+`I`キーを押し、[設定]画面を開きます。

2. [システム > バージョン情報]を選び、[システムの詳細設定]をクリックします。

3. [システムのプロパティ]ダイアログが開くので、[環境変数]をクリックします。

4. [環境変数]ダイアログが開きます。編集したい環境変数を選び[編集]をクリックします。

5. 環境変数を編集し、[OK]をクリックします。

6. 各ダイアログの[OK]をクリックし、ダイアログを閉じます。

以上で、環境変数の設定は終了です。
環境変数にどんな値を設定するかは、[環境変数の設定](#環境変数の設定)の表を参照してください。

### goの動作確認

環境変数が正しく設定されていれば、Go が正常に動作するはずです。
`go version`を実行し、Go が正常に動作するか確認します。

コマンドラインで、次のコマンドを実行します。

``` powershell
go version
```

以下のようにバージョンが表示されれば、go は正常に動作しています。

```  powershell: Terminal
go version go1.20.4 windows/amd64

>

```

## はじめてのgoプログラミング

### Goで"Hello, World!!"

次の手順で、Go で"Hello, World!!"をプログラミングします。

1. Goモジュールディレクトリを作成する

   ``` powershell
   mkdir hello & cd hello
   
   ```

2. Goモジュールを初期化する

   ``` powershell
   go mod init hello

   ```

3. hello.go ファイルを作成し、以下のようにコードを各

   ``` go:hello.go
   package main
   
   import "fmt"
   
   func main() {
     fmt.Println("Hello, World!!");
   }
   ```

4. `go run`コマンドで、goプログラムを実行する

   ``` powershell
   go run hello
   
   ```

5. 以下のように、メッセージが表示される

   ``` powershell
   Hello, World!!
   >

   ```

以上のように"Hello, World!!"のメッセージが表示されれば、 Go でプログラミングできています。

## さいごに

ここまでで、Windows 上に Go 言語の開発環境を構築する方法を説明しました。
Go 言語を使ってプログラミングを始める準備が整いましたので、これからさらに学びを深めていきましょう。

それでは、Happy Hacking!

## 技術用語と注釈

- GOPATH：Go 言語のワークスペースのディレクトリ。Go 言語のプロジェクトが格納される場所
- winget：Windows 用のパッケージマネージャー。 Windows のコマンドラインからアプリをインストールできる

## 参考資料

### Webサイト

- Go Programming Language: <https://go.dev/>
- XDG Base Directory: <https://wiki.archlinux.jp/index.php/XDG_Base_Directory>
