---
title: "NAS: shellscript : shell名を取得する"
emoji: "🍆"
type: "tech"
topics: ["NAS", "ash", "script", "開発環境" ]
published: true

---

## はじめに

$SHELL には、`/bin/sh`のように shell がフルパスで入っています。これでは使いにくいので、`/bin/sh`→`sh`のように shell 名を取得する shell script 関数を書きました。

## shellの取得

こういうのはパターンマッチ(正規表現)の出番ですね。というわけで、bash のパターンマッチを使ってみます。

  ``` shell
  atsushifx@agartha $ echo ` [ '/bin/sh/' =~ 'sh' ]` $?
  ash: =~: unknown operand
  0
  
  ```

残念。組み込みの ash なので、対応していません。

sed/awk/grep の正規表現を試してみます。コマンドラインでいろいろと試してみます。

  ``` shell
  atsushifx@agartha $ echo '/bin/sh'|sed -e 's/([a-z]+)$/\1/']
  /bin/sh

  atsushifx@agartha $ echo '/bin/sh'|sed -E "s/([a-z]+)$/\1/"
  /bin/sh
  
  atsushifx@agartha $ echo '/bin/sh'|sed -e "s/^[^.]*\/([a-z]+)$/\1/"
  /bin/sh
  atsushifx@agartha $ echo '/bin/sh'|sed -E "s/^[^.]*\/([a-z]+)$/\1/"
  sh

  ```

というわけで、sed の拡張パターンマッチ、`sh`の \1。前のパスもマッチングさせることで``sh``が取得できました。

### shellの取得を関数化する

shell script 内で使えるように、関数化します。
次の手順で、関数を作成します。

  1. 関数のひな形の作成  
    bash での関数の作成方法を調べ、関数のひな形を作成します。  
    `local function`とか`function getsh(lsh)`とかも試したのですが、使えませんでした。

     ``` getsh
      function  getsh()
      {
        local lsh sh
      }
     ```

  2. パラメータの処理  
    shell script では、`$1`,`$2`でパラメータを参照できます。環境変数`$SHELL`にログイン shell が格納されているので、パラメータを指定しないときは、`$SHELL`を参照するようにします。

      ``` getsh
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

  3. shell を取得  
    上記の sed のパターンマッチングを使い shell を取得します。

      ``` getsh
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

  4. 文字列のリターン  
    return 文では、数値しか返せません。取得した shell(``sh``ｎなど)は文字列なので、echo で返却します。

      ``` getsh
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
上記の関数は、ログインスクリプト内に記述して shell 別に処理を分岐させたいときに使用します。

## 追記

コメントで言及された、環境変数の展開機能を試してみました。

  ``` ash
  shortsh=${SHELL##*}
  ```

これで、shell 名`ash`が取得できます。
