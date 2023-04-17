---
title: "Education: Racket言語でAtCoderに挑戦する (PracticeA)"
emoji: "🎾"
type: "tech"
topics: ["Racket", "学習", "AtCoder", "競技プログラミング", "WelcometoAtCoder" ]
published: false
---

## はじめに

今回の記事では、いままで習ったことを活かして、実際に Racket でプログラムをします。

題材には、[AtCoder](https://atcoder.jp/)[^1]の[AtCoder Beginners Selection](https://atcoder.jp/contests/abs)を選びました。

[^1]: 日本語で公開されている競技プログラミングサイト

## AtCoder Beginners Selection とは

AtCoder Beginners Selection(ABS)は、AtCoder のアカウントを取得後に、すぐに利用できる自習用の教材です。
AtCoder は `C++`, `Ruby`, `Python`, そして「`Racket`」といった、さまざまなプログラミング言語に対応しています。
自分の得意なプログラミングで問題を解くことで、プログラミングの技術を向上させるのが本来の目的です。
が、今回は`Racket`の入門記事ということもあり、`Racket`で問題を解いていきます。

## 問題: Welcome to AtCoder

[PracticeA - Welcome to AtCoder](https://atcoder.jp/contests/abs/tasks/practice_1)を解いていきます。この問題は、標準入力からパラメータを読み込み、それを加工して標準出力に答えを出力するという簡単な問題です。`AtCoder`においてもよく使われる形式の問題です。
今回は、問題を解くというよりも使用する言語でいかに `AtCoder`の出題形式に対応するかが問われています。

### 問題の概要

AtCoder Beginners Selection の[PracticeA - Welcome to AtCoder](https://atcoder.jp/contests/abs/tasks/practice_1)の問題文は以下の通りです。

>
> **問題**: Welcome to AtCoder
>
> 高橋君はデータの加工が行いたいです。
> 整数 a, b, c と、文字列 s が与えられます。 a + b + c の計算結果と、文字列 s を並べて表示しなさい。
>
> **制約**
>
> - 1 ≤ a, b, c ≤ 1000
> - 1 ≤ |s| ≤ 100
>
> **入力**
>
> 入力は以下の形式で与えられる。
>
> ``` stdin
> a
> b c
> s
> ```
>
> **出力**
> a + b + c と s を空白区切りで 1行目に出力せよ。

与えられた入力は標準入力で、出力は標準出力に出力します。
ポイントは、

- 使用する言語の標準入出力について調べる
- 入力`a`,`b`,`c`については、あとで計算できるよう数値に変換する
- 入力'a'で 1行が終わっている。単純な 1行入力ではうまくいかない

です。
プログラムを書くうえでは、上記のポイントに留意する必要があります。

### 回答例1

Racket の場合、

- Racket では、関数'read'で標準入力を読み込む。このとき、空白や開業について Racket 側が面倒を見てくれる。また、読み込んだデータを適当な型に変換してくれる
- ただし、文字列ではなくシンボルで読み込む
- 出力には、書式付き出力`printf`が使える

です。

これをふまえた回答例は、

``` Racket: main1.rkt
 #lang racket
;; Copyright (c) 2023 Furukawa,Atsushi <atsushifx@aglabo.com>
;;
;; This software is released under the MIT License.
;; https://opensource.org/licenses/MIT

;; input
(define a (read))
(define b (read))
(define c (read))
(define s (read))

;; output
(printf "~s ~s\n" (+ a b c) s)

 ```

となります。

### 回答例2: 関数化する

ステップアップした回答として、回答例1 のプログラムを関数化します。

ポイントは、`(let )`を使うことです。
`let`は局所変数といって、`let`スコープ内だけで有効な変数を定義できます。
構文は、

``` Racket: let構文
(let
  ( (<変数1> <初期値1>) (<変数>2 <初期値2>) ...)
  ( [処理]))

```

です。

`let`を使った回答例は、

``` Racket: main2.rkt
#lang racket
;; Copyright (c) 2023 Furukawa,Atsushi <atsushifx@aglabo.com>
;;
;; This software is released under the MIT License.
;; https://opensource.org/licenses/MIT

;; solve function
(define (solve)
  (let
    ( [a (read)] [b (read)] [c (read)]
      [s (read)])
    (printf "~s ~s\n" (+ a b c) s)))

;; call solver
(solve)

```

となります。

## おわりに

どうでしたか？　最初の問題ということもあり、結構簡単にプログラムが書けました。
次からの回答のために関数化にも挑戦しました。
この調子で、後の問題にも挑戦していきましょう。

それでは、Happy Hacking!

### 参考資料

#### 公式サイト

- [Racket公式ドキュメント](https://docs.racket-lang.org/)
- [AtCoder](https://atcoder.jp/)

#### 局所変数`let`について

- [Local Binding](https://docs.racket-lang.org/guide/let.html)
- [局所変数レット - Scheme入門 スーパービギナー編](https://sites.google.com/site/atponslisp/home/scheme/racket/schemenyuumon-1/schemenyuumon/dai-12shou--kyokusho-hensuu-retto)

#### オンライン学習サイト

- Coursera: <https://www.coursera.org/>
- Udemy.com: <https://www.udemy.com/>
- CS50 for Japanese: <https://cs50.jp/>
