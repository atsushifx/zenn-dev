---
title: "開発環境: Racketのパッケージを管理する方法"
emoji: "🎾"
type: "tech"
topics: ["Windows", "開発環境", "Racket", "raco" ]
published: false
---

## はじめに

Racket のパッケージは、Racket のモジュールやライブラリをまとめたもので、Racket プログラミングを効率化し、開発を便利にします。
たとえば、plot パッケージはデータの可視化をサポートし、web-server パッケージはウェブアプリケーション開発を支援します。これらのパッケージを活用することで、Racket のプログラム開発がより簡単になります。
また、パッケージを組み合わせることで、自分のアプリケーションを簡単に構築できます。

Racket のパッケージは、Racket の開発支援ツールである"raco"を使って管理できます。

## 技術用語

この記事で出てくる重要な技術用語を掲載します:

- Racket: Scheme言語を拡張した汎用、関数型プログラミング言語
- `raco`: Racket の開発支援ツール。パッケージ管理のほかに、ビルド／コンパイル／テストなども行なう
- パッケージ: Racket で提供されるモジュールやライブラリのまとまり
- インストール: パッケージをシステムに追加すること
- アンインストール: パッケージをシステムから削除すること。

## 1. Racketでのパッケージ管理

Racket では、raco を使ってパッケージを管理します。
パッケージのインストール／アップデート／削除などには、`raco pkg \<subcommand\>`の型式でコマンドを実行します。

### 1.1. racoのパッケージ管理コマンド

raco pkg \<subcommand\>でパッケージを管理します。
raco pkg の主要なサブコマンドには以下のようなものがあります:

- install: パッケージのインストール
  - 使用例: `raco pkg install <package-name>`
- update: パッケージのアップデート
  - 使用例: `raco pkg update <package-name>`
- remove: パッケージの削除
  - 使用例: `raco pkg remove <package-name>`
- new: パッケージの新規作成
  - 使用例: `raco pkg new <package-name>`

そのほかのサブコマンドやオプションについては、[Racketのパッケージ管理](https://docs.racket-lang.org/pkg/)を参照してください。

## 2. パッケージを使ってみる

実際に、パッケージをインストールして使う方法を説明します。
この章では、具体例として Racket パッケージマネージャーのインストールを取り上げます。
これは、Racket のパッケージを一覧表示し、簡単にインストールできるツールです。
同様に、インストール済みの一覧からパッケージをアンインストールできます。

### 2.1. Racketパッケージマネージャーのインストール

パッケージのインストールは`<install>`サブコマンドを使います。
`<install>`コマンドで使える主なオプションは以下の通りです:

| オプション| 機能 | 備考 |
| --- | --- | --- |
| --auto | 依存パッケージのインストール | 指定したパッケージが依存するパッケージを自動的にインストールする |
| -i | パッケージを全ユーザー用にインストール | バイナリはRacketのインストールディレクトリに配置 |
| -u | パッケージを自分用にインストール | バイナリはパッケージディレクトリ (PLTUSERHOME/下のディレクトリ)に配置 |
| -dry-run | インストールは実行しません。どのようなコマンドが走るかを表示します。 |  |

Racket パッケージマネージャーをインストールしてみます。
`PowerShell`で以下のコマンドを実行します:

```powershell
raco pkg install --auto --scope installation gui-pkg-manager
```

結果、下記のメッセージが表示されて Racket パッケージマネージャーをインストールします:

```powershell
Resolving "gui-pkg-manager" via https://download.racket-lang.org/releases/8.9/catalog/
Resolving "gui-pkg-manager" via https://pkgs.racket-lang.org
 .
 .
 .

raco setup: --- installing collections ---                         [13:47:26]
raco setup: --- post-installing collections ---                    [13:47:26]
```

これで、インストールが完了しました。
次のコマンドで、Racket パッケージマネージャーが実行できます:

```powershell
 & 'Racket Package Manager.exe'
```

以下の画面が表示されれば、パッケージのインストールに成功しています。
![Package Manager](https://i.imgur.com/eOIqmH4.png)

### 2.2. パッケージの一覧

Racket パッケージマネージャーで、パッケージの一覧を表示します。
\[Available from Catalog\]タブを選択し、\[Update Package List\]をクリックします。
![パッケージ一覧](https://i.imgur.com/AAWBO2E.png)

### 2.3. パッケージの検索

[#2.2](#22-パッケージの一覧)のパッケージ一覧では、\[Filter\]にキーワードを入れて絞り込みができます。
たとえば"`2D`"というワードをいれると"`2D`"パッケージの関連パッケージや、"`SDL2`"といった"`2D`"というタグを含んだパッケージが表示されます。

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
パッケージの詳細については、[Racket Package Index](https://pkgs.racket-lang.org/)を見てください。

### 2.5. Racketパッケージマネージャーのアンインストール

`raco`を使えばインストールしたパッケージを安全にアンインストールできます。

パッケージのアンインストールは、\<remove\>サブコマンドで使います。
\<remove\>で使える主なオプションは、次の通りです:

| オプション | 機能 | 備考 |
| --- | --- | --- |
|  --auto | 未使用になったパッケージもアンインストール |  |
| -i | 全ユーザー用にインストールしたパッケージのアンインストール | |
| -u | 自分用にインストールしたパッケージのアンインストール |  |
| -dry-run | アンインストールは実行しません。どのようなコマンドが走るかを表示します。 |  |

それでは、例として、先ほどインストールした Racket パッケージマネージャーをアンインストールします。

次のコマンドを`PowerShell`で実行します。

```powershell
raco pkg remove --auto gui-pkg-manager
```

結果、下記のメッセージが表示されます:

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

メッセージの表示が終われば、Racket パッケージマネージャーのアンインストールは終了です。

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

- Racket 公式 Webサイト: <https://racket-lang.org/>
- Racket  公式ドキュメント: <https://docs.racket-lang.org/>
- Package Management in Racket: <https://docs.racket-lang.org/pkg/>
- Racket Packages Index:  <https://pkgs.racket-lang.org/>
