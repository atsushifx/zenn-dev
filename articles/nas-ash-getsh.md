---
title: "asustor NAS: shellscript : shell名を取得する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "shellscript", "開発環境" ]
published: false

---

# はじめに

$SHELLには、``/bin/sh``のようにシェルがフルパスで入っています。これでは使いにくいので、``/bin/sh``→``sh``を取得するシェルスクリプト関数を書きました



# シェル(``sh``)の取得

こういうのはパターンマッチ(正規表現)の出番ですね。というわけで、bashのパターンマッチを使ってみます。

``` shell
atsushifx@agartha $ echo ` [ '/bin/sh/' =~ 'sh' ]` $?
ash: =~: unknown operand
0

```



残念。組み込みのashなので、対応していません。

sed/awk/grepの正規表現を試してみます。コマンドラインでいろいろと試してみます。

``` shell
atsushifx@agartha $ echo '/bin/sh'|sed -e 's/([a-z]+)$/\1/'
/bin/sh

atsushifx@agartha $ echo '/bin/sh'|sed -E "s/([a-z]+)$/\1/"
/bin/sh

atsushifx@agartha $ echo '/bin/sh'|sed -e "s/^[^.]*\/([a-z]+)$/\1/"
/bin/sh

atsushifx@agartha $ echo '/bin/sh'|sed -E "s/^[^.]*\/([a-z]+)$/\1/"
sh

```



というわけで、sedの拡張パターンマッチ、``sh``の1.前のパスもマッチングさせることで``sh``が取得できました。



#  シェルの取得を関数化する

シェルスクリプト内で使えるように、関数化します。

次の手順で、関数を作成します。

1.   関数のひな形の作成

   bashでの関数の作成方法を調べ、関数のひな形を作成します

   ``` getsh.sh
   function  getsh()
   {
     local lsh sh
     
   }
   ```

   ``local function``とか``function  getsh(lsh)``とかも試したのですが、使えませんでした
   


2.   パラメータの処理

   shellscriptでは、``$1``,``$2``でパラメータを参照できます。環境変数``$SHELL``にログインシェルが格納されているので、パラメータを指定しないときは、``$SHELL``を参照するようにします

   ``` getsh.sh
   function  getsh()
   {
     local lsh sh
     
     if [ -z $1 ]; then
       lsh=$SHELL
     else
       lsh=$1
     fi
   
     
   }
   ```
   


3.   シェルを取得

   上記のsedのパターンマッチングを使いシェルを取得します

   ``` getsh.sh
   function  getsh()
   {
     local lsh sh
     
     if [ -z $1 ]; then
       lsh=$SHELL
     else
       lsh=$1
     fi
     
     # get shell 
     sh=`echo $lsh | sed -E 's/^[a-z/]*\/([a-z]+)$/\1/'`
     
   }
   ```
   


4.   文字列のリターン

   return文では、数値しか返せません。取得したシェル(``sh``ｎなど)は文字列なので、echoで返却します

   ``` getsh.sh
   function  getsh()
   {
     local lsh sh
     
     if [ -z $1 ]; then
       lsh=$SHELL
     else
       lsh=$1
     fi
     
     # get shell 
     sh=`echo $lsh | sed -E 's/^[a-z/]*\/([a-z]+)$/\1/'`
     
     echo $sh
   }
   ```
   



以上で、関数の作成は終了です。

上記の関数は、ログインスクリプト内に記述してシェル別に処理を分岐させたいときに使用します

