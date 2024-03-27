---
title: "Racket: Racketの環境設定ファイル／ディレクトリまとめ"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "環境構築", "開発環境", "関数型プログラミング", ]
published: false
---

## はじめに

`Racket`は、そのシンプルな構文と強力なマクロシステムで知られています。そして、教育分野や研究目的で幅広く利用されています。
Windows や WSL を含む多様な環境においても簡単にインストールでき、関数型プログラミングの入門に最適です。

本記事では、`Racket`の環境設定に使用する設定ファイルとディレクトリについて解説します。これらの設定を GitHub の`dotfiles`リポジトリで管理することで、`Racket`開発環境の再構築が簡単になります。

## 1. 環境設定ファイル／ディレクトリ一覧

以下に、`Racket`の設定ファイルとディレクトリを一覧形式で紹介します。

| 種別 | 設定ファイル | 設定ディレクトリ (シンボル名) | 環境変数 | 説明 | 備考 |
|---|---|---|---|---|---|
| ホームディレクトリ | | `home-dir` | `PLTUSERHOME` | 初期設定ファイルなどを保存する |  |
| ユーザー設定ファイル | `racket-prefs.rktd` | `pref-dir` |  | `REPL`の入力履歴などを保存 | ホームディレクトリ内に配置 |
| 初期設定ファイル | `racketrc.rktl` | `init-dir` |   | `Racket`初期設定ファイル | ホームディレクトリと同一 |
| `config`ファイル | `config.rktd` | `config-dir` | `PLTCONFIGDIR` | `Racket`,`raco`用設定 | |
| アドオンディレクトリ |  | `addon-dir` | `PLTADDONDIR` | `Racket`パッケージ、拡張機能用を保存するディレクトリ | |
| キャッシュディレクトリ | | `cache-dir` |   | キャッシュデータを保存するディレクトリ |  |

**重要**:

- 環境変数が示されているディレクトリは、環境変数を使用してディレクトリをカスタマイズできます。
- ディレクトリの具体的な値は、次のコマンドで確認できます。

  ```powershell
  racket -e "(find-system-path 'home-dir)"
  ```

  `home-dir`の部分を表内のシンボルと入れ替えることで、必要なディレクトリを取得できます。

## 2. 環境設定ファイル／ディレクトリの詳細

表に示した設定ファイルやディレクトリについて、詳細を説明します。

### 2.1 ホームディレクトリ

- 環境変数: `PLTUSERHOME`
- デフォルト:
  - `UNIX/Linux`: `$HOME`
  - `Windows`: `$USERPROFILE`
  - `macOS`: `$HOME`

初期設定ファイルなど、`Racket`に関連する重要なファイルを保存するディレクトリ。
このディレクトリを適切に管理することで、`Racket`のカスタマイズとポータビリティが向上します。

### 2.2 設定ファイル

`Racket`の動作を設定する各ファイルの詳細を説明します。

#### ユーザー設定ファイル

- ファイル:
  - `UNIX/Linux`: `racket-prefs.rktd`
  - `Windows`: `racket-prefs.rktd`
  - `macOS`: `org.racket-lang.prefs.rktd`
- 環境変数: `PLTUSERHOME`
- デフォルトディレクトリ:
  - `UNIX/Linux`: `$XDG_CONFIG_HOME/racket`
  - `Windows`: `$AppData`
  - `macOS`: `Library/Preferences`

ユーザー設定を保存する設定ファイル。
また、`Racket`の`REPL` (ユーザーからの入力を受け、評価し、結果を出力する対話型のインターフェイス)の入力履歴も保存します。
これにより、`Racket`使用時の効率化を実現します。

**注意**:
ロックファイルも作成されます。

#### 初期設定ファイル

- ファイル: `racketrc.rktl`
- デフォルトディレクトリ:
  - `UNIX/Linux`: `$XDG_CONFIG_HOME/racket`
  - `Windows`: `$USERPROFILE`
  - `macOS`: `Library/Racket`

`Racket`起動時に、自動的に読み込まれる初期設定ファイル。
プログラムや`REPL`を実行させる前に、あらかじめ実行しておきたい処理を`Racket`言語で記述します。

次のような`racketrc.rktl`では、起動時にウェルカムメッセージを出力します。

```racket: racketrc.rktl
"Welcome. This initialize file for Racket."

```

**注意**:
`UNIX/Linux`では、旧来の`$HOME/.racketrc`も使用できます。

#### `config`ファイル

