---
title: "Racket: Racketの環境設定ファイル／ディレクトリまとめ"
emoji: "🎾"
type: "tech"
topics: [ "Racket", "環境構築", "開発環境", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、`XDG Base Directory`仕様に準拠した`Racket`[^1]言語の環境設定について説明します。
とくに、環境設定のために使用する環境設定ファイルと環境変数についてまとめました。

環境変数などを設定することで、Windows環境でも`XDG Base Directory`[^2]に準拠した形式で設定ファイルを配置できます。
設定ファイルを`$USERPROFILE`直下ではなく、環境設定用のディレクトリ下に配置するため、`Racket`の設定ファイルを`dotfiles`リポジトリ[^3]で管理できるようになります。

[^1]: `Racket`: 教育、研究用の広く用いられている関数型プログラミング言語
[^2]: `XDG Base Directory`: UNIX/Linux環境下で設定ファイル、データファイルを配置するための仕様
[^3]: `dotfiles`リポジトリ]: 各種ツール、ユーティリティの設定ファイルを管理するための GitHub リポジトリ

## 環境設定ファイル／ディレクトリ一覧

| 設定ファイル | ディレクトリ (シンボル) | 環境変数 | 説明 | 備考 |
|---|---|---|---|---|
| | `home-dir` | `PLTUSERHOME` | `Racket`ホームディレクトリ |  |
|`racket-prefs.rktd` | `pref-dir` |  | `Racket REPL`のヒストリーなどの保存 | `Racket`ホームディレクトリと同一 |
| `racketrc.rktl` | `init-dir` |   | `Racket`初期設定ファイル | `Racket`ホームディレクトリと同一 |
| `config.rktd` | `config-dir` | `PLTCONFIGDIR` | ディレクトリ設定一覧 | |
| | `addon-dir` | `PLTADDONDIR` | `Racket`パッケージ拡張機能用ディレクトリ | |
| | `cache-dir` |   | パッケージキャッシュ保存用 | `config.rktd`で設定可能 |

## 環境設定

### ホームディレクトリ

- 環境変数: `PLTUSERHOME`
- デフォルトデイレクトリ:
  `UNIX/Linux`: `$HOME`
  `Windows`: `$USERPROFILE`
  `macOS`: `$HOME`

ユーザーのホームディレクトリを設定します。
初期設定ファイルや`Preference`ファイルは、このディレクトリに保存されます。

### 設定ファイル

#### `racket-prefs.rktd`

- ファイル:
  `UNIX/Linux`: `racket-prefs.rktd`
  `Windows`: `racket-prefs.rktd`
  `macOS`: `org.racket-lang.prefs.rktd`
- 環境変数: `PLTUSERHOME`
- デフォルト:
  `UNIX/Linux`: `$XDG_CONFIG_HOME/racket`
  `Windows`: `$AppData`
  `macOS`: `Library/Preferences`

`Racket`でのユーザーの設定を保存します。主に、`Racket REPL`での入力履歴を保存しています。

**注意**:
`Racket REPL`のセッションごとに状態を保存するためロックファイルも作成されます。

#### `racketrc.rktl`

- ファイル: `racketrc.rktl`
- 環境変数: `PLTUSERHOME`
- デフォルト:
  `UNIX/Linux`: `$XDG_CONFIG_HOME/racket`
  `Windows`: `$USERPROFILE`
  `macOS`: `Library/Racket`

`Racket`起動時に読み込まれ、初期設定をします。
設定は、｀Racket`で書かれます。

**注意**:
旧来の`UNIX/Linux`用に`$HOME/.racketrc`が使用できます。

#### `config.rktd`

- ファイル: `config.rktd`
- 環境変数: `PLTCONFIGDIR`
- デフォルト:
  `UNIX/Linux`: `/etc/racket`
  `Windows`: `C:/lanng/racket/etc`
  **注意**:
  `Racket`を`C:/lang/racket`にインストールしたため、`c:/lang/racket/etc`になる

`config.rktd`は、`Racket`や`Raco`パッケージマネージャーが実行時に参照する URL やディレクトリを設定します。
具体的には、パッケージカタログの URL、ダウンロードしたパッケージ用のキャッシュディレクトリなどです。

### 設定ディレクトリ

- ディレクトリ: `addon-dir`
- 環境変数: `PLTADDONDIR`
- デフォルト:
  `UNIX/Linux`: `$XDG_DATA_HOME/racket`
  `Windows`: `pref-dir`     # デフォルトでは、`pref-dir`の値となります
  `macOS`: `Library/Racket`

`Racket`パッケージや拡張機能を保存するディレクトリです。

**注意**:
UNIX/Linux では旧来の`.racket`も指定できます。

#### `cache-dir`

- ディレクトリ: `cache-dir`
- 環境変数: `--`
- デフォルト:
  `UNIX/Linux`: `$XDG_CACHE_HOME/racket`
  `Windows`: `addon-dir`     # デフォルトでは、`addon-dir`の値となります
  `macOS`: `Library/Caches/Racket`

Racket が作成するキャッシュを保存するディレクトリです。

**注意**:
UNIX/Linux では旧来の`.racket`も指定できます。

## おわりに

ここまでで、`Racket`が使用する環境変数や環境設定ファイルをまとめました。
これらを設定することで、Windows、WSL での設定を統一的な形で設定できます。
これにより、設定ファイルを`dotfiles`を通して一元管理でき、ポータビリティに優れた環境設定ができます。

この記事を活用して、`Racket`の環境を迅速に構築し、関数型プログラミングの学習をすすめましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`FileSystem`](https://docs.racket-lang.org/reference/Filesystem.html):
  `Racket`が使用する設定ファイル／ディレクトリの説明

- [`Installation Configuration and Search Paths`](https://docs.racket-lang.org/raco/config-file.html)
  `raco`が使用する設定ファイルについての説明
