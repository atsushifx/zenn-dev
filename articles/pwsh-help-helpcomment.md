---
title: "powershell: powershell scriptにヘルプを追加する"
emoji: "🐢"
type: "tech" 
topics: ["powershell", "script" ]
published: true
---



# はじめに

powershellは、ブロックコメントでGet-Help用のヘルプが書けます。

作成したヘルプは、``Get-Help <スクリプトファイル>``で表示されます。




# コメントベースでヘルプを書く

powershellでは、'<#','#>'を使うことでブロックコメント<sub>(複数行にわたるコメント)</sub>を書くことが出来ます。  
このとき、ヘルプキーワードで始まるコメントを書くとGet-Helpでそのコメントが表示されます。

詳しいことは、[コメント ベースのヘルプのキーワード](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/comment-based-help-keywords)を参照してください。いかに主なヘルプキーワードを載せておきます。





| キーワード         | キーワードの説明                                             |
| ------------------ | ------------------------------------------------------------ |
| .SYNOPSIS          | スクリプトの簡単な説明、1～3行程度でスクリプトがなにをするかを簡潔に説明します」 |
| .DESCRIPTION       | スクリプトの詳細な説明、この項は1つのヘルプトピック内で1回だけ使用できます。 |
| .PARAMETER <param> | スクリプトを呼び出すときの引数<sub>(パラメータ)</sub>の説明。キーワードに続けて引数を書き、ヘルプ本文で引数の説明を書きます。 |
| .EXAMPLE           | 実際にスクリプトを使うときの例を、各例ごとに記述します。     |
|                    |                                                              |





## ヘルプコメントの書き方

コメントベースのヘルプ、いわゆるヘルプコメントは、次のように書きます

``` powershell
<#
  .SYNOPSIS
    <簡単なヘルプ>
    ・
    ・
    ・
```

このように、ブロックコメントヘッダ`<#`に続けて、空白を開けてヘルプのキーワードを書きます。  

そして、その下にヘルプの本文を書きます。これを、各ヘルプのキーワード毎に繰り返します。



作成したヘルプは``Get-Help``コマンドレットを使うと表示されます。出力は、次のようになります。

``` powershell
> Get-Help .\help-function.ps1

NAME
    help-function\help-function.ps1

SYNOPSIS
    test -help option script


SYNTAX
   help-function\help-function.ps1 [-h] [-help] [<CommonParameters>]
.
.
.


```

  


## ヘルプコメントを書くときの注意事項

ヘルプコメントを書くときは、次のようなことに注意する必要があります。  
これらに違反した場合は、作成したヘルプは表示されません。最低限の使い方が表示されます。



- ヘルプコメントブロックには、他のコメントを書かない。  
  ヘルプコメントの前に普通のコメントを書くと、ヘルプコメントして認識されません。  
  ヘッダコメントなどは、別のコメントとして書く必要があります。  

  - ダメな例

    ``` powershell
    <#
     # <ヘッダコメント>
    
      .SYNOPSIS
        test -help option script
    
    ```
  
  - 正しい例  
    
    ``` powershell
    ##
    # <ヘッダコメント>
    #
    
    <#
      .SYNOPSIS
        test -help option script
    ```
  
  
  
- ヘルプはインデントして書く。

  ヘルプキーワード<sub>(``.SYNOPSIS``など)</sub>は、インデントして書く必要があります。インデントしない、つまり空白を入れずに書くとヘルプとして認識されません。  
  ヘルプ本文、つまり``.SYNOPSIS``の次の行のテキストはインデントしてもしなくてもかまいません。  
  しかし、インデントしておいたほうが人が読む場合に、ヘルプの文章だとわかりやすいでしょう。


  - インデント無し <sub>(ヘルプは表示されない)</sub>

    ``` powershell
    <#
    .SYNOPSIS
        test -help option script
    ```


  - 本文インデント無し <sub>(ヘルプは表示される)</sub>

    ``` powershell
    <#
      .SYNOPSIS
    test -help option script
    ```


  - インデントあり

     ``` powershell
     <#
       .SYNOPSIS
         test -help option script
    ```

     


正しい例の場合は、``Get-Help <スクリプト>``でコメントで記述したヘルプを表示します。

それ以外の場合は、次のような簡単なヘルプを表示します。

``` powershell
> Get-Help ./help-function.ps1
help-function.ps1 [-h] [-help]

```





# まとめ

powershellスクリプトでのヘルプの書き方を、ざっと説明してきました。スクリプトにpathが通っていれば、`Get-Help`でヘルプが見られますし、補完も効きます。

便利ですよ。