- ファイル: `config.rktd`
- 環境変数: `PLTCONFIGDIR`
- デフォルトディレクトリ:
  - `UNIX/Linux`: `/etc/racket`
  - `Windows`: `etc`
    **注意**:
    デフォルトディレクトリはインストールディレクトリ下の`etc`となる。

ライブラリやパッケージなどの検索パスを設定するファイル。
そのほか、パッケージインストール時のデフォルトスコープも設定できます。
これにより、`Racket`システムスコープかユーザースコープかを自動的に選んでインストールできます。

### 2.3 設定ディレクトリ

- ディレクトリ: `addon-dir`
- 環境変数: `PLTADDONDIR`
- デフォルト:
  - `UNIX/Linux`: `$XDG_DATA_HOME/racket`
  - `Windows`: `pref-dir`
  - `macOS`: `Library/Racket`

パッケージ、拡張機能を保存するディレクトリ。
パッケージマネージャー`raco`を使用してパッケージやライブラリ、拡張機能などをインストールしたときに、それらを保存するディレクトリです。
環境変数`PLTADDONDIR`によって、保存するディレクトリを設定できます。

**注意**:
UNIX/Linux では、 以前は`.racket`ディレクトリも利用可能でした。

#### `cache-dir`

- ディレクトリ: `cache-dir`
- 環境変数:
- デフォルト:
  - `UNIX/Linux`: `$XDG_CACHE_HOME/racket`
  - `Windows`: `addon-dir`
  - `macOS`: `Library/Caches/Racket`

`Racket`が生成するキャッシュを保存するディレクトリ。
`Racket`言語がキャッシュを利用する場合に、生成したキャッシュをこのディレクトリ下に保存します。

**注意**:
UNIX/Linux では旧来の`.racket`も指定できます。

## おわりに

`Racket`の設定に使用するファイル、ディレクトリ、環境変数についてまとめました。
これらを自分の PC用にカスタマイズし、GitHub の`dotfiles`リポジトリで管理することにより、`Racket`開発環境の再構築が簡単になります。

次は、`Racket`でのプログラミングを通して関数型プログラミングへの理解を深めましょう。
関数型プログラミングの考え方を身につけることで、効率的かつ安全なプログラミングが可能になります。
関数型プログラミングの学習を通して、自身のプログラミングをスキルアップしましょう。

最後に、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語をリストアップします:

- `Racket`:
  シンプルな構文と強力なマクロシステムが特徴の関数型プログラミング言語。 教育や研究に広く用いられる

- `raco`:
  `Racket`用コマンドラインツールおよびパッケージマネージャー。`Racket`の開発環境やプロジェクト管理を容易にする

- 関数型プログラミング:
  データの不変性や関数の第一級オブジェクトとしての扱いに重点を置くプログラミングパラダイム。副作用を最小限に抑えることで、より安全で再利用しやすいコードを実現する

- `REPL` (`Read-Eval-Print-Loop`):
  コマンドや式を評価してその結果を即座に表示する対話型インターフェイス。`Racket`では`REPL`を利用してプログラムのテストやデバッグ、プロトタイピングができる

- `マクロシステム`:
  `Racket`言語の構文を拡張し、新たな構文構造を定義することを可能にする機能。これにより、言語の表現力が大幅に向上し、プログラマの生産性が高まる

- `XDG Base Directory`:
  UNIX/Linux において、ユーザーの設定ファイル、データファイル、キャッシュファイルなどを整理し、管理するための標準仕様。この仕様に従うことで、ファイルシステムが整理され、ユーザーデータのバックアップや移行が容易になる。

## 参考資料

### Webサイト

- [`FileSystem`](https://docs.racket-lang.org/reference/Filesystem.html):
  `Racket`言語におけるファイルシステムの操作に関する公式ドキュメント。
  `Locating Paths`セクションでは、今回説明した各種ファイル／ディレクトリを利用するかを解説している。

- [`Installation Configuration and Search Paths`](https://docs.racket-lang.org/raco/config-file.html)
  `Racket`とそのパッケージマネージャー`raco`の設定ファイルと検索パスに関する公式ドキュメント。
  インストール時の設定や、`raco`がどのようにしてパッケージや設定ファイルを検索するかの説明が含まれています。

- [Racket Documentation](https://docs.racket-lang.org/):
  `Racket`公式ドキュメント

- [`Racket` - `Discord`](https://discord.com/invite/racket-571040468092321801)
  `Discord`の`Racket`チャンネル
