---
title: "cSpell extensionの設定をXDG_CONFIG_HOME下で共有する"
emoji: "🔠"
type: "tech"
topics: [ "vscode", "cSpell", "extension", "開発環境", "XDG" ]
published: false
---

## はじめに

atsushifx です。

この記事では、`VSCode`の`cSpell`において、環境変数`XDG_CONFIG_HOME`を活用し、ユーザー設定と辞書を共通管理する方法を説明します。
これにより、複数のプロファイルやプロジェクト間で一元管理でき、設定の更新や共有が容易になります。

`cSpell`は`import`機能で外部の設定ファイルが読み込めます。
このとき、設定ファイルのパスは`${env:<環境変数名>}`で環境変数の内容が参照できます。
上記を組み合わせることで、`VSCode`の`workspace`とは別の共通ディレクトリで`cSpell`の設定が管理できます。

## 技術用語

この記事で使用する技術用語です。

- `VSCode` (`Visual Studio Code`):
  `Microsoft`が提供する統合開発環境

- cSpell (`Code Spell Checker`):
  英単語のスペルチェックをする`VSCode`拡張

- `XDG_CONFIG_HOME`:
  `XDG Base Directory`における設定ファイルを格納するディレクトリ (を示す環境変数)

- `dotfiles`:
  ユーザーの設定ファイルを集約し、管理するためのリポジトリ

## 1. `VSCode`の設定

`VSCode`の設定ファイルを書き換え、`cSpell`格調機能が共通の設定ファイルを読み込むよう設定します。

### 1.1 `VSCode`の設定手順

`cSpell`は、`${env:XDG_CONFIG_HOME}`という形式で環境変数`XDG_CONFIG_HOME`の値を参照できるため、これを活用して共通の設定ファイルを指定します。
すべてのプロファイルで、上記のユーザー設定を行ない、`cSpell`の共通設定を反映します。

以下の手順で、`User Profile`に`cSpell`の設定を追加します。

1. ユーザー設定を開く:
   `Ctrl+Shift+P`キーでコマンドパレットを開き、`Preference: Open User Settings (JSON)`を選択します。
   ![ユーザー設定 (JSON)](/images/articles/vscode-cspell/ss-vscode-user-settings.png)

2. 設定の追加:
   `settings.json`に`cSpell`の設定を追加します。

   ```json:settings.json
   // Code Spell Checker
   "cSpell.import": [
      "${env:XDG_CONFIG_HOME}/vscode/cspell.config.json"
   ],
   ```

3. 設定のコピー:
   上記の設定を、`cSpell`を使うプロファイルすべてにコピーします。

以上で、`VSCode`の設定は完了です。
これにより、ユーザーは共通のユーザー辞書`user-dic`に登録された英単語のスペルチェックが可能になります。

## 1.2 ユーザー辞書の設定

共有用のユーザー辞書を作成し、プログラム内で使用される間進めイヤ変数名、略語など、一般辞書に含まれない専門用語を登録します。
これにより、スペルチェック時の誤検出を防止でき、`Suggestions`機能により正しい単語を入力できます。

1. `user-dic`の作成:
   `${XDG_CONFIG_HOME}/vscode/cspell/user.dic` を作成します。

2. 単語の登録:
   未登録の単語 (下に波線が引かれます) を右クリックし、[`Add Words to
   user Dictionary`]を選択します。

3. プロジェクト辞書への登録:
   未登録の単語が、プロジェクト固有の場合は[`Add Words to Workspace Dictionary`]を選択します。

4. スペルチェック:
   `cSpell`のスペルチェック機能で、単語をスペルチェックします。
   スペルミスが見つかった場合は、`Spelling Suggestions`で正しい英単語に直します。

このようにして、スペルミスのないプログラミングが実現できます。

## 2. `cSpell`の設定

ユーザーが共通で使用する`cSpell`の設定について説明します。

### 2.1 基本の設定

`dotfiles`上の`cSpell.config.json`では、ユーザー共通辞書、およびプロジェクト辞書のデフォルト設定を記述します。
また、利用する辞書群 (例:"英語"、"OSS その他のライセンス", "シェル" )や、無視するファイル／ディレクトリを設定します。

@[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.config.json)

### 2.2 `cSpell`の設定のカスタマイズ

プロジェクトによって`cSpell`の設定を変えたい場合は、以下の手順で設定します。

1. `cSpell.json`の作成:
    `~/.vscode/cspell.json`を作成します。
    `VSCode`は、上記の設定ファイルを自動的に読み込みます。

2. 設定の記述:
    `~/.vscode/cspell.config.json`に、プロジェクト固有の辞書や設定を追加します。

    @[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.json)

    上記の設定では、`textlint`で使う単語 "hankaku" などを`textlint-dic`で管理しています。

このように、設定をカスタマイズすることで、プロジェクト固有の辞書が使用できます。

## 3. その他の設定

### 3.1 `.gitignore`の基本設定

`VSCode`関連の設定は、次のようになっています。

```:.gitignore
#  Visual Studio Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
!.vscode/*.code-snippets
```

すなわち、

- .vscode/*: `.vscode`ディレクトリは基本的に無視する
- !.vscode/settings.json, ...: `.vscode/settings.json`など、`VSCode`が使用する設定ファイルは管理対象とする

となります。

### 3.2 `.gitignore`のカスタマイズ

[3.1](#31-gitignoreの基本設定) の設定では、`cSpell`関連の設定ファイルは管理の対象外でした。
以下の設定を追加して、`cSpell`関連のファイルを`git`の管理対象にします。

```:.gitignore
!.vscode/cspell.json
!.vscode/cspell.*.json
!.vscode/cspell/dicts/*
```

上記の設定を追加することで、`cSpell`の設定ファイルや辞書ファイルが`git`によってバージョン管理され、チーム内での設定の統一や変更履歴の追跡が容易になります。

## おわりに

この記事では、`cSpell`の`import`機能を利用し、環境変数`${env:XDG_CONFIG_HOME}`を活用して`VSCode`のスペルチェック設定を統一する方法を説明しました。
これにより、変数名や関数名といったユーザーが日常的に使う単語がスペルチェックできます。

また、`VSCode`のプロジェクトごとのカスタマイズ方法についても説明しました。
これにより、プロジェクト固有の単語も適切にスペルチェックできます。

`.gitignore`の適切な設定により、必要な`cSpell`の設定、辞書ファイルをバージョン管理に含める方法も紹介しました。

スペルチェックは、ソフトウェアの品質を上げる重要な機能です。
この記事を参考にして、チーム全体で統一した単語を利用し、ソフトウェアの品質が向上するでしょう。

それでは、Happy Hacking!
