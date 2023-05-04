---
title: "PowerShell: PesterによろBDDの基本"
emoji: "🚀"
type: "tech"
topics: [ "PowerShell", "Pester", "BDD", "ユニットテスト", "コーディング" ]
published: false
---

## はじめに

この記事では、BDD __(振る舞い駆動開発)__ の実際を、関数を実装しながら見ていきます。
作成する関数は`Remove-Comments`、パイプ形式の入力テキストからコメント部分を削除する関数です。

## 機能要件

ここで、簡単に実装すべき機能を定義しておきます。以下の機能を満たしたら、完成とします。

- 以下のコメントを削除
- 1行コメント: '`#`'から始まる任意の文字列 (行末までコメント)
- 付加コメント: 行の途中に'`#`'があった場合、以降をコメント
- 行内コメント: '`<#`','`#>`'ないの文章
- 複数行コメント: 行頭が'`<#`'ではじまり、行末が'`#>`'で終わる行までをコメント
- コメント削除後の行頭、行末の空白を削除
- テキストはパイプによる入力可能

以上の要件を満たすように、関数を作成します。

## 開発環境

以下の環境で、PowerShellスクリプトを作成します。

- PowerShell 7.3.4
- Pester 5.4.1
- Visual Studio Code 1.77.3

### ディレクトリ構成

以下のディレクトリで関数を開発します。

``` Windows Directory
..
 |-- .editorconfig
 \-- remove-Comments
     \-- Tests

```

開発するスクリプトは`remove-Comments`下に、Pester のテストスクリプトは`Tests`下に作成します。
`New-Fixture`コマンドレットとは違い、ディレクトリが違うので注意してください。

## 実際のBDD

### 1st BDD

最初の BDD では、以下のことを確認します。

- Pester テストが走る
- 作成すべき関数が存在する
- 未実装の部分があれば、`fail`を出力する

このときのコードは以下のようになります。

``` PowerShell: remove-Comments.Tests.ps1

# load tests function script
#
BeforeAll {
  $scriptDir = (Split-Path -Parent $PSScriptRoot)
  $script = (Split-Path -Leaf $PSCommandPath).Replace('.Tests', '')
  $script = $scriptDir + "\" + $script
  # Write-Host "Script :" , $script
  . $script
}

Describe "remove comment from source" {
  context "check implementation" {
    it "can call function" {
      Remove-Comments | Should -BeTrue
    }
  }
}
```

``` PowerShell : remove-Comments.ps1
<#
  .SYNOPSIS
  remove comments from input

#>
function Remove-Comments() {
  throw "Not Implemented"
}

```

上記のコードで`Invoke-Pester`として`Pester`を実行すると、

``` PowerShell
> Invoke-Pester

Starting discovery in 1 files.
Discovery found 1 tests in 15ms.
Running tests.
[-] remove comment from source.check implementation.can call function 4ms (2ms|2ms)
 RuntimeException: Not Implemented
 at Remove-Comments, \powershell\remove-Comments\remove-Comments.ps1:16
 at <ScriptBlock>, \powershell\remove-Comments\Tests\remove-Comments.Tests.ps1:15
Tests completed in 525ms
Tests Passed: 0, Failed: 1, Skipped: 0 NotRun: 0

>
```

と、`RuntimeException: Not Implemented`が出力されて、`Failed: 1`となります。
これは関数`Remove-Comments`が、未実装として`Not Implemented`を`Throw`しているためで正常な結果です。

これが、

``` PowerSHell
> Invoke-Pester

Starting discovery in 1 files.
Discovery found 1 tests in 12ms.
Running tests.
[-] \powershell\remove-Comments\Tests\remove-Comments.Tests.ps1 failed with:
CommandNotFoundException: The term '\Powershell\remove-Comments\remove-Comments.ps1' is not recognized as
a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.

```

のように、`CommandNotFoundException:`が出力される場合は、テストする関数が正常に読み込めていません。

