---
title: "開発環境: VS Codeでプログラミングするための拡張機能と設定"
emoji: "🦾"
type: "tech"
topics: [ "開発環境", "VSCode", "extensions", "拡張機能"]
published: false
---

## はじめに

この記事では、`Visual Studio Code`(以下、`VS Code`)でプログラミングするときのために、オススメの設定と拡張機能を紹介します。
その後、`VS Code`の設定ファイル"`extensions.json`" と "`settings.json`" を使用して簡単にインストール、設定する方法を解説します。

## 1. 基本設定

ここでは`VS Code`の基本機能、ワークベンチやエディタの設定をします。

### 1.1. ワークベンチの設定

ワークベンチでは、次のように設定します:

- コマンドパレットでよく使うコマンドを表示する
- Preview を表示しないようにする
- タブを表示する

上記の設定を含めた`settings.json`は以下のようになります:

```json: settings.json
   // workbench common settings
    "workbench.startupEditor": "none",
    "workbench.commandPalette.experimental.suggestCommands": true,
    "workbench.editor.enablePreview": false,           // Previewを表示しない
    "workbench.editor.closeEmptyGroups": true,
    "workbench.editor.showTabs": true,
```

### 1.2. エディタの設定

エディタは、次のように設定します:

- インデント: 各プログラミング言語の構文に基づいて自動インデント
- タブ:  tab キーで、次のタブまで空白を入力
- セーブ時にフォーマット
- ペースト時にフォーマット

上記の設定を含めた`settings.json`は以下のようになります:

```json: settings.json
    // editor settings
    "editor.fontFamily": "0xProto,'3270Condensed NFM ', 'Source Serif 4','DejaVu Serif",
    "editor.autoIndent": "advanced",   // 構文にも基づいてインデント
    "editor.tabSize": 4,
    "editor.useTabStops": true,
    "editor.wordWrap": "on",
    "editor.unicodeHighlight.includeComments": true,
    "editor.cursorStyle": "block",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.suggestSelection": "recentlyUsed",
    "editor.minimap.autohide": true,
    "editor.minimap.renderCharacters": false,
    "editor.renderLineHighlight": "all",

```

## 2. 拡張機能

プログラミングをするうえで便利な拡張機能を紹介します。
ここでは、プログラミング言語に関わらないタブ設定やコメントなどを強化する拡張を紹介します。

### 2.1. 拡張機能一覧

#### `Better Comments`

コメントにタグ機能を追加する拡張機能です。
特定のタグをコメントの行頭につけると、コメントの色が変わります。
設定するタグやコメントの色、スタイルは設定ファイルで変更できます。

設定は:

```json: settings.json
   // better comments
    "better-comments.highlightPlainText": true,

```

となります。

#### `Code Runner`

作成したプログラムを手軽に実行します。また、コードを選択しての実行もできます。
`Code Runner`の設定方法は、"[Racketプログラミング用にCode Runnerをインストール・設定する方法](dev-racket-vscode-coderunner.md)"を参照してください。

#### `Code Spell Checker`

コーディング中にスペルチェックを行い、タイプミスした単語を波線で表示します。
また、ユーザー辞書に基づいて修正します。

`cSpell` の設定は:

```json: settings.json
   // spell checker
    "cSpell.autoFormatConfigFile": true,
    "cSpell.diagnosticLevel": "Warning",
    "cSpell.files": [
        "$workingDir/**"                 // `VS Code`で編集中のディレクトリのみを対象にする
    ],
```

となります。

#### `EditorConfig`

`.editorconfig`を読み込み、文字コード、改行コード、インデントなどのエディタ関連の設定をします。

#### `indent-rainbow`

インデントを段数に応じて色分けして表示します。

#### `licenser`

コードのヘッダー部に OSSライセンスを挿入します。
自分の場合の`licenser`の設定は:

```json: settings.json
    // licenser: license for My Programs
    "licenser.license": "MIT",
    "licenser.author": "Furukawa, Atsushi <atsushifx@aglabo.com>",
```

となります。

#### `Linter`

外部 lint を使ってプログラムを解析し、エラーチェックします。

#### `Path Autocomplete`

外部ファイル読み込み時に、Path の自動補完機能を提供します。

#### `Trailing Spaces`

