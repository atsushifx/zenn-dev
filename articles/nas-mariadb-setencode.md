---
title: "asustor NAS: MaiaDBの文字コードを'UTF-8'に変更する"
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


# 文字エンコードの変更

   asustor NASでは、`/usr/local/AppCentral/mariadb/`下にスクリプトや設定ファイルがあります。そこに文字エンコード設定ファイルを追加して、文字エンコードを変更します


## エンコード設定ファイルを作成する


   MariaDBでは、`/usr/local/AppCentral/`mariadb/data/conf/`下にあり、そのしたの`conf.d/`下の*.cnfファイルを読み込みます。

   次の手順で、エンコード設定ファイルを作成します。*なお、作業は`root`で行っています*


1. `/usr/local/AppCentral/mariadb/data/conf/conf.d`に移動します

      ``` bash
      atsushifx@agartha # cd /usr/local/AppCentral/mariadb/data/conf/conf.d/
      atsushifx@agartha # pwd
      /usr/local/AppCentral/mariadb/data/conf/conf.d
      
      atsushifx@agartha #
      ```




2. `conf.d`下にencode.cnfファイルを作成し、以下のようにMariaDBの変数を設定します。

      ``` encode.cnf
      #
      # encode settings for Japanese characters
      #
      
      [client]
      default-character-set = utf8mb4


      [mysql]
      default-character-set = utf8mb4


      [mysqld]
      # default-character-set = utf8mb4


      [server]
      character-set-server  = utf8mb4
      collation-server      = utf8mb4_general_ci
    
      ```
    
      *絵文字などにも対応するため`utf8mb4`を使っています*



3. 以上で、設定ファイルの作成は終了です





## MariaDBに設定を反映させる


  作成した`encode.cnf`ファイルの設定をMariaDBに反映させるため、MariaDBのサーバーを再起動します。あわせて、`show variables`で設定が反映されているか確認します。

1. `/usr/local/AppCentral/mariadb/CONTROL`に移動します

``` bash
  root@agartha # cd /usr/local/AppCentral/mariadb/CONTROL/
  root@agartha # pwd
  /usr/local/AppCentral/mariadb/CONTROL

  root@agartha #
```



2.  start-stop.sh`スクリプトを使い、MariaDBサーバを再起動します。

      ``` bash
      root@agartha # ./start-stop.sh stop; ./start-stop.sh start
      Shutting down MySQL
      Starting MySQL...
      210727 11:38:48 [Note] mysqld (mysqld 10.0.28-MariaDB) starting as process 5578 ...
    
      root@agartha #
      ```



3. `show variables`を使い、設定を確認します。

      ``` mysql
      MariaDB [mysql]> show variables like 'char%';
      +--------------------------+-------------------------------------------------------------------------+
      | Variable_name            | Value                                                                   |
      +--------------------------+-------------------------------------------------------------------------+
      | character_set_client     | utf8mb4                                                                 |
      | character_set_connection | utf8mb4                                                                 |
      | character_set_database   | utf8mb4                                                                 |
      | character_set_filesystem | binary                                                                  |
      | character_set_results    | utf8mb4                                                                 |
      | character_set_server     | utf8mb4                                                                 |
      | character_set_system     | utf8                                                                    |
      | character_sets_dir       | /volume1/.@plugins/AppCentral/mariadb/data/binary/share/mysql/charsets/ |
      +--------------------------+-------------------------------------------------------------------------+
      8 rows in set (0.00 sec)


      ```




4.  正常に`utf8mb4`と表示されていれば、文字エンコードの設定は終了です