`BeforeAll`で読み込もうとしているスクリプトファイルの名前が間違っているか。あるいは`remove-Comments.ps1`ではない間違ったファイル名になってるはずです。
この場合は、コードを見直して、スクリプトを読み込むようにします。

次に、テストを通るようにコードを変更します。

``` PowerShell: remove-Comments.ps1
function Remove-Comments() {
  return $true
}

```

テスト結果は、

``` PowerShell
> Invoke-Pester

Starting discovery in 1 files.
Discovery found 1 tests in 179ms.
Running tests.
[+] \powershell\remove-Comments\Tests\remove-Comments.Tests.ps1 715ms (114ms|448ms)
Tests completed in 733ms
Tests Passed: 1, Failed: 0, Skipped: 0 NotRun: 0

>
```

と、`Tests Passed 1`となります。
関数`Remove-Comments`が正常に動いていることが確認できました。
これで、最初の BDD は終了です。

### 2nd BDD (行コメント削除)

行コメント削除機能を実装します。
"removeComments.Tests.ps1"にユニットテストを実装し、そのテストを通すように目的のコードを実装します。

#### 1. ユニットテスト (行コメント)

``` PowerShell: remove-Comments.Tests.ps1
# load tests function script
#
BeforeAll {
  $scriptDir = (Split-Path -Parent $PSScriptRoot)
  $script = (Split-Path -Leaf $PSCommandPath).Replace('.Tests', '')
  $script = $scriptDir + "\" + $script
  # Write-Host "Script :" , $script
  . $script
}

Describe "remove comment from source" {
  context "line comment" {
    it "line is all comment" {
      "# line comment" | remove-Comments | Should -BeNullOrEmpty
    }
    it "add comment to line end" {
      "this is code. # this is comment" | remove-Comments | Should -Be "this is code."
    }
}

```

`Should`コマンドレットでコメント削除後の文字列と一致するかチェックします。

上記のコードを通るように、コードを実装します。
"removeComments.ps1"のコードは、

``` PowerShell: remove-Comments.ps1

function Remove-Comments() {
  param(
    # Source code text
    [Parameter(ValueFromPipeline = $true)]
    [String[]]
    $text
  )

  process {
    foreach ($line in $text) {
      $line = ($line -replace '#[^.]*$', '').Trim()
      $line
    }
  }
}

```

となります。

#### 2, ユニットテスト (文字列内のコメント文字)

文字列内に'#'がある場合のテストケースを追加します。
テストコードは、

``` PowerShell: remove-Comments.Tests.ps1

# load tests function script
#
BeforeAll {
  $scriptDir = (Split-Path -Parent $PSScriptRoot)
  $script = (Split-Path -Leaf $PSCommandPath).Replace('.Tests', '')
  $script = $scriptDir + "\" + $script
  # Write-Host "Script :" , $script
  . $script
}

Describe "remove comment from source" {
  context "line comment" {
    it "line is all comment" {
      "# line comment" | remove-Comments | Should -BeNullOrEmpty
    }
    it "add comment to line end" {
      "this is code. # this is comment" | remove-Comments | Should -Be "this is code."
    }
    it "in string" {
      '" # in string " is code # is comment' | remove-Comments | Should -Be '" # in string " is code'
    }
  }
}

```

となります。
そして、すべてのテストケースが通るように`removeComments.ps1`を修正します。
修正したコードは、

``` PowerShell: remove-Comments.ps1
<#
  .SYNOPSIS
  remove comments from input
 #>
function Remove-Comments() {
  param(
    # Source code text
    [Parameter(ValueFromPipeline = $true)]
    [String[]]
    $text
  )

  process {
    foreach ($line in $text) {
      if ($line -match '("[^.]*#[^.]*"[^.]*)') {
        $line = ($line -replace '("[^.]*#[^.]*"[^.]*)#[^.]*$', "`$1").Trim()
      }
      else {
        $line = ($line -replace '#[^.]*$', '').Trim()
      }
      return $line
    }
  }
}

