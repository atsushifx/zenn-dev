---
title: ""Windows: winget: wingetでtab補完機能を使う"
emoji: "🪆"
type: "tech"
topics: ["winget", "パッケージマネージャー", "SCM", "構成管理", "PowerShell" ]
published: false
---

## tl;dr

[wingetツールを利用したタブ補完の有効化](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/tab-completion)に書いてある。

## もっと詳しく

winget のサブコマンド"complete"は入力に応じたタブ補完機能を提供します。実際に使うには、Register-ArgumentCompleter コマンドを使って、tab補完スクリプトを登録する必要があります。

### tab補完スクリプト

Microsoft のサイトに、Tab 補完機能を提供するに PowerShell スクリプトが載っています。
すぐ使えるように、この記事にも転載しておきます。

``` PowerShell
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
```
