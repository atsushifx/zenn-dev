---
title: "powershell: powershell scriptにヘルプオプションを追加する"
emoji: "🐢"
type: "tech" 
topics: ["powershell", "script" ]
published: false
---

# tl;dr

powershellは、ブロックコメントでGet-Help用のヘルプが書けるよ。  
スクリプト内で、Get-Help <自スクリプト>でヘルプが表示できるよ。  
パラメータ-helpを実装すれば、ヘルプオプションが追加できる。  

  


# コメントベースでヘルプを書く

powershellでは、'<#','#>'を使うことでブロックコメント<sub>(複数行にわたるコメント)</sub>を書くことが出来ます。  
このとき、ヘルプキーワードで始まるコメントを書くとGet-Helpでそのコメントが表示されます。

ヘルプキーワードには、次のようなものがあります。詳しいことは、[コメント ベースのヘルプのキーワード](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/comment-based-help-keywords)を参照してください



・ .SYNOPSYS 
	スクリプトの簡単な説明。1～3行程度でスクリプトがなにをおこなうかを説明します。

・DESCRPTION
	スクリプトの詳細な説明。コマンドオプションや、オプションを指定したときの動作などを説明します。
	







