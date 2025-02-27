---
title: "XDG環境変数と import 機能で実現する cSpell 設定・辞書の共通管理ガイド"
emoji: "🔠"
type: "tech"
topics: [ "vscode", "CSpell", "extension", "開発環境", "XDG" ]
published: false
---

## はじめに

atsushifx です。

この記事では、`VSCode`の`CSpell`拡張機能における設定とユーザー辞書の共通管理方法を解説します。
`CSpell`の `cSpell.import` 機能を利用すると、外部ファイルを読み込めます。
環境変数 `XDG_CONFIG_HOME` と組み合わせることで、複数のプロジェクトやコンピューター間で一貫した設定を維持できます。

この方法を実践することで、以下のメリットが得られます:

- コード内の英単語のスペルチェック精度向上
- チーム内での辞書と設定の統一
- プロジェクト間での設定移行作業の軽減
- `Git`による設定の一元管理と履歴追跡

## 用語集

この記事で使用する技術用語です。

- `VSCode` (`Visual Studio Code`):
  Microsoft が提供する統合開発環境

- `CSpell` (`Code Spell Checker`):
  コード内の英単語のスペルチェックを行なう `VSCode`拡張機能

- `cSpell.import`:
  外部の設定ファイルを読み込む `CSpell`の機能

- `XDG_CONFIG_HOME`:
  `XDG Base Directory`仕様に基づく、ユーザー設定ファイルの標準ディレクトリを指定する環境変数

- `dotfiles`:
  設定ファイルを集約し、複数の環境で共有・管理するためのリポジトリ

- `user-dic`:
  プログラム内で使用する関数名や変数名などの英単語を登録するユーザー辞書

- `project-dic`:
  特定のプロジェクトでのみ使用する専門用語を登録するプロジェクト辞書

## 1. 前提条件

この記事は、以下の設定を前提としています。

- `XDG Base Directory`設定:
  `XDG_CONFIG_HOME` が設定されており、ユーザーの設定ファイルを格納している
- `dotfiles` リポジトリ:
  `dotfiles` リポジトリが存在し、環境変数 `XDG_CONFIG_HOME` を利用して設定ファイルを一元管理している
- `CSpell` 拡張:
  `VSCode` には、`CSpell` 拡張がインストールされている

## 2. `VSCode`の設定

`VSCode`の設定ファイル (`settings.json`) を修正して、環境変数 `XDG_CONFIG_HOME` を参照する形で `CSpell`の共通設定ファイルを読み込むように変更します。
この設定を適用すれば、すべての `VSCode` 環境で同じスペルチェック設定と辞書を共有できます。

### 2.1 `VSCode`の設定手順

以下の手順で共通設定を適用します。

1. ユーザー設定を表示:
   `Ctrl+Shift+P` キーでコマンドパレットを開き、"`Preference: Open User Settings (JSON)`" を選択します。
   ![ユーザー設定 (JSON)](/images/articles/vscode-cspell/ss-vscode-user-settings.png)

2. 設定の追加:
   `settings.json` に `CSpell` の設定を追加します。

   ```json
   // CSpell 設定
   "cSpell.import": [
      "${env:XDG_CONFIG_HOME}/vscode/cspell.config.json"
   ]
   ```

3. 設定の適用:
   `Ctrl+S` キーで保存し、VSCode を再起動します。

4. 全環境への適用
   上記の手順を、`VSCode`のすべてのプロファイルで実行します。
   環境変数 `XDG_CONFIG_HOME` が正しく設定されていれば、同じ `dotfiles`リポジトリを共有するだけで、すべての環境で `CSpell` 設定が利用できます。

これで、`VSCode` の設定は完了です。
この設定により、次のような効果が得られます。

- 共通のユーザー辞書:
  `user-dic`に登録された英単語のスペルチェックが可能です。
- デフォルトのプロジェクト辞書:
  デフォルトプロジェクト辞書 `project-dic` でプロジェクト特有の英単語のスペルチェックが可能です
- 同一設定:
  `VSCode`の環境間で、同一の`user-dic`によるスペルチェックが可能です。

## 3. ユーザー辞書の設定

共有用のユーザー辞書を作成し、プログラム内で使用される関数名、変数名、略語など、一般辞書に含まれない専門用語を登録します。
これにより、専門用語が誤ってスペルチェックされるのを防ぐことができます。
`Suggestions` 機能を活用すれば、正しい関数名や変数名を補完できます。

1. `user-dic` の作成:
   `${env:XDG_CONFIG_HOME}/vscode/cspell/user.dic` ファイルを作成します。

2. 単語の登録:
   `VSCode`上で未登録の単語 (下線が引かれる) を右クリックし、コンテキストメニューから[`Add Words to user Dictionary`]を選択します。

