---
title: "Education: Racket言語に比較演算子: 数値型と文字列型の実践ガイド"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "演算子", "勉強", "学習" ]
published: false
---

## はじめに

Racket 言語の比較演算子について説明します。
Racket は LISP[^1]、Scheme の流れを組んだ関数型言語[^2]で、さまざまなデータ型をあらかじめ組み込んでいます。
それぞれのデータ我と似合わせて比較演算子があり、これらを使用するためには経験が必要です。

この記事では、代表的な型である数値型と文字列型について比較演算子を紹介します。これにより、Racket 言語の特徴が少しでもわかると幸いです。

[^1]: LISP: LISt Processing の略語で、リストを操作することができるプログラミング言語。
[^2]: 関数型言語: プログラムを数学的な関数の集合として考えるプログラミングパラダイムの 1つ。副作用を排除することで、プログラムの信頼性や並列処理の実現が可能となる。

## Racket 言語とは

### Racket言語の特徴

Racket は、関数型プログラミングおよびオブジェクト指向プログラミングの双方のパラダイムをサポートする汎用プログラミング言語です。 Racket の特徴は、以下のとおりです。

- 関数型およびオブジェクト指向プログラミングの両方をサポート
- シンプルで理解しやすいシンタックス
- マクロをサポートし、機能を拡張することができる
- 標準ライブラリが豊富であり、さまざまな実用的なツールを提供する

## 比較演算子

Racket ではデータ型のそれぞれに対して比較演算子があります。代表的なデータ型である数値型と文字列型について、コード例をあげて紹介します。

### 数値の比較演算子

Racket における数値は、整数、有理数、実数の 3 角データ型があり、それぞれを組み合わせて比較が可能です。
| 演算子 | 含意 |
| --- | --- |
| < | より小さい|
| > | より大きい |
| <= | 以下 |
| >= | 以上 |
| = | 等しい |

2つの数値の比較する関数の例を紹介します。

``` Racket : compare-numbers.rkt
(define (compare-numbers a b)
   (cond
      [(< a b) "aはbより小さい"]
      [(> a b) "aはbより大きい"]
      [(= a b) "aとbは等しい"]))

```

上記の例では、2つの数値 a と b を比較する`compare-numbers`という関数を定義しています。`cond`を使って数値の比較を行い、その結果に応じた文字列を返しています。

関数の使用例です。

``` Racket
> (compare-numbers 4 5)

> (compare-numbers 4 5)
"aはbより小さい"

> (compare-numbers 3/2 1)
"aはbより大きい"

>> (compare-numbers 3/2 "abc")
<: contract violation
  expected: real?
  given: "abc"

```

最後の例のように、数値以外のデータを入れると「データ型が違う」というエラーが発生します。
回避するには、`number?`のようなデータが数値かどうかのチェックを入れて、数値以外のデータをはじく必要があります。

改善したコードは、

``` Racket : compare-values.rkt
(define (compare-values a b)
   (cond
      [(and (number? a) (number? b))
            (cond
               [(< a b) "aはbより小さい"]
               [(> a b) "aはbより大きい"]
               [(= a b) "aとbは等しい"])]
      [else "数値ではありません"]))

```

となります。

使用例は、

``` Racket
> (compare-values 1 2)
"aはbより小さい"

> (compare-values 2 2)
"aとbは等しい"が表示されます

> (compare-values "a" "b")

```

となります。

#### データ型を横断した比較

Racket では、整数と有理数、実数と有理数といった別々のデータ型の数値も比較できます。
例をあげると、

``` Racket
> (> 1 1.5)
#f
> (> 1.5 2/3)
  #t
> (> 1.5 5/3)
#f

```

となります。

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

Racket では、文字列は Unicode 標準で表されます。文字列を比較する際も、Unicode を用いて比較されます。
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

#### 日本語などの比較

Racket では文字列の表現に Unicode を用いているため、日本語のような英数字以外の比較も可能です
日本語での文字列比較の例は、

``` Racket
> (string<? "こんにちは" "こんばんは")
#t

```

となります。

#### 複数の文字列の比較

複数の文字列の比較も可能です。
複数の比較の例は、

``` Racket
> (string>? "abc" "abb" "ab")
#t
> (string>? "abc" "abb" "abb")
#f
>

```

となります。

### 同等を比較する (`=`,`eq?`,`eqv?' , 'equal?')

Racket では 2つのデータが「同等」であるかどうかを比較するために、さまざまな演算子が用意されています。
いかに代表的な演算子とその特徴を紹介します。

| 演算子 | 含意 |
| --- | --- |
| = | 2つの数値が等しいことをチェックする。数値型でないときは、エラーとなる |
| eq? | 2つのデータが同じオブジェクトを参照しているときに等しい(`#t`)となる |
| eqv? | 2つのデータ(オブジェクト)の値が等しいときに(`#t`)となる |
| equal? | 複合データ型[^3]に用いられ、すべてのデータを再帰的にチェックする。それ以外は、`eqv?`と同じ |

次に、それぞれの演算子の使用例をあげます。

[^3]: 複合データ型: 複数のデータがまとめられたデータ型。Racket では、リスト型やベクター型がこれにあたる。

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

| 関数 | 含意 | 例 |
| --- | ---- |  --- |
| zero? | 数値が`0`であるか否か | `(zero? 0)` → `#t` |
| null ? | リストが空リストかどうか | `(null? '())` → `#t` |
| empty? | 入力されたリストが空か否か | `(empty? '())` → `#t` |
| void? | `void`型かどうか | `(void? (set! a 3))` → `#t` |

**注意事項**

- `(zero? <DATA>)`  : `<DATA>`が数値以外の場合はエラー
- `(null? <DATA>)`  : 引数が `'()`(空リスト)かどうかを確認する関数。リスト型以外は`#f`
- `(empty? <DATA>)` : 引数のリストが `'()`空かどうかを確認する関数。リスト型以外は`#f`
- `(void? <DATA>)`  : 引数が void型かどうかを確認するための関数


リスト型とともに使われる関数として、null?や empty?があります。とくに null?はリストの終端チェックによく使われます。

#### コード例

##### zero? : 数値の`0`かチェック

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
> (empty? "abc")
#f

```

#### null? : 空のリストかチェック

``` Racket : null?
> (null? '())
#t
> (null? null)
#t
> (null? '(1 2))
#f
> (null? "abc")
#f

```

#### void? : 引数が`void`型かチェック

``` Racket : null?
> (void? (display ""))
#t
> (void? 1)
#f
> (void? (+ 1 2))
#f

```

## さいごに

この記事では、Racket での比較演算子について紹介しました。条件分岐やや繰り返しなどで比較演算を使うことは、プログラミングの基本的な操作です。

この記事で紹介した演算子や関数を活用することで、実際的な Racket プログラムを作成することができます。より高度なプログラミングになると比較演算はより複雑になっていきますので、関数型言語において比較演算を適切に使いこなせるよう、継続的に学習を進めていきましょう。

それでは、Happy Hacking!

## 参考資料

### 本

- [Racket Programming the Fun Way](https://www.amazon.co.jp/dp/1718500823)
- [How to Design Programs](https://www.amazon.co.jp/exec/obidos/ASIN/0262534800/)

### Web

- Racket Documentation:<https://docs.racket-lang.org/>
