---
title: "XDG環境変数と import 機能で実現する cSpell 設定・辞書の共通管理ガイド"
emoji: "🔠"
type: "tech"
topics: [ "vscode", "CSpell", "extension", "開発環境", "XDG" ]
published: false
---

## はじめに

atsushifx です。

この記事では、`VSCode` (`Visual Studio Code`) の `CSpell` (`Code Spell Checker`)拡張において設定とユーザー辞書を共通管理する方法を解説します。
`CSpell`は、コード内の英単語のスペルチェックを行ない、誤字脱字を減らすための拡張機能です。

`CSpell`には、`cSpell.import`機能があり外部ファイルを読み込めます。環境変数 `XDG_CONFIG_HOME` を組み合わせることで、複数のプロジェクトやコンピュータ間で設定を共通管理できます。

環境変数 `XDG_CONFIG_HOME` を活用し、`CSpell`の設定や辞書を`Git`で一元管理することで、コードの可読性向上、チーム内での辞書の統一、設定の移行作業の軽減などの利点が得られます。

## 用語集

この記事で使用する技術用語です。

- `VSCode` (`Visual Studio Code`):
  `Microsoft` が提供する統合開発環境

- `CSpell` (`Code Spell Checker`):
  英単語のスペルチェックをする `VSCode`拡張

- `cSpell.import`:
  外部の設定ファイルを読み込む `CSpell`の機能

- `XDG_CONFIG_HOME`:
  `XDG Base Directory`における設定ファイルを格納するディレクトリを示す環境変数

- `dotfiles`:
  ユーザーの設定ファイルを集約し、管理するためのリポジトリ

- `user-dic`:
  ユーザーが作成するプログラム内で使用する関数名など英単語を登録するユーザー辞書

- `project-dic`:
  プロジェクト特有の専門用語を登録するプロジェクト辞書

## 1. 前提条件

この記事は、以下の設定を前提としています。

- `XDG Base Directory`設定:
  `XDG_CONFIG_HOME` が設定されており、ユーザーの設定ファイルを格納している
- `dotfiles` リポジトリ:
  `dotfiles` リポジトリが存在し、環境変数 `XDG_CONFIG_HOME` を利用して設定ファイルを一元管理している
- `CSpell` 拡張:
  `VSCode` には、`CSpell` 拡張がインストールされている

## 2 `VSCode`の設定

`VSCode` の設定ファイルを書き換え、`CSpell` が共通の設定ファイルを読み込むように変更します。

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

4. 全ユーザー設定への適用
   1～3 の手順を繰り返し、`VSCode`のすべてのユーザー設定に `CSpell設定` を適用します。

これで、`VSCode` の設定は完了です。
この設定により、次のような効果が得られます。

- 共通のユーザー辞書:
  `user-dic`に登録された英単語のスペルチェックが可能です。
- デフォルトのプロジェクト辞書:
  デフォルトプロジェクト辞書 `project-dic` でプロジェクト特有の英単語のスペルチェックが可能です
- 同一設定:
  `VSCode`の環境間で、同一の`user-dic`によるスペルチェックが可能です。

## 2.2 ユーザー辞書の設定

共有用のユーザー辞書を作成し、プログラム内で使用される関数名、変数名、略語など、一般辞書に含まれない専門用語を登録します。
これにより、専門用語が誤ってスペルチェックされるのを防ぐことができます。
`Suggestions` 機能を活用すれば、正しい関数名や変数名を入力できます。

1. `user-dic` の作成:
   `${env:XDG_CONFIG_HOME}/vscode/cspell/user.dic` ファイルを作成します。

2. 単語の登録:
   `VSCode`上で未登録の単語 (下線が引かれる) を右クリックし、コンテキストメニューから[`Add Words to user Dictionary`]を選択します。

3. プロジェクト辞書への登録:
   プロジェクト固有の英単語の場合は、コンテキストメニューから[`Add Words to Workspace Dictionary`]を選択します。

4. スペルチェック:
   `CSpell` のスペルチェック機能で、単語をスペルチェックします。
   スペルミスが見つかった場合は、`Spelling Suggestions`で正しい英単語に修正します。

このようにして、スペルミスのないプログラミングが実現できます。

## 3. `CSpell` 設定

ユーザーが共通で使用する `CSpell` の設定について説明します。

### 3.1 `CSpell` 基本設定

`dotfiles`上にある `CSpell`設定ファイルには、ユーザー共通辞書、プロジェクト辞書のデフォルト設定が記述され、利用する辞書群、無視対象のファイル／ディレクトリが指定されます。

以下の`Gist`には、共通辞書およびプロジェクト辞書の基本設定が記述されています。
その他、利用した辞書群に共通辞書とプロジェクト辞書を追加し、`.gitignore`で指定されたファイルを無視しています。

@[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.config.json)

### 3.2 `CSpell`設定のカスタマイズ

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

## 4. `Git`の設定

### 4.1 `gitignore` の基本設定

`VSCode`関連の設定は、次のようになっています。

```gitignore
# Visual Studio Code
.vscode/*                 # VSCode 関連の一時ファイル、ユーザー固有のファイルを除外
# 以下の設定ファイルは、バージョン管理対象
!.vscode/settings.json    # 主要なユーザー設定
!.vscode/tasks.json       # タスク設定ファイル
!.vscode/launch.json      # デバッグ設定ファイル
!.vscode/extensions.json  # 拡張機能リスト
!.vscode/*.code-snippets  # コードスニペット
```

この設定では、`VSCode`の設定ファイル以外は`Git`の管理対象外となります。

### 4.2 `gitignore` のカスタマイズ

[4.1](#41-gitignore-の基本設定) では、`CSpell` 関連の設定ファイルは管理の対象外でした。
以下の設定を追加し、`CSpell`関連のファイルを `git`管理対象に含めます。

```gitignore
!.vscode/cspell.json
!.vscode/cspell.*.json
!.vscode/cspell/dicts/*
```

上記の設定を追加することで、`CSpell` の設定ファイルや辞書ファイルが `git` によってバージョン管理され、チーム内での設定の統一や変更履歴の追跡が容易になります。

## おわりに

この記事では、`CSpell` の `import`機能を利用し、環境変数 `XDG_CONFIG_HOME` を活用して `VSCode` のスペルチェック設定を統一する方法を説明しました。
これにより、プログラム内で使用する変数名や関数名の誤字を低減し、コードの可読性が向上します。

また、`VSCode` のプロジェクトごとのカスタマイズ方法についても説明しました。
プロジェクト用に`cspell.json`を設定することで、プロジェクト固有の単語用辞書を作成でき、適切にスペルチェックできます。
プロジェクトごとにドメイン固有辞書を作成すれば、生産性が向上するでしょう。

この記事を活用すれば、プログラム内の変数名や関数名の誤字が低減され、コードの可読性向上に寄与できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [CSpell - Configuration](https://cspell.org/configuration/):
  `CSpell` 設定ファイルに関する公式ドキュメント

- [CSpell標準の辞書セット](https://github.com/streetsidesoftware/cspell-dicts):
  `CSpell` インストール時に使用可能な標準辞書セット