3. プロジェクト辞書への登録:
   プロジェクト固有の英単語の場合は、コンテキストメニューから[`Add Words to Workspace Dictionary`]を選択します。

4. スペルチェック:
   `CSpell` のスペルチェック機能で、単語をスペルチェックします。
   スペルミスが見つかった場合は、`Spelling Suggestions`で正しい英単語に修正します。

この設定により、スペルミスを減らし、より正確なプログラミングが可能になります。」

## 4. `CSpell` 設定

ユーザーが共通で使用する `CSpell` の設定について説明します。

### 4.1 `CSpell` 基本設定

`dotfiles`上にある `CSpell`設定ファイルには、ユーザー共通辞書、プロジェクト辞書のデフォルト設定が記述され、利用する辞書群、無視対象のファイル／ディレクトリが指定されます。

以下の`Gist`は、共通辞書およびプロジェクト辞書の基本設定を含む `cspell.config.json` の例です。
`dotfiles` 上の `CSpell` 設定ファイルに、ユーザー共通辞書、プロジェクト辞書のデフォルト設定が記述され、利用する辞書群および無視対象のファイル／ディレクトリが指定されます。

この設定ファイルでは:

- ユーザー辞書 (`user-dic`) とプロジェクト辞書 (`project-dic`) を設定
- 英語や技術用語など、標準で使用する辞書群を定義
- `.gitignore` で指定されたファイルなど、スペルチェック対象外となるファイルパターンを設定

をします。

@[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.config.json)

この設定ファイルは`${XDG_CONFIG_HOME}/vscode/`ディレクトリに配置します。

### 4.2 `CSpell`設定のカスタマイズ

プロジェクトによって `CSpell` の設定を変えたい場合は、以下の手順で設定します。

1. `cspell.json` の作成:
   プロジェクト用に　`./vscode/cspell.json` を作成することで、プロジェクト固有の辞書を用いてスペルチェックできます。
   `VSCode` は、`./vscode/cspell.json`を自動的に読み込むので、設定がすぐに反映されます。

2. 設定の記述:
   `~/.vscode/cspell.config.json` に、プロジェクト固有の辞書や設定を追加します。

   @[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.json)

   上記の設定では、`textlint` 用の辞書として `textlint-dic` を追加しています。
   `textlint-dic` では設定ファイル中のプラグインで使用されている英単語「`zenkaku`」、「`hankaku`」などを登録しています。

このように、設定をカスタマイズすることで、プロジェクト固有の辞書が使用できます。

## 5. `Git`の設定

### 5.1 `gitignore` の基本設定

`VSCode`関連の設定は、次のようになっています。

```gitignore
# Visual Studio Code
.vscode/*                 # VSCode 関連の一時ファイル、ユーザー固有のファイルを除外
# 以下の設定ファイルは、バージョン管理の対象です
!.vscode/settings.json    # 主要なユーザー設定
!.vscode/tasks.json       # タスク設定ファイル
!.vscode/launch.json      # デバッグ設定ファイル
!.vscode/extensions.json  # 拡張機能リスト
!.vscode/*.code-snippets  # コードスニペット
```

この設定では、`VSCode`の設定ファイル以外は`Git`の管理対象外となります。

### 5.2 `gitignore` のカスタマイズ

[5.1](#51-gitignore-の基本設定) では、`CSpell` 関連の設定ファイルは管理対象外でした。
以下の設定を追加し、`CSpell`関連のファイルを `git`管理対象に含めます。

```gitignore
!.vscode/cspell.json
!.vscode/cspell.*.json
!.vscode/cspell/dicts/*
```

上記の設定を追加することで、`CSpell` の設定ファイルや辞書ファイルが `git` でバージョン管理されるため、チーム内で設定を統一し、変更履歴を追跡しやすくなります。

## おわりに

この記事では、`CSpell`の`import`機能と環境変数 `XDG_CONFIG_HOME` を活用して、`VSCode`のスペルチェック設定を複数環境で統一する方法を解説しました。
この設定方法の主なメリットは:

- プログラム内で使用する変数名や関数名の誤字を低減
- 共通辞書による一貫したスペルチェック環境の実現
- プロジェクト固有の専門用語辞書によるチーム内での標準化
- `Git`によるバージョン管理を通じた設定の追跡と共有

となります。

今回の手法を取り入れて、コードの品質向上とチーム内での一貫したスペルチェック環境を実現してください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [CSpell - Configuration](https://cspell.org/configuration/):
  `CSpell` 設定ファイルに関する公式ドキュメント

- [CSpell標準の辞書セット](https://github.com/streetsidesoftware/cspell-dicts):
  `CSpell` インストール時に使用可能な標準辞書セット
