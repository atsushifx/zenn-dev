---
title: "Windows: pecoを使ってWindowsのhistoryを使いこなす"
emoji: "⚒️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Windows", "開発環境", "PowerShell", "peco" ]
published: true
---

## TL;DR

  PowerShell のヒストリーを、peco をつかって一覧から選択できるようにします。
  さらに Ctrl+p キーに上記の機能を割り当てて、ヒストリーを簡単に使えるようにします。

## はじめに

  Windows Terminal と PowerShell のおかげで、Windows のコマンドライン環境がかなり使いやすくなりました。
  ヒストリー機能も、Ctrl+r キーでインクリメントサーチができるなどの機能向上があります。
  ここでは、peco を使った PowerShell スクリプトでヒストリーを便利にします。

## スクリプトの作成

### ヒストリーの表示

  PowerShell の history コマンドでは、セッションごとのヒストリーしか表示されません。
  `(Get-PSReadlineOption).HistorySavePath`にヒストリーのログが保存されているので、tail を使って必要なヒストリーを表示します。

  ``` powershell
  
  (tail -20 (Get-PSReadLineOption).HistorySavePath)

  ```

### コマンドの実行

  表示されたヒストリーを peco で選択すれば、実行するコマンドラインが取得できます。実行するだけなら`Invoke-Expression`コマンドレットで実行するだけです。
  しかし、ここではコマンドの引数などを編集することもあります。そのため、`PSReadline`の機能を使い、コマンドラインに選択したコマンドを入力します。

  ``` PowerShell
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert(<選択したコマンド>)
  
  ```

### 関数の作成

  そのほか、peco で ESC でキャンセルしたときの処理などをいれた関数は、つぎのようになります。

  ``` PowerShell: SelectandExecHistory.ps1
  <#
    .SYNOPSIS
      select command from history and execute

    .DESCRIPTION
      select history wuth peco and set command line to execute this.

    .EXAMPLE
      Set-PSReadLineKeyHandler -chord Ctrl+p -scriptBlock { SelectandExecHistory }
      using above that hit ctrl+p to use this.

  #>
  function global:SelectandExecHistory()
  {
     $selectCmd = (tail -20 (Get-PSReadLineOption).HistorySavePath)|peco --select-1 --on-cancel error
     if ($?) {
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selectCmd)
        # [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
        # [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
     } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
     }
  }
  ```
  
  一応、gist にもあげています。
  [gist](https://gist.github.com/atsushifx/a9ae10e2d0cbab8df899aa9b410aa2ce)

### キーへのバインディング

  作成した関数は、このままでは使えません。コマンドは入力されますが、実行されないで次のプロンプトが表示されてしまいます。
  次のようにして、適当なキーで作成した関数を呼び出します (今回は、Ctrl+p キーで呼び出しています)。

  ``` PowerShell
  Set-PSReadLineKeyHandler -chord Ctrl+p -scriptBlock { SelectandExecHistory }

  ```

  作成した関数、および上記のキーコンフィグを PowerShell の初期設定スクリプトに記入します。以後、Ctrl+p キーでヒストリーを簡単に扱えるようになります。

## 参考資料

- [PowerShellの完全な履歴を取得する](https://qiita.com/yuta0801/items/ad0cf608144fb1546e54)
- [スクリプトの作成 / Reference / PSReadLine](https://docs.microsoft.com/ja-jp/powershell/module/psreadline/set-psreadlinekeyhandler)
