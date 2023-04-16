---
title: "Education: Racket: Racketにおける比較演算子"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "演算子", "学習" ]
published: false
---

## はじめに

Racket は、LISP の派生の関数型言語`Scheme`の処理系の 1つです。

## Racket 言語とは

### Racket言語の特徴

Racket は、関数型プログラミングおよびオブジェクト指向プログラミングの双方のパラダイムをサポートする汎用プログラミング言語です。 Racket の特徴は、以下のとおりです。

- 関数型およびオブジェクト指向プログラミングの両方をサポート
- シンプルで理解しやすいシンタックス
- マクロをサポートし、機能を拡張することができる
- 標準ライブラリが豊富であり、さまざまな実用的なツールを提供する

## 比較演算子

Racket では、数値型、文字型、文字列型といった各データ型ごとに比較演算子があります。異なるデータ型のデータでは比較が行えません。
ここでは、例として数値と文字列の比較演算子を紹介します。

### 数値の比較演算子

| 演算子 | 含意 |
| --- | --- |
| < | より小さい|
| > | より大きい |
| <= | 以下 |
| >= | 以上 |
| = | 等しい |

それぞれの演算子は、2つの数値の比較に使用されます。以下はその使用例です。

``` Racket : compare-numbers.rkt
(define (compare-numbers a b)
   (cond
      [(< a b) "aはbより小さい"]
      [(> a b) "aはbより大きい"]
      [(= a b) "aとbは等しい"]))

```

上記の例では、2つの数値 a と b を比較する`compare-numbers`という関数を定義しています。`cond`を使って数値の比較を行い、その結果に応じた文字列を返しています。

#### 複数の数値の比較

複数の数値を比較することもできます。
例をあげると、

``` Racket:

Welcome to Racket v8.8 [cs].
> (> 3 2)
#t
> (> 3 2 2)
#f
> (> 3 2 1)
#t

```

となります。
複数の数値がある場合は、Ⅱ項目ごとに数値を比較して、その And を返します。`(> 3 2 2 )`の場合は、`(> 2 2)`の結果が`#f`となるので、`"f`が返ります。

### 文字列の比較演算子

文字列の比較に使用される演算子には、以下のものがあります。

| 演算子 | 含意 |
| --- | --- |
| string<? | 小文字のアルファベット順に並ぶ |
| string>? | 大文字のアルファベット順に並ぶ |
| string<=? | 小文字のアルファベット順に並ぶか等しい |
| string>=? | 大文字のアルファベット順に並ぶか等しい |
| string=? | 等しい |
| string-ci=? | 大文字小文字の違いを無視したうえで等しい |
| string-ci<? | 大文字小文字の違いを無視したうえで小さい |
| string-ci>? | 大文字小文字の違いを無視したうえで大きい |
| string-ci<=? | 大文字小文字の違いを無視したうえで小さいか等しい |
| string-ci>=? | 大文字小文字の違いを無視したうえで大きいか等しい |

使用例を以下に示します。

``` Racket
(string<? "apple" "banana") ; #t
(string>? "apple" "banana") ; #f
(string<=? "apple" "banana") ; #t
(string>=? "apple" "banana") ; #f
(string=? "apple" "orange") ; #f
(string-ci=? "apple" "Apple") ; #t
(string-ci<? "apple" "Banana") ; #t
(string-ci>? "apple" "Banana") ; #f
(string-ci<=? "apple" "Banana") ; #t
(string-ci>=? "apple" "Banana") ; #f

```

`string-ci=?`のように、最後に'ci'をつけた演算子は大文字と小文字の違いを無視して比較します。
状況に応じて、使い分ける必要があります。

また、文字列は内部的に Unicode 標準が使用されています。

#### 日本語などの比較

``` Racket
> (string<? "こんにちは" "こんばんは")
#t

```

のように、日本語の比較も可能です。

#### 複数の文字列の比較

複数の文字列の比較も可能です。
例をあげると、

``` Racket
> (string>? "abc" "abb" "ab")
#t
> (string>? "abc" "abb" "abb")
#f
>

のような演算ができます。


```

### 同等を比較する (`=`,`eq?`,`eqv?' , 'equal?')

