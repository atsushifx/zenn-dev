---
title: "開発環境: VS Codeでプログラミングするためのおすすめ拡張機能と設定"
emoji: "😎"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [ "開発環境", "VSCode", "extensions", "拡張機能"]
published: false
---

## はじめに

この記事では、`Visual Studio Code`でプログラミングするときのために、オススメの設定と拡張機能を紹介します。

## 基本設定

### ワークベンチの設定

ワークベンチでは、つぎのように設定します:

- コマンドパレットでよく使うコマンドを表示する
- Preview を表示しない
- タブを表示する

`settings.json`は:

```json; settings.json
   // workbench common settings
    "workbench.startupEditor": "none",
    "workbench.commandPalette.experimental.suggestCommands": true,
    "workbench.editor.enablePreview": false,
    "workbench.editor.closeEmptyGroups": true,
    "workbench.editor.showTabs": true,
```

となります。

### エディタの設定

エディタは、つぎのように設定します:

- インデント: advanced (プログラミング言語の構文にもとづいてインデント)
- タブ:  tab キーで、次のタブまで空白を入力
- セーブ時にフォーマット
- ペースト時にフォーマット

`settings.json`は:

```json: settings.json

    // editor settings
    "editor.fontFamily": "0xProto,'3270Condensed NFM ', 'Source Serif 4','DejaVu Serif",
    "editor.autoIndent": "advanced",
    "editor.tabSize": 4
    "editor.useTabStops": true,
    "editor.wordWrap": "on",
    "editor.  eHighlight.includeComments": true,
    "editor.cursorStyle": "block",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.suggestSelection": ""recentlyUsed",
    "editor.minimap.autohide": true,
    "editor.minimap.renderCharacters": false,
    "editor.renderLineHighlight": "all",

```

となります。

## 拡張機能

### 拡張機能一覧

各プログラミング言語共通で使える拡張機能を紹介します。

#### `Better Comments`

コメントにタグ機能を追加する拡張機能です。
コメントの行頭に、"!","`ToDo`"など、特定のタグをつけるとコメントの色が変わります。
タグのスタイルは設定ファイルで変えられます。また、タグの追加もできます。

現状、タグの追加の設定はせず、コメントのハイライトのみおこなっています。
現状の設定は:

```json: settings.json
   // better comments
    "better-comments.highlightPlainText": true,
```

となります。

#### `Code Runner`

作成したプログラムを手軽に実行します。また、コードを選択しての実行もできます。
`Code Runner`の設定方法は、"[Racketプログラミング用にCode Runnerをインストール・設定する方法](dev-racket-vscode-coderunner.md)"を参照してください。

#### `Code Spell Checker`

コーディング中にスペルチェックを行い、タイプミスした単語に波線をつけて表示します。
また、ユーザー辞書などにもとづいてタイプミスした単語を正しい単語にします。

スペルチェックするファイルは、作業中のディレクトリだけにしたいので
`cSpell.files`オプションで読み込むファイルを設定しています。

`cSpell` の設定は:

```json: settings.json
   // spell checker
    "cSpell.autoFormatConfigFile": true,
    "cSpell.diagnosticLevel": "Warning",
    "cSpell.files": [
        "$workinDir/**"
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
    // lincenser : license for My Programs
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

## 設定ファイル

### "extensions.json"

上記の各拡張機能を"extensions.json"の推奨拡張機能にしました。
ファイルは、以下のようになります。

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

### "settings.json"

以下の"settings.json"に各種拡張機能の設定を載せておきます。

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
    "editor.tabSize": 4
    "editor.useTabStops": true,
    "editor.wordWrap": "on",
    "editor.unicodeHighlight.includeComments": true,
    "editor.cursorStyle": "block",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.suggestSelection": ""recentlyUsed",
    "editor.minimap.autohide": true,
    "editor.minimap.renderCharacters": false,
    "editor.renderLineHighlight": "all",

    // terminal
    "terminal.integrated.fontFamily": "monospace",
    "terminal.integrated.tabs.location": "left",

    // git settings
    "git.autofetch": true,
    "git.openRepositoryInParentFolders": "always"
    "git.suggestSmartCommit": true,

    // config files (json, yaml)
    "json.validate.enable": true,
    "diffEditor.ignoreTrimWhitespace": true,

    // javsscript
    "javascript.updateImportsOnFileMove.enabled": "always",

    // ** extensions settings **
    // markdown
    "markdown.extension.theming.decoration.renderTrailingSpace": true

    // lincenser : license for My Programs
    "licenser.license": "MIT",
    "licenser.author": "Furukawa, Atsushi <atsushifx@aglabo.com>",

    // spell checker
    "cSpell.autoFormatConfigFile": true,
    "cSpell.diagnosticLevel": "Warning",
    "cSpell.files": [
        "$workinDir/**"
    ],

    // lint
    // better comments
    "better-comments.highlightPlainText": true,
}
```

## さいごに

## 参考資料

### Webサイト

- VS Code extensions: <https://marketplace.visualstudio.com/vscode>
