---
title: "Racketのパッケージ管理': raco'を使って開発環境を整える方法"
emoji: "🎾"
type: "tech"
topics: ["Windows", "開発環境", "Racket", "パッケージマネージャー" ]
published: false
---

## はじめに

Racket では、さまざまなモジュールやライブラリをパッケージとして提供しています。
また、パッケージの中にはコードフォーマッタのようなプログラミング時に役に立つツールもあります。

Racket のパッケージは、raco を使って管理できます。

### racoとは

raco は、Racket でのプログラミングを助ける開発ツールです。
ここで説明するパッケージ管理のほかに、Racketプログラムのコンパイルやビルド、テストなどを行えます。

## 1. Racketでのパッケージ管理

Racket では、raco を使ってパッケージを管理します。
raco では、`raco pkg \<subcommand\>`とコマンドを実行することで、パッケージを管理できます。

### 1.1. racoのパッケージ管理コマンド

raco pkg \<subcommand\>でパッケージを管理します。
raco pkg の主要なサブコマンドと解説を下記の表に掲載します。

| subcommand | 説明 | 備考 |
 --- | --- | --- |
| install | パッケージのインストール |  指定した名前のパッケージをインストールします。ディレクトリなどを指定して、ソースからパッケージをインストールできます |
| update | 指定したパッケージのアップデート |  |
| remove | パッケージの削除 | 指定したインストール済みのパッケージをアンインストールします |
| new | パッケージの新規作成 | パッケージ名のディレクトリを作成し、パッケージ作成用に初期設定します |

そのほか、Racket のパッケージについては[Racket Packages Index](https://docs.racket-lang.org/pkg/index.html)を参照してください。

## 2. パッケージを使ってみる

Racket のパッケージを実際に活用してみましょう。

### 2.1. パッケージの検索

Racket のパッケージは、[Racket Package Index](https://pkgs.racket-lang.org/)で配布されています。
キーワードやタグによる検索もできるので、使ってみるとよいでしょう。
[Package Index](https://i.imgur.com/r9jlfkA.png)

主なパッケージを以下に載せておきます:

| パッケージ | 概要 | 備考 |
| --- | --- | --- |
| bzip2 | bzip2の圧縮／解凍ライブラリ | |
| dotenv | .env設定ライブラリ | .envファイルを読み込んで環境変数を設定するライブラリ |
| fmt | Racket用コードフォーマッタ | Racketのソースコードを整形するツール |
| gui-pkg-manager | GUIのRacketパッケージマネージャー | RacketのパッケージをGUIで管理するツール ||

このほかにも、さまざまなパッケージがあります。
おのおののパッケージについては、[Racket Package Index](https://pkgs.racket-lang.org/)を見てください。

### 2.2. パッケージの一覧

インストール済みのパッケージは、\<show\>サブコマンドで見ることができます。
`PowerShell`で以下のコマンドを実行します:

```powershell
raco pkg show --all
```

以下のような一覧が表示されます:

```powershell
Installation-wide:
 Package[*=auto]               Checksum         Source
 2d*                           806166194d8d...  catalog 2d
 2d-doc*                       e3cbec0044d6...  catalog 2d-doc
 2d-lib*                       71e7b3d9728c...  catalog 2d-lib
 algol60*                      56ac90f0d228...  catalog algol60
 at-exp-lib*                   6811a63ba57b...  catalog...p-lib
 base*                         f318e23ec3
 ```

### 2.3. パッケージのインストール

パッケージのインストールは\<install\>サブコマンドを使います。
\<install\>で使える主なプションは、次の通りです:

| オプション| 機能 | 備考 |
| --- | --- | --- |
|  --auto | 依存パッケージのインストール |  |
| --scope install | パッケージを全ユーザー用にインストール | バイナリはRacketのインストールディレクトリに配置 |
| --scope user | パッケージを自分用にインストール | バイナリはパッケージディレクトリ (PLTUSERHOME/下)に配置 |
| -dry-run | インストールは実行しません。どのようなコマンドが走るかを表示します。 |  |

実際にパッケージをインストールしてみます。
`PowerShell`で以下のコマンドを実行します:

```powershell
raco pkg install --auto --scope installation gui-pkg-manager
```

下記のメッセージが表示されて、パッケージをインストールします:

```powershell
Resolving "gui-pkg-manager" via https://download.racket-lang.org/releases/8.9/catalog/
Resolving "gui-pkg-manager" via https://pkgs.racket-lang.org
 .
 .
 .

raco setup: --- installing collections ---                         [13:47:26]
raco setup: --- post-installing collections ---                    [13:47:26]
```

下記のコマンドでパッケージマネージャーが実行できます:

```powershell
 & 'Racket Package Manager.exe'
```

以下の画面が表示されれば、パッケージのインストールに成功しています。
![Package Manager](https://i.imgur.com/eOIqmH4.png)

### 2.4. パッケージのアンインストール

パッケージのアンインストールは、\<remove|>サブコマンドで使います。
\<remove>で使える主なオプションは、次の通りです:

| オプション | 機能 | 備考 |
| --- | --- | --- |
|  --auto | 未使用になったパッケージもアンインストール |  |
| --scope install | 全ユーザー用にインストールしたパッケージのアンインストール | |
| --scope user | 自分用にインストールしたパッケージのアンインストール |  |
| -dry-run | アンインストールは実行しません。どのようなコマンドが走るかを表示します。 |  |

## おわりに

Racket では開発ツール"raco"を使ってパッケージのインストール／アンインストールができます。
また、Racket の公式パッケージサイトについても紹介しました。
有用なパッケージを使いこなすことで、Racket での効率的なプログラミングができるでしょう。

この記事では説明しませんでしたが、`raco`を使えば:

- 自分で新たにパッケージをつくる
- 作成したパッケージを公式パッケージサイトに登録する
- パッケージのマイグレーションを行なう

といった、さらに効果的なパッケージ管理も行えます。

参考資料などを読みながら、Racket プログラミングの世界を広げていきましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- Racket 公式の Webサイト: <https:://racket-lang.org/\>
- Racket Packages Index:  <https://pkgs.racket-lang.org/>
