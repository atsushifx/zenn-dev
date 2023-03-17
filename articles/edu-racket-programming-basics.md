---
title: "Education: Racket: Racketプログラムの基本"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "学習", "データ型", "Education" ]
published: false
---

## はじめに

Racket の"Hello World"プログラムをもとに、Racket の基本を学習します。

## `Racket`での"Hello World プログラム"

Racket での"Hello,World"プログラムを作成します。
拡張子は"`.rkt`"なので、"helloworld.rkt"というファイルを作成して次のようにコードを作成します。

``` Racket: helloworld.rkt
#lang racket

(display "Hello, my first Racket")
```

このプログラムを実行すると、つぎのようになります。

``` VS Code : output
[Running] racket helloworld.rkt
Hello, my first racket!
[Done] exited with code=0 in 0.517 seconds

```

### Hello Worldプログラムとリスト

上記でしめした"Hello World"プログラムの本体は、3行目の`(display "Hello, my first racket")`です。
Racket は、処理を行なう関数とその引数を`()`でくくって表現します。この 1つながりのデータをリストとよびます。

リストは、データだけでもつくることができます。たとえば、さきほどの`"Hello, my first racket"'は`("Hello," "my first racket")`のようにできます。

### リストを使った"Hello World"

引数にはリストを使うこともできます。この場合、プログラムと実行結果はつぎのようになります。

``` Racket: helloworld.rkt
#lang racket

(display ("Hello, my first Racket"))
```

``` VS Code : output
[Running] racket helloworld.rkt
application: not a procedure;
 expected a procedure that can be applied to arguments
  given: "Hello,"
  context...:
   basics\hello\helloworld.rkt:3:0
   body of "basics\hello\helloworld.rkt"

[Done] exited with code=1 in 0.663 seconds

```

リストをそのまま渡すと、このようにエラーがでます。これはリストの最初の値である"Hello"を関数として評価するためです。
これを防ぐには、"`"をつけてリストそのものを引数として渡すようにします。

``` Racket: helloworld.rkt
#lang racket

(display '("Hello, my first Racket"))
```

``` VS Code : output
[Running] racket helloworld.rkt
(Hello, my first racket!)
[Done] exited with code=0 in 0.648 seconds

```

このばあいは、上記のようにリストが表示されます。
