---
title: "asustor NAS: assutor NASでのMySQLコマンドの使い方"
emoji: "🍆"
type: "tech"
topics: ["NAS", "開発環境", "terminal", "MySQL", "MariaDB"]
published: false
---

# はじめに

[MariaDBの初期設定](nas-mariadb-initdb.md)をしただけでは、日本語をうまく使えません。これは、MariaDBがデフォルトで`latin1`の文字エンコードを使用しているためです。そこで文字エンコードに`utf-8`にすることで日本語に対応させます。



# 文字エンコードの確認

はじめに、現在の文字エンコード設定を確認します。

次の手順で、文字エンコードを確認します。

1. rloginを起動します

   

2. MariaDBクライアントにログインします。

   

3. `show variables`コマンドを発行し、設定を確認します。

   

4. 

   
