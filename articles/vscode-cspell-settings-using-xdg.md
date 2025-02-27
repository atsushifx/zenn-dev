---
title: "XDG環境変数とimport機能で実現するcSpell設定・辞書の共通管理ガイド"
emoji: "🔠"
type: "tech"
topics: [ "vscode", "CSpell", "extension", "開発環境", "XDG" ]
published: false
---

## はじめに

atsushifx です。

この記事では、`VSCode` の `CSpell` において、環境変数 `XDG_CONFIG_HOME` を活用し、ユーザー設定と辞書を共通管理する方法を説明します。
これにより、複数のプロファイルやプロジェクト間で一元管理でき、設定の更新や共有が容易になります。

`CSpell` は `import`機能で外部の設定ファイルが読み込めます。
このとき、設定ファイルのパスは `${env:XDG_CONFIG_HOME}` で環境変数の内容が参照できます。
上記を組み合わせることで、`VSCode` の `workspace` とは別の共通ディレクトリで `CSpell` の設定が管理できます。

## 技術用語

この記事で使用する技術用語です。

- `VSCode`:
  `Visual Studio Code`、`Microsoft` が提供する統合開発環境

- `CSpell`:
  `Code Spell Checker`、英単語のスペルチェックをする`VSCode`拡張

- `XDG_CONFIG_HOME`:
  `XDG Base Directory`における設定ファイルを格納するディレクトリを示す環境変数

- `dotfiles`:
  ユーザーの設定ファイルを集約し、管理するためのリポジトリ

## 1. `VSCode`の設定

`VSCode` の設定ファイルを書き換え、`CSpell` が共通の設定ファイルを読み込むよう変更します。

### 1.1 `VSCode`の設定手順

`CSpell` は、`${env:XDG_CONFIG_HOME}` という形式で環境変数 `XDG_CONFIG_HOME` の値を参照できるため、これを活用して共通の設定ファイルを指定します。
すべてのプロファイルに共通のユーザー設定を適用することで、`CSpell` の設定が統一されます。

以下の手順で、`User Profile` に `CSpell` の設定を追加します。

1. ユーザー設定を表示:
   `Ctrl+Shift+P` キーでコマンドパレットを開き、`Preference: Open User Settings (JSON)` を選択します。
   ![ユーザー設定 (JSON)](/images/articles/vscode-cspell/ss-vscode-user-settings.png)

2. 設定の追加:
   `settings.json` に `CSpell` の設定を追加します。

   ```json
   // Code Spell Checker
   "cSpell.import": [
      "${env:XDG_CONFIG_HOME}/vscode/cspell.config.json"
   ]
   ```

3. 設定の適用:
   上記の設定を、すべてのプロファイルに適用します。

以上で、`VSCode` の設定は完了です。
これにより、ユーザーは共通のユーザー辞書 `user-dic` に登録された英単語のスペルチェックが可能になります。

## 1.2 ユーザー辞書の設定

共有用のユーザー辞書を作成し、プログラム内で使用される関数名、変数名、略語など、一般辞書に含まれない専門用語を登録します。
これにより、専門用語が誤ってスペルチェックされることを防止できます。
`Suggestions`機能により、正しい関数名や変数名が入力できます。

1. `user-dic` の作成:
   `${XDG_CONFIG_HOME}/vscode/cspell/user.dic` を作成します。

2. 単語の登録:
   未登録の単語 (下線が引かれる) を右クリックし、[`Add Words to user Dictionary`]を選択します。

3. プロジェクト辞書への登録:
   同様に、未登録の単語がプロジェクト固有の場合は[`Add Words to Workspace Dictionary`]を選択します。

4. スペルチェック:
   `CSpell`のスペルチェック機能で、単語をスペルチェックします。
   スペルミスが見つかった場合は、`Spelling Suggestions`で正しい英単語に直します。

このようにして、スペルミスのないプログラミングが実現できます。

## 2. `CSpell`の設定

ユーザーが共通で使用する`CSpell`の設定について説明します。

### 2.1 基本の設定

`dotfiles`上にある `cspell.config.json` には、ユーザー共通辞書、プロジェクト辞書のデフォルト設定が記述され、利用する辞書群、無視対象のファイル／ディレクトリが指定されます。

以下の`Gist`には、共通辞書およびプロジェクト辞書の基本設定が記述されています。
その他、利用した辞書群に共通辞書とプロジェクト辞書を追加し、`.gitignore`で指定されたファイルを無視しています。

@[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.config.json)

### 2.2 `CSpell`の設定のカスタマイズ

プロジェクトによって `CSpell` の設定を変えたい場合は、以下の手順で設定します。

1. `cspell.json` の作成:
    `~/.vscode/cspell.json` を作成します。
    `VSCode` は、上記の設定ファイル (`~/.vscode/cspell.json`) を自動的に読み込むので、プロジェクト固有の設定を容易に反映できます。

2. 設定の記述:
    `~/.vscode/cspell.config.json` に、プロジェクト固有の辞書や設定を追加します。

    @[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.json)

    上記の設定では、`textlint` で"zenkaku", "hankaku"などの単語を `textlint-dic` で管理しています。

このように、設定をカスタマイズすることで、プロジェクト固有の辞書が使用できます。

## 3. その他の設定

### 3.1 `.gitignore`の基本設定

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

この設定では、`VSCode`の設定ファイル以外は`Git`の管理対象外としています。

となります。

### 3.2 `.gitignore`のカスタマイズ

[3.1](#31-gitignoreの基本設定) では、`CSpell`関連の設定ファイルは管理の対象外でした。
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
これで、プロジェクト固有の単語も適切にスペルチェックできます。

`.gitignore` の適切な設定により、必要な `CSpell` の設定、辞書ファイルをバージョン管理に含める方法も紹介しました。

この記事を活用すれば、プログラム内の変数名や関数名の誤字が低減され、コードの可読性向上に寄与できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [CSpell - Configuration](https://cspell.org/configuration/):
  `CSpell` 設定ファイルに関する公式ドキュメント

- [CSpell標準の辞書セット](https://github.com/streetsidesoftware/cspell-dicts):
  `CSpell` インストール時に使用可能な標準辞書セット
