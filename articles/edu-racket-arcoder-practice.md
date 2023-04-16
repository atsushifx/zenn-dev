---
title: "Education: Racket言語でAtCoderに挑戦する (PracticeA)"
emoji: "🎾"
type: "tech"
topics: ["Racket", "学習", "AtCoder", "競技プログラミング", "WelcometoAtCoder" ]
published: false
---

## はじめに

[前回までの記事](edu-racket-basic-calc-logiccalc)で、Racket の基礎について解説しました。
今回は、その知識を活かし、[AtCoder Beginners Selection](https://atcoder.jp/contests/abs)の
[PracticeA - Welcome to AtCoder](https://atcoder.jp/contests/abs/tasks/practice_1)はに挑戦しましょう。

## AtCoder Beginners Selection とは

AtCoder Beginners Selection(ABS)は、AtCoder[^1]が提供する競技プログラミングの初心者向けの問題集です。
初心者でも取り組みやすい難易度に設定されており、基礎を身につけるのに最適です。
AtCoder は Racket にも対応しており、Racket を学び始めたばかりの方でも取り組みやすいのが特徴です。

## 問題: Welcome to AtCoder

[PracticeA - Welcome to AtCoder](https://atcoder.jp/contests/abs/tasks/practice_1)を解いていきます。この問題は、標準入力からパラメータを読み込み、それを加工して標準出力に答えを出力するという簡単な問題です。Racket に限らず、AtCoder においてもよく使われる形式の問題です。
今回は、問題を解くというよりも使用する言語でいかに AtCoder の出題形式に対応するかが問われています。

### 問題の概要

AtCoder Beginners Selection の[PracticeA - Welcome to AtCoder](https://atcoder.jp/contests/abs/tasks/practice_1)の問題文は以下の通りです。

:::details 問題文
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
> a
> b c
> s
>
> **出力**
a + b + c と s を空白区切りで 1行目に出力せよ。
:::

### 解1

ポイントは、

- Racket では、関数'read'がデータを適当な型に変換して読み込んでくれる
- ただし、文字列ではなくシンボルで読み込む
- 出力には、printf が使える

です。

あとは、問題文をコードに書き下ろすだけです。
コードは、

``` Racket: main1.rkt
 #lang racket

;; input
(define a (read))
(define b (read))
(define c (read))
(define s (read))

;; output
(printf "~s ~s\n" (+ a b c) s)

 ```

## おわりに

### 参考資料

- [Racket公式ドキュメント](https://docs.racket-lang.org/)
- [AtCoder](https://atcoder.jp/)
