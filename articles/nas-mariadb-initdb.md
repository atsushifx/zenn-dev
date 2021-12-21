---
title: "NAS: MariaDBを初期設定する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "MariaDB", "開発環境" ]
published: true
---

## tl;dr

asustor NAS では、インストール後のスクリプトやコマンドの配置が異なります。ここでは、[MariaDBをインストール](nas-mariadb-install)した後にデータベースを初期設定する方法を説明します。

### MariaDBのディレクトリ構成

App Central でインストールしたアプリやツールは、ディレクトリ`/usr/local/AppCentral/`下に配置されます。

MariaDB の場合は、次のようになります。

``` bash
/usr/local/AppCentral/
  +-mariadb/
    +-CONTROL        ... MariaDBをインストールするためのアイコンやシェルスクリプト
    +-data
    |  +-binary
    |  |  +-apache   ... apache用モジュール
    |  |  +-bin      ... MariaDB用ツール、mysql,mysqladminなどが入っている
    |  |  +-mysql
    |  |  +-sbin     ... MariaDBデーモン
    |  |  +-share
    |  |    +-mysql  ... MariaDBs設定用SQL
    |  +-conf        ... my.cnf
    |    +-conf.d    ... 各種設定ファイル(my.cnfにより読み込まれる)
    +-lib            ... MariaDBのライブラリモジュール
    +-mysql          ... MariaDBデータディレクトリ
    +-webman         ... Web UIモジュール (ADMで使用)
```

## MariaDBの初期設定

asustor NAS の MariaDB では、初期設定スクリプト`mysql_secure_installation`が使えません。そのため、手動で次のように設定します。

1. `mysql`コマンドを使い。MariaDB にログインします
  
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

1. ログインできるユーザーを確認します

   ``` bash
   MariaDB [mysql]> select user,host,password from user;
   +------+-----------+-------------------------------------------+
   | user | host      | password                                  |
   +------+-----------+-------------------------------------------+
   | root | localhost | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
   | root | agartha   |                                           |
   | root | 127.0.0.1 |                                           |
   | root | ::1       |                                           |
   |      | localhost |                                           |
   |      | agartha   |                                           |
   +------+-----------+-------------------------------------------+
   6 rows in set (0.00 sec)
   
   
   ```

1. `password`が空白のユーザーを削除します

   ``` bash
   ariaDB [mysql]> delete from user where password='';
   Query OK, 5 rows affected (0.00 sec)
   
   MariaDB [mysql]> select user,host,password from user;
   +------+-----------+-------------------------------------------+
   | user | host      | password                                  |
   +------+-----------+-------------------------------------------+
   | root | localhost | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
   +------+-----------+-------------------------------------------+
   1 row in set (0.00 sec)

    ```

1. `root@localhost`のパスワードを変更します。`alter user`が使えないので、`set password`を使います

   ``` bash
   MariaDB [mysql]> alter user root@localhost identified by 'root';
   ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'user root@localhost identified by 'root'' at line 1
   
   
   MariaDB [mysql]> MariaDB [mysql]> set password = password('passbear3');
   Query OK, 0 rows affected (0.00 sec)
   
   
   MariaDB [mysql]> select user,host,password from user;
   +------+-----------+-------------------------------------------+
   | user | host      | password                                  |
   +------+-----------+-------------------------------------------+
   | root | localhost | *7EA4E43749C3BC1B9F913F0383452077DC41D1F3 |
   +------+-----------+-------------------------------------------+
   1 row in set (0.00 sec)
   
   MariaDB [mysql]>  
   ```

1. このとき password 関数を使わないと、平文パスワードを入れることになるためエラーが出ます

   ``` bash
   MariaDB [mysql]> set password for root@localhost = 'root';
   ERROR 1372 (HY000): Password hash should be a 41-digit hexadecimal number
   
   MariaDB [mysql]>
   ```

1. `\q`として`mysql`を抜け、念のため MariaDB を再起動します

   ``` bash
   
   MariaDB [mysql]> \q
   Bye
   
   root@agartha # /usr/local/AppCentral/mariadb/CONTROL/start-stop.sh stop
   Shutting down MySQL
   
   root@agartha # /usr/local/AppCentral/mariadb/CONTROL/start-stop.sh start
   Starting MySQL...
   210721 12:45:20 [Note] mysqld (mysqld 10.0.28-MariaDB) starting as process 31273 ...
   
   root@agartha # 
   ```
  
1. 古いパスワードで MariaDB にログインしてみます。エラーがでてログインできません。新しいパスワードならログインできます

   ``` bash
   root@agartha:/tmp # mysql -u root -p mysql
   Enter password: 
   ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
   
   root@agartha:/tmp # mysql -u root -p mysql
   Enter password: 
   Reading table information for completion of table and column names
   You can turn off this feature to get a quicker startup with -A
   
   Welcome to the MariaDB monitor.  Commands end with ; or \g.
   Your MariaDB connection id is 3
   Server version: 10.0.28-MariaDB Source distribution
   
   Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.
   
   Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
   
   MariaDB [mysql]> 
   ```

1. 以上で、MariaDB の初期設定は終了です
