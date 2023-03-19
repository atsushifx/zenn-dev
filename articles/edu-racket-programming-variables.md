---
title: "Education: Racket: Racketプログラムでの変数とシンボル"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "学習", "HelloWorld", "Education" ]
published: false
---

## はじめに

ここでは Racket での変数とバインドについて学習します。

## Racketでの変数について

### 変数をつかった、HelloWorld

Racket では、変数名に英数字、'-','_'を使うことができます。
前回の`Helloworld`を変数を使って書きなおすと、つぎのようになります。

``` Racket: hellovariables.rkt
#lang racket

; 1st var
(define greet "おはよう、世界")
(display greet)
(newline)
```

実行結果は、つぎのようになります。

``` VS Code : output
[RUnning] racket helloVar.rkt
おはよう、世界

[Done] exited with code=0 in 0.615 seconds
```

### 変数とシンボル

この変数名のような英数字のみでできた識別子を、Racket では**シンボル**といいます。
作成した**シンボル**に値を代入するには`define`を使います。
`define`を使って、変数と値を結びつけることを**バインド**といいます。

### 変数と破壊的代入(set!)

関数型言語である Racket では、一度**バインド**した変数に新たな値を**バインド**できません。
この場合は、破壊的代入をして新たな値を**バインド**します。
プログラムは、つぎのようになります。

``` Racket: hellovariables.rkt
#lang racket

; 1st var
(define greet "おはよう、世界")
(display greet)
(newline)

(set! greet "good night world")
(display greet)
(newline)
```

結果は、つぎのようになります。

``` VS Code : output
[Running] racket helloVar.rkt
おはよう、世界
good night world

[Done] exited with code=0 in 0.615 seconds
```

このように、set!を使うと同じ**シンボル**でも別の値を出力できます。

### リストの代入

変数に代入する値には、リストも使えます。その場合のプログラムは次のようになります。

``` Racket: hellovariables.rkt
#lang racket

; var with list
(define greet-2 '("Hello," "world."))
(display greet-2)
(newline)
```

前回の"HelloWorld"プログラムとおなじように、リストをそのまま渡すとエラーになるので"`"でクォートしています
実行結果は、つぎのようになります。

``` VS Code : output
[Running] racket helloVar.rkt
(Hello, world.)

[Done] exited with code=0 in 0.615 seconds
```

このように、"Hello," "world."がリストで表示されます。
