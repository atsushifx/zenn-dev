---
title: "Education: Racket: Racketで関数を使う"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "SCHEME", "学習", "Education" ]
published: true
---

## はじめに

この記事では、Racket における関数を学習します。

## Racketの関数

### 関数の定義

Racket では、`define`を使って関数を定義します。書き方は、

  ``` Racket
  (define (<関数名> 引数1 引数2 ...) (<関数本体>))
  ```

です。

### Racketで関数を書いてみる

では、実際に Racket で関数を書いてみます。プログラムは、つぎのとおり

``` Racket : helloFunc.rkt
# lang racket

(define (fHello x)  (display (string-append "おはよう " x "!!\n")) )
(fHello "世界")

```

結果は、つぎのとおり

``` VS Code : output
[Running] racket helloFunc.rkt
おはよう 世界!!

[Done] exited with code=0 in 0.639 seconds
```

### 関数の解説

上記の`helloFunc.rkt`の関数を解説します。

  1. 関数の宣言を`define`で行います。続けて、`(fHello x)`とあるので、引数を 1つとる`fHello`という関数を宣言します。

  2. 続けて関数の本体を記述します。`(display )`とあるので、文字列を画面に出力します。

  3. `(string-append )`は引数を結合して、1つの文字列を作成します。今回は、"おはよう `<x>`!!"という文字列を作成します。

  4. 関数`fHello`は、関数`display`のリターン値"`#<void>`"を返します。

以上で、関数の解説は終了です。
