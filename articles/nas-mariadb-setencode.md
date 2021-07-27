---
title: "asustor NAS: MariaDBのエンコードに`UTF-8`を設定する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "MariaDB", "開発環境" ]
published: true
---

# tl;dr

[MariaDBの初期設定](nas-mariadb-initdb.md)をしただけでは、日本語をうまく使えません。これは、MariaDBがデフォルトで`latin1`の文字エンコードを使用しているためです。そこで文字エンコードに`utf-8`にすることで日本語に対応させます。



# 文字エンコードの確認

はじめに、現在の文字エンコード設定を確認します。

次の手順で、文字エンコードを確認します。

1. rloginを起動します

   ![rlogin](https://i.imgur.com/H42JOGZ.jpg)

   

2. MariaDBクライアントにログインします。

   ``` bash
   root@agartha # mysql -u root -p mysql
   Enter password: 
   Reading table information for completion of table and column names
   You can turn off this feature to get a quicker startup with -A
   
   Welcome to the MariaDB monitor.  Commands end with ; or \g.
   Your MariaDB connection id is 6
   Server version: 10.0.28-MariaDB Source distribution
   
   Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.
   
   Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
   
   MariaDB [mysql]>
   ```

   

3. `show variables`コマンドを発行し、設定を確認します。

   ``` bash
   MariaDB [mysql]> show variables like 'char%';
   +--------------------------+-------------------------------------------------------------------------+
   | Variable_name            | Value                                                                   |
   +--------------------------+-------------------------------------------------------------------------+
   | character_set_client     | utf8                                                                    |
   | character_set_connection | utf8                                                                    |
   | character_set_database   | latin1                                                                  |
   | character_set_filesystem | binary                                                                  |
   | character_set_results    | utf8                                                                    |
   | character_set_server     | latin1                                                                  |
   | character_set_system     | utf8                                                                    |
   | character_sets_dir       | /volume1/.@plugins/AppCentral/mariadb/data/binary/share/mysql/charsets/ |
   +--------------------------+-------------------------------------------------------------------------+
   8 rows in set (0.00 sec)
   
   MariaDB [mysql]> 
   ```

   

   以上で、エンコードの確認は終了です。

   

   

   

   
