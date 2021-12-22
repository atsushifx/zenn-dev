---
title: "PowerShell: PowerShellスクリプトの関数にヘルプを追加する"
emoji: "🐢"
type: "tech" 
topics: ["PowerShell", "script", "コメント"]
published: true

---

## はじめに

PowerShell は、ブロックコメントで Get-Help 用のヘルプが書けます。このコメント~(ヘルプコメント)~は、PowerShell スクリプト内で作成した関数にも使用できます。

## コメントベースのヘルプを書く

スクリプトの時と同様に、ブロックコメント`<#`～`#>`内にヘルプキーワードとヘルプの本文を記述します。
主な、ヘルプキーワードは次のようになります。

| キーワード         | キーワードの説明                                             |
| ------------------ | ------------------------------------------------------------ |
| .SYNOPSIS          | 関数の説明を、1行程度で簡潔に書きます。                      |
| .PARAMETER \<param\> | 関数を呼び出すときの引数~(パラメータ)~の説明。キーワードに続けて引数を書き、ヘルプ本文で引数の説明を書きます。 |
| .EXAMPLE           | 関数の呼び出し方を例を挙げて書きます。呼び出しかたにあわせて、複数の例を書くことができます。 |
| .NOTES             | 補足事項などを書きます。                                     |

### ヘルプコメントの書き方

[PowerShell scriptにヘルプを追加する](pwsh-help-helpcomment)と同じです。作成した関数にあわせてブロックコメントを作成し、ヘルプキーワードとヘルプ本文を記述します。

ヘルプコメント内に他のコメントを書かない点や、ヘルプを記述するときにインデントをするのも同じです。

詳しいことは、[Microsoft公式のヘルプ](https://docs.microsoft.com/ja-jp/PowerShell/scripting/developer/help/examples-of-comment-based-help)を参照してください。

### ヘルプコメントの例

実際のヘルプコメントは、つぎのようになります。

   ``` PowerShell
   <#
   .SYNOPSIS
     get path attribute from parameter 'path'
     
   .PARAMETER path
     type get 'path'
   
   #>
   function getPathType([string] $path)
   {
   
   }
   ```

この場合の Help は、次のようになります。

``` PowerShell
Get-Help getPathType

NAME
    getPathType

SYNOPSIS
    get path attribute from parameter 'path'

SYNTAX
    getPathType [[-path] <string>]

ALIASES
    None

REMARKS
    None

```

## ヘルプコメントを書くときの注意事項

### 関数のスコープ

通常、関数はスクリプト内でしか使用できません。このため、関数のヘルプもスクリプト内でしか使えません。
コマンドラインでヘルプを使うためには、関数宣言時に`global:`修飾子をつけて関数をグローバルスコープで宣言する必要があります。
ヘルプコメントは、つぎのようになります。

``` :PowerShell
<#
  .SYNOPSIS
    get path attribute from parameter 'path'

  .PARAMETER path
    type get 'path'

#>
function global:getPathType([string] $path)
{

}
```

こうしておくと、コマンドラインの`Get-Help <関数名>`でヘルプを表示できます。

### ヘルプコメントの位置

ヘルプコメントは、書くときの位置が決まっています。それ以外の位置に書かれたヘルプコメントはヘルプとして解釈されません。
ヘルプコメントが書ける位置は、つぎのようになっています。

- 関数の直前
   関数の宣言文`function  <関数名>`の直前の行にヘルプコメントを書きます。ヘルプコメントと関数の間に空白行を入れることはできません。

- 関数の先頭
   関数ブロック`{`の直後の行にヘルプコメントを記述します。ヘルプコメントの前に、`param`などの文を記述できません。

- 関数の末尾
   関数ブロックの終端`}`の直前の行にヘルプコメントを記述します。ヘルプコメントの後に`rerurn`などの文を記述できません。

この記事では、最初の関数の直前にヘルプコメントを書いています。多分、これが一番見やすいでしょう。
  
## 外部リンク

Microsoft 公式ドキュメントなどの外部資料をリンクします。

- [関数にコメント ベースのヘルプを配置する](https://docs.microsoft.com/ja-jp/PowerShell/scripting/developer/help/placing-comment-based-help-in-functions)

- [コメント ベースのヘルプの例](https://docs.microsoft.com/ja-jp/PowerShell/scripting/developer/help/examples-of-comment-based-help)
