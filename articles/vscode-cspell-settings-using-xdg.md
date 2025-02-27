---
title: "cSpell extensionの設定をXDG_CONFIG_HOME下で共有する"
emoji: "🔠"
type: "tech"
topics: [ "vscode", "cSpell", "extension", "開発環境", "XDG" ]
published: false
---

## はじめに

atsushifx です。
`cSpell` こと`Code Spell Checker`は、`import`で外部の設定ファイルを読み込む機能があります。
この記事では、`import`を使用して`cSpell`のデフォルト設定を共有する方法を説明します。

## 1. `VSCode`の設定

`cSpell`は`import`機能で外部の設定ファイルを読み込む機能があります。
さらに`import`では、`${env:xxx}`構文で環境変数`xxx`を読み込むことができます。
この機能を使用して、`${env:XDG_CONFIG_HOME}'下にユーザー共通の設定を作成します。

### 1.2 `VSCode`の設定手順

以下の手順で、`User Profile`に`cSpell`の設定を追加します。

1. ユーザー設定を開く:
   `Ctrl+Shift+P`キーで検索ウィンドウを開き、`Preference: Open User Settings (JSON)`を選択します。
   ![ユーザー設定 (JSON)](/images/articles/vscode-cspell/ss-vscode-user-settings.png)

2. 設定の追加:
   `settings.json`に`cSpell`の設定を追加します。

   ```json:settings.json
   // Code Spell Checker
   "cSpell.import": [
      ${env:XDG_CONFIG_HOME}/vscode/cSpell.config.json"
   ],
   ```

3. 設定のコピー:
   上記の設定を、`cSpell`を使うプロファイルすべてにコピーします。

以上で、`VSCode`の設定は完了です。
以後、`cSpell`共通の設定は、`${XDG_CONFIG_HOME}/vscode/cspell.config.json`に記述されます。

## 2. `cSpell`の設定

### 2.1 基本の設定

`cspell.config.json`には、以下を設定します。
@[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.config.json)

上記の設定では、

- ユーザー共通辞書として、`user-dic`を設定
- プロジェクト共通辞書として、`project-dic`を設定
- "英語", "OSS その他のライセンス", "シェル", "vim"の辞書を使用
- `.gitignore`を使用して、ファイル/ディレクトリを無視

としています。

### 2.2 `cSpell`の設定のカスタマイズ

プロジェクトによって`cSpell`の設定を変えたい場合は、以下の手順で行ないます。

1. `cSpell.json`の作成:
    `~/.vscode/cspell.json'を作成します。
    `VSCode`は、上記の設定ファイルを自動的に読み込みます。

2. 設定の記述:
    `~/.vscode/cspell.config.json`に、プロジェクト固有の辞書や設定を追加します。

    @[gist](https://gist.github.com/atsushifx/eca0cf91141b70f72bb6aa6802359aee?file=cspell.json)

    上記の設定では、`textlint`で使う単語 "hankaku" などを`textlint-dic' で管理しています。

このように、設定をカスタマイズすることで、プロジェクト固有の辞書が使用できます。

## 3. その他の設定

### 3.1 `.gitignore`の設定

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

上記の場合、`cSpell`関連の設定は`git`で管理されません。
次の設定を追加し、`cSpell`の設定および辞書を`git`の管理対象にします。

```:.gitignore
!.vscode/cspell.json
!.vscode/cspell.*.json
!.vscode/cspell/dicts/*
```

## おわりに

この記事では、`cSpell`の`import`機能を利用し、環境変数`${env:XDG_CONFIG_HOME}`を活用して`VSCode`のスペルチェック設定を統一する方法を説明しました。
これにより、変数名や関数名といったユーザーが日常的に使う単語がスペルチェックできます。

`VSCode`のプロジェクトごとカスタマイズ方法も説明したので、プロジェクト固有の単語も同様にスペルチェックできます。

`.gitignore`の適切な設定により、必要な`cSpell`の設定、辞書ファイルをバージョン管理に含める方法も紹介しました。

スペルチェックは、ソフトウェアの品質を上げる重要な機能です。
この記事を参考にして、チーム全体で統一した単語を利用し、ソフトウェアの品質が向上するでしょう。

それでは、Happy Hacking!
