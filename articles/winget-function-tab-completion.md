---
title: "Windows: winget: wingetでtab補完機能を使う"
emoji: "🪆"
type: "tech"
topics: ["winget", "パッケージマネージャー", "SCM", "構成管理", "PowerShell" ]
published: true
---

## tl;dr

- [wingetツールを利用したタブ補完の有効化](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/tab-completion)に書いてある。

## もっと詳しく

winget のサブコマンド"complete"は入力に応じたタブ補完機能を提供します。実際に使うには、Register-ArgumentCompleter コマンドを使って、tab 補完スクリプトを登録する必要があります。

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

上記のスクリプトを $profile、PowerShell の起動スクリプトにコピーして保存します。その後、PowerShell を再起動すると、winget で tab補完が使えるようになります。

### winget complete について

winget complete は、入力中のコマンドライン、文字列に基づいて入力候補一覧を出力します。
パラメータとして、`commandline`, `word`, `position`の 3つをとり。`commandline` は入力中のコマンドラインそのもの、`word` は tab補完したい単語、`position` はコマンドライン中のカーソル位置を示します。

たとえば、

  ``` PowerShell
  >  winget complete --commandline "winget u" --word="u" --position 1
  upgrade
  update
  uninstall
  
  >
  ```

  のようにコマンドを入力すると、"u"で始まるサブコマンドの一覧を出力します。
  スクリプトは tab を押すごとに次の候補を入力しています。

## まとめ

tab補完は、winget のサブコマンドやオプションだけでなく、パッケージの指定にも使えます。
この機能を使って、さらに効率的なパッケージマネジメントをしましょう。

では、Happy Hacking.

## 参考資料

- [wingetツールを利用したタブ補完の有効化](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/tab-completion)