Racket では 2つのデータが「同等」であるかどうかを比較するために、さまざまな演算子が用意されています。
いかに代表的な演算子とその特徴を紹介します。

| 演算子 | 含意 |
| --- | --- |
| = | 2つの数値が等しいことをチェックする。数値型でないときは、エラーとなる |
| eq? | 2つのデータが同じオブジェクトを参照しているときに等しい(`#t`)となる |
| eqv? | 2つのデータ(オブジェクト)の値が等しいときに(`#t`)となる |
| equal? | 複合データ型にもちいられ、すべてのデータを再帰的にチェックする。それ以外は、`eqv?`と同じ |


次に、それぞれの演算子の使用例をあげます。

#### `=` : 数値が等しい

``` Racket
> (= 1 2)
#f
> (= 2 2)
"t
> (= 2 2.0 )  ; 整数と実数の比較
#t
> (= 1 4/4)   ; 整数と有理数の比較
#t
> (= "apple" "apple") ; エラー
=: contract violation
  expected: number?
  given: "apple"

```

#### `eq?` : おなじオブジェクトを参照

``` Racket
> (define a 12)
> (define b 12)
> (define c b)
> (eq? a b)
#t
> (eq? b c)
#t
> (eq? 'a 'a)
#t
> (eq? "apple" "banana")
#f

```

#### 'eqv?' : オブジェクト同士の値を比較

``` Racket
> (define a 12)
> (define b 12)
> (eqv? a b)
#t
> (eqv? 'a 'a)
#t
> (eqv? "apple" "banana")
#f
>(eqv? '(a b c) '(a b c))
#f
>(eqv? '(a b c) '(a b d))
#f

```

リストの場合は、別オブジェクトになるので(`#f`)が返ります。

#### equal? : 再帰的にオブジェクトの値を比較

``` Racket
> (define a 12)
> (define b 12)
> (equal? a b)
#t
> (equal? 'a 'a)
#t
> (equal? "apple" "banana")
#f
>(equal? '(a b c) '(a b c))
#t
>(equal? '(a b c) '(a b d))
#f

```

`equal?`は`eqv?`と違い、リストの中のオブジェクトも比較するので`(equal? '(a b c) '(a b c))`は等しい(`#t`)となります。

### 特殊な比較演算子 (zero?, null?, ...)

データが特殊な値であるかをチェックする演算子__(関数)__もあります。ここでは、代表的なものとその特徴を特徴します。

| 関数 | 含意 | 備考 |
| --- | ---- |  --- |
| zero? | 数値が0かどうか | |
| null ? | データがnullかどうか | nullは空のリスト`'()`を表します。リストの終端チェックにも用いられます |
| empty? | 空のリストかどうか | |
| void? | voidかどうか | voidは値の返さない関数__(例:display)__の返値として使われる |

コード例を示します。

#### zero? : 数値の`0`かチェック

``` Racket : zero?
> (zero? 0)
#t
> (zero? 0.0)
#t
> (zero? -0)
#t
> (zero? 0.1)
#f
> (zero? "abc")  ; エラー
zero?: contract violation
  expected: number?
  given: "abc"

```

#### empty? : リストか空か、チェック

``` Racket : empty?
> (empty? '())
#t
> (empty null)
#t
> (empty? '(1 2))
#f

```

#### empty? : 空のリストかチェック

``` Racket : null?
> (null? '())
#t
> (null? null)
#t
> (null? '(1 2))
#f

```

#### void? : 値が`void`かチェック

``` Racket : null?
> (void? (display ""))
#t
> (void? 1)
#f
> (void? (+ 1 2))
#f

```

## さいごに

この記事では、Racket での比較演算子について紹介しました。比較はi条件分岐やや繰り返しなどで使う、プログラミングの基本となる演算です。
これらの演算子、関数を活用することで実際的な Racket プログラムを作成できるでしょう

## 参考資料

### 本

- [Racket Programming the Fun Way](https://www.amazon.co.jp/dp/1718500823)
- [How to Design Programs](https://www.amazon.co.jp/exec/obidos/ASIN/0262534800/)

### Web

- Racket Documentation:<https://docs.racket-lang.org/>