```

となります。

これで、行コメントの削除機能が実装されました。

### 3rd BDD (インラインコメントとマルチラインコメント)

[2nd BDD](#2nd-bdd-行コメント削除)と同様にテストケースを追加し、目的のコードを修正します。

最終的なテストコードは、

``` PowerShell: remove-Comments.Tests.ps1
# load tests function script

#

BeforeAll {
  $scriptDir = (Split-Path -Parent $PSScriptRoot)
  $script = (Split-Path -Leaf $PSCommandPath).Replace('.Tests', '')
  $script = $scriptDir + "\" + $script

# Write-Host "Script :" , $script

  . $script
}

Describe "remove comment from source" {
  Context "line comment" {
    it "line is all comment" {
      "# line comment" | remove-Comments | Should -BeNullOrEmpty
    }
    it "add comment to line end" {
      "this is code. # this is comment" | remove-Comments | Should -Be "this is code."
    }
    it "in string" {
      '" # in string " is code # is comment' | remove-Comments | Should -Be '" # in string " is code'
    }
  }

  Context "inline comment" {
    It "only inline comment" {
      "this <# cooment #> is a code." | remove-Comments | Should -Be "this is a code."
    }
    It "ignore # in comment" {
      "this is <# # is ignored #> a code." | remove-Comments | Should -Be "this is a code."
    }
    It "ignore # in string" {
      'this is <# ignore "#" #> a code.' | remove-Comments | Should -Be "this is a code."
    }

    Context "multi-line comment" {
      It "remove multi line comment" {
        @(
          "start comment",
          "<#### start",
          " # skip this line",
          ' "also skip thisline "',
          " end ###>",
          "end comment" | remove-Comments | Should -Be @("start comment", "end comment")
        )
      }
    }
  }
}

```

となりました。
すべてのテストケースにパスするように修正したコードは、

``` PowerShell: remove-Comments.ps1
<#

.REMARK
# Copyright (c) 2023 Furukawa, Atsushi <atsushifx@aglabo.com>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT
#>

<#
  .SYNOPSIS
  remove comments from input
 #>
function Remove-Comments() {
  param(
    # Source code text
    [Parameter(ValueFromPipeline = $true)]
    [String[]]
    $text
  )

  begin {
    $isSkipLine = false
  }

  process {
    foreach ($line in $text) {
      $line = $line.Trim()

      if (!$isSkipLine -and ($line -match "^<#[^.]*(?!#>)$")) {
        $isSkipLine = $true
      }
      elseif ( $isSkipLine -and ($line -match "[^.]*#>$")) {
        $isSkipLine = $false
      }
      elseif ($isSkipLine) {
        # do nothing
      }
      else {
        # remove in-line commeny
        $line = $line -replace '<#[^.]*#>\s*', ''

        # remove line comment
        if ($line -match '("[^.]*#[^.]*"[^.]*)') {
          $line = ($line -replace '("[^.]*#[^.]*"[^.]*)#[^.]*$', "`$1").Trim()
        }
        else {
          $line = ($line -replace '#[^.]*$', '').Trim()
        }
        return $line
      }
    }
  }
}

```

となりました。

これで、コメント削除関数の実装は終了です。
ヘッダコメントなどを追加すれば、コメント削除関数は完成です。

## さいごに

以上、ざっくりとでしたが、BDD による開発の流れをまとめました。
本来、テストケースは 1つずつ順番に追加しますし、テストケースも""(空文字列)のようにエラーになりそうな値をチェックする必要があります。

大事なのは、一度テストケースを記述しさえすれば同じテストを何度でも実行できる点です。

今回のコーディングでは、行コメントのテストがそれに当たります。
インラインコメントやマルチラインコメントの実装時でも、行コメントの削除についてテストが走ります。
そのおかげで、すべての機能がきちんと動く関数を実装できました。

皆さんも、これを機会に BDD をはじめましょう。

では、Happy Hacking!

## 参考資料

### 公式

- [Pester公式サイト](https://pester.dev/)
- [Microsoft PowerShell 公式ドキュメント](https://learn.microsoft.com/ja-jp/powershell/)

### Webサイト

- [Pester - GitHub](https://github.com/pester/Pester)
