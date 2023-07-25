---
title: "WindowsでRacketのパッケージを管理する方法"
emoji: "🎾"
type: "tech"
topics: ["Windows", "開発環境", "Racket", "raco" ]
published: false
---

## はじめに

Racket では、さまざまなモジュールやライブラリをパッケージとして提供しています。
これらのパッケージは Racket プログラミングを効率化します。また、プログラミング環境を便利にする各種ツール、コードフォーマッタや言語サーバーもパッケージとして提供されています。

たとえば、以下のようなパッケージがあります:

- `plot`: データの可視化をサポートするグラフ描画ライブラリ
- `web-server`: ウェブアプリケーション開発を支援する Web サーバーライブラリ
- `math`: 数学関数やアルゴリズムを提供する数学ライブラリ

このようなパッケージを活用することで、Racket のプログラム開発がより簡単になります。
さらに、パッケージを組み合わせて自分のアプリケーションを構築できます。

Racket のパッケージは、Racket の開発ツール"raco"を使って管理できます。

## 技術用語

この記事で出てくる重要な技術用語を掲載します:

- Racket: Scheme言語を拡張した関数型プログラミング言語および処理系
- raco: Racket のパッケージ管理やビルド／コンパイル／テストなどを行なう、Racket の開発支援ツール
- パッケージ: Racket で提供されるモジュールやライブラリのまとまり

## 1. Racketでのパッケージ管理

Racket では、raco を使ってパッケージを管理します。
raco では、`raco pkg \<subcommand\>`とコマンドを実行することで、パッケージのインストール／アップデート／削除などができます。

### 1.1. racoのパッケージ管理コマンド

raco pkg \<subcommand\>でパッケージを管理します。
以下は、raco pkg の主なサブコマンドです:

- install: パッケージのインストール
- update: パッケージのアップデート
- remove: パッケージの削除
- new: パッケージの新規作成

そのほかのサブコマンドやオプションについては、[Package Management in Racket](https://docs.racket-lang.org/pkg/)を参照してください。

## 2. パッケージを使ってみる

実際にパッケージをインストールして、使ってみましょう。
この章では、GUI で Racket のパッケージを一覧、表示し、簡単にインストールができるツール、GUI パッケージマネージャーをインストールします。

### 2.1. GUIパッケージマネージャーのインストール

パッケージのインストールは`\<install\>`サブコマンドを使います。
`\<install\>`で使える主なプションは、次の通りです:

| オプション| 機能 | 備考 |
| --- | --- | --- |
| --auto | 依存パッケージのインストール |  |
| -i | パッケージを全ユーザー用にインストール | バイナリはRacketのインストールディレクトリに配置 |
| -u | パッケージを自分用にインストール | バイナリはパッケージディレクトリ (PLTUSERHOME/下のディレクトリ)に配置 |
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

### 2.2. パッケージの一覧

GUI パッケージマネージャーでパッケージの一覧を表示します。
\Available from Catalog]タブを選択し、\[Update Package List\]をクリックします。

以下の画面のように、パッケージの一覧が表示されます:
![パッケージ一覧](https://i.imgur.com/AAWBO2E.png)

### 2.3. パッケージの検索

[#2.2](#22-パッケージの一覧)のパッケージ一覧では、\[Filter\]にキーワードを入れて絞り込みができます。
たとえば、”2D”といれると"2D"関連パッケージや、"SDL2"といったパッケージが表示されます。

### 2.4. パッケージインデックス

Racket のパッケージは、[Package Index](https://pkgs.racket-lang.org/)で提供されています。
キーワード、タグによる検索もできます。
[Package Index](https://i.imgur.com/r9jlfkA.png)

以下は主なパッケージの一覧です:

| パッケージ | 概要 | 備考 |
| --- | --- | --- |
| bzip2 | bzip2の圧縮／解凍ライブラリ | |
| dotenv | .env設定ライブラリ | .envファイルを読み込んで環境変数を設定するライブラリ |
| fmt | Racket用コードフォーマッタ | Racketのソースコードを整形するツール |
| gui-pkg-manager | GUIのRacketパッケージマネージャー | RacketのパッケージをGUIで管理するツール ||

このほかにも、さまざまなパッケージがあります。
おのおののパッケージについては、[Racket Package Index](https://pkgs.racket-lang.org/)を見てください。

### 2.5. GUIパッケージマネージャーのアンインストール

`raco`を使えばインストールしたパッケージを安全にアンインストールできます。

パッケージのアンインストールは、\<remove|>サブコマンドで使います。
\<remove\>で使える主なオプションは、次の通りです:

| オプション | 機能 | 備考 |
| --- | --- | --- |
|  --auto | 未使用になったパッケージもアンインストール |  |
| -i | 全ユーザー用にインストールしたパッケージのアンインストール | |
| -u | 自分用にインストールしたパッケージのアンインストール |  |
| -dry-run | アンインストールは実行しません。どのようなコマンドが走るかを表示します。 |  |

それでは、例として、先ほどインストールした GUI パッケージマネージャーをアンインストールします。

次のコマンドを`PowerShell`で実行します。

```powershell
raco pkg remove --auto gui-pkg-manager
```

下記のようなメッセージを出力して、パッケージをアンインストールします:

```powershell
Inferred package scope: installation
Removing gui-pkg-manager
Moving gui-pkg-manager to trash: C:\lang\racket\share\pkgs\.trash\1690268749-0-gui-pkg-manager
 .
 .
 .
 
raco setup: --- installing collections ---                         [16:06:04]
raco setup: --- post-installing collections ---                    [16:06:04]
```

以上で、GUI パッケージマネージャーのアンインストールは終了です。

## おわりに

Racket では開発ツール"raco"を使ってパッケージのインストール／アンインストールができます。
また、Racket の公式パッケージサイトについても紹介しました。
有用なパッケージを使いこなすことで、Racket での効率的なプログラミングができるでしょう。

この記事では説明しませんでしたが、`raco`を使えば:

- 自分で新たにパッケージをつくる
- 作成したパッケージを公式パッケージサイトに登録する
- パッケージのマイグレーションを行なう

といった、さらに効率的なパッケージ管理も行えます。

参考資料などを読みながら、Racket プログラミングの世界を広げていきましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- Racket 公式の Webサイト: <https:://racket-lang.org/\>
- Package Management in Racket: <https://docs.racket-lang.org/pkg/>
- Racket Packages Index:  <https://pkgs.racket-lang.org/>