行末にある空白を表示します。
また、"Trailing Spaces: Delete"コマンドで行末の空白を一括削除します。

## 3. 設定ファイル

ワークベンチなどの基本設定や、上記で紹介した拡張機能を簡単にインストール、使うための設定ファイルを紹介します。

### 3.1. "extensions.json"

上記で紹介した拡張機能を推奨拡張機能にした"extensions.json"です:

```json: extensions.json
{
  "recommendations": [
    "aaron-bond.better-comments",
    "formulahendry.code-runner",
    "streetsidesoftware.code-spell-checker",
    "editorconfig.editorconfig",
    "oderwat.indent-rainbow",
    "ymotongpoo.licenser",
    "fnando.linter",
    "shardulm94.trailing-spaces",
    "ionutvmi.path-autocomplete"
  ]
}

```

上記のファイルを".`vscode/`"下に置いて、`VS Code`を起動します。
下記の画面が現れるので、\[インストール\]をクリックすると、すべての拡張機能をインストールします。

![拡張機能のインストール](https://i.imgur.com/crL6SWa.png)

### 3.2. "settings.json"

基本設定で紹介した設定、および各拡張機能の設定を 1つの"settings.json"にしました。
下記のファイルの内容をコピーすれば、`VS Code`をプログラミング用に設定できます。
後は、自分の好みに合わせて設定をかえればいいでしょう。

```json: settings.json
{
    // file saves & encoding
    "files.eol": "\n",
    "files.insertFinalNewline": true,
    "files.trimTrailingWhitespace": true,
    "files.autoSave": "onWindowChange",
    "explorer.confirmDelete": true,

    // workbench common settings
    "workbench.startupEditor": "none",
    "workbench.commandPalette.experimental.suggestCommands": true,
    "workbench.editor.enablePreview": false,
    "workbench.editor.closeEmptyGroups": true,
    "workbench.editor.showTabs": true,

    // editor settings
    "editor.fontFamily": "0xProto,'3270Condensed NFM ', 'Source Serif 4','DejaVu Serif",
    "editor.autoIndent": "advanced",
    "editor.tabSize": 4,
    "editor.useTabStops": true,
    "editor.wordWrap": "on",
    "editor.unicodeHighlight.includeComments": true,
    "editor.cursorStyle": "block",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.suggestSelection": "recentlyUsed",
    "editor.minimap.autohide": true,
    "editor.minimap.renderCharacters": false,
    "editor.renderLineHighlight": "all",

    // terminal
    "terminal.integrated.fontFamily": "monospace",
    "terminal.integrated.tabs.location": "left",

    // git settings
    "git.autofetch": true,
    "git.openRepositoryInParentFolders": "always",
    "git.suggestSmartCommit": true,

    // config files (json, yaml)
    "json.validate.enable": true,
    "diffEditor.ignoreTrimWhitespace": true,

    // javascript
    "javascript.updateImportsOnFileMove.enabled": "always",

    // ** extensions settings **
    // markdown
    "markdown.extension.theming.decoration.renderTrailingSpace": true,

    // licenser: license for My Programs
    "licenser.license": "MIT",
    "licenser.author": "Furukawa, Atsushi <atsushifx@aglabo.com>",

    // spell checker
    "cSpell.autoFormatConfigFile": true,
    "cSpell.diagnosticLevel": "Warning",
    "cSpell.files": [
        "$workingDir/**"
    ],

    // lint
    // better comments
    "better-comments.highlightPlainText": true,
}
```

### 3.3. `VS Code`に設定を追加する

以下の手順で、上記の設定を追加します。

1. `VS Code`上で\[`Ctrl+Shift+P`\]としてコマンドパレットを開く:
   ![コマンドパレット](https://i.imgur.com/ZP9RSjX.png)

2. \[ユーザー設定を開く(JSON)\]として、`VS Code`の設定ファイルを開く:
   ![ユーザー設定](https://i.imgur.com/7NMDX1b.png)

3. 上記の設定をコピーし、設定ファイルを保存する

以上で、`VS Code`に設定を追加できます。

## さいごに

`VS Code`をプログラミング用エディタとして設定できました。
後は、プログラミング言語やフレームワークごとの拡張機能をインストールすれば快適なプログラミングができるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- VS Code extensions: <https://marketplace.visualstudio.com/vscode>
