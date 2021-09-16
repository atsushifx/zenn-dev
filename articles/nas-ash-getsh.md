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
atsushifx@agartha $ 
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



というわけで、sedの拡張パターンマッチ、``sh``の前のパスもマッチングさせることで``sh``が取得できました。







