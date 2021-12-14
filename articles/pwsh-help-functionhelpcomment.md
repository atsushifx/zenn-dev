---
title: "powershell: powershell scriptにヘルプを追加する"
emoji: "🐢"
type: "tech" 
topics: ["powershell", "script" ]
published: false
---



# はじめに

powershellは、ブロックコメントでGet-Help用のヘルプが書けます。

作成したヘルプは、``Get-Help <スクリプトファイル>``で表示されます。




# コメントベースでヘルプを書く

powershellでは、'<#','#>'を使うことでブロックコメント<sub>(複数行にわたるコメント)</sub>を書くことが出来ます。  
このとき、ヘルプキーワードで始まるコメントを書くとGet-Helpでそのコメントが表示されます。

詳しいことは、[コメント ベースのヘルプのキーワード](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/help/comment-based-help-keywords)を参照してください。いかに主なヘルプキーワードを載せておきます。


