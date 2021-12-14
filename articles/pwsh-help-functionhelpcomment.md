---
title: "powershell: powershellスクリプトの関数にヘルプを追加する"
emoji: "🐢"
type: "tech" 
topics: ["powershell", "script", "コメント"]
published: false
---



# はじめに

powershellは、ブロックコメントでGet-Help用のヘルプが書けます。このGet-Help用のコメント<sub>(ヘルプコメント)</sub>は、PowerShellスクリプト内で作成した関数にも使用できます。



# コメントベースのヘルプを書く

スクリプトの時と同様に、ブロックコメント`<#`～`#>`内にヘルプキーワードとヘルプの本文を記述します。

主な、ヘルプキーワードは次のようになります



| キーワード         | キーワードの説明                                             |
| ------------------ | ------------------------------------------------------------ |
| .SYNOPSIS          | 関数の説明を、1行程度で簡潔に書きます。                      |
| .PARAMETER <param> | 関数を呼び出すときの引数<sub>(パラメータ)</sub>の説明。キーワードに続けて引数を書き、ヘルプ本文で引数の説明を書きます。 |
| .EXAMPLE           | 関数の呼び出し方を例を挙げて書きます。呼び出しかたにあわせて、複数の例を書くことができます。 |
| .NOTES             | 補足事項などを書きます。                                     |



## ヘルプコメントの書き方

[powershell scriptにヘルプを追加する](https://zenn.dev/atsushifx/articles/pwsh-help-helpcomment)と同じです。作成した関数にあわせてブロックコメントを作成し、ヘルプキーワードとヘルプ本文を記述します。

ヘルプコメント内に他のコメントを書かない点や、ヘルプを記述するときにインデントをするのも同じです。

詳しいことは、[Microsoft公式のヘルプ](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/examples-of-comment-based-help)を参照してください。



### ヘルプコメントの例

実際のヘルプコメントは、つぎのようになります。

``` powershell
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

この場合のHelpは、次のようになります。

``` powershell
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



``` powershell
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

ヘルプコメントが書ける位置は、つぎのようになっています

- 関数の直前

  関数の宣言文`function  <関数名>`の直前の行にヘルプコメントを書きます。ヘルプコメントと関数の間に空白行を入れることはできません。

- 関数の先頭

  関数ブロック`{`の直後の行にヘルプコメントを記述します。ヘルプコメントの前に、`param`などの文を記述できません。

- 関数の末尾

  関数ブロックの終端`}`の直前の行にヘルプコメントを記述します。ヘルプコメントの後に`rerurn`などの文を記述できません。

  

この記事では、最初の関数の直前にヘルプコメントを書いています。多分、これが一番見やすいと思います。
  


# 外部リンク
Microsoft公式ドキュメントなどの外部資料をリンクします

- [関数にコメント ベースのヘルプを配置する](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/placing-comment-based-help-in-functions) 
- [コメント ベースのヘルプの例](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/examples-of-comment-based-help)
