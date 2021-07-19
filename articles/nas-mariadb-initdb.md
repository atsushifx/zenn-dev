---
title: "asustor NAS: MariaDBを初期設定する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "MariaDB", "開発環境" ]
published: false
---

# tl;dr

asustor NASでは、インストール後のスクリプトやコマンドの配置が異なります。ここでは、[MariaDBをインストール](nas-mariadb-install)した後にデータベースを初期設定する方法を説明します。



## MariaDBのディレクトリ構成

App Centralでアプリやツールをインストールした場合は、ディレクトリ`/usr/local/AppCentral/`下に配置されます。

MariaDBの場合は、次のようになります

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
    +-webman　　　　　... Web UIモジュール (ADMで使用)
```

