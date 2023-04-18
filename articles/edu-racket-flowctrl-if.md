---
title: "Education: Racket: Racketにおける制御フロー (ifとbegin)"
emoji: "🎾"
type: "idea"
topics: ["学習", "Educatin", "Racket", "制御構文", "if" ]
published: false
---

## はじめに

Racket 言語では、すべてが関数であり制御構文である`if`も例外ではありません。この記事では、Racket の制御構文である、`if式`とそれを拡張する`begin`について紹介します。7

### Racketとは

Racket は、関数型プログラミング言語の一種です。`DrRacket`という独自の開発ツールがあり、手軽にプログラミングを始められるのが特徴です。
このため、教育などの分野で広く使われています。

#### Racketの特徴

- 関数型プログラミングをベースにした文法
- 型の自動検出による開発スキルの向上
- 強力なマクロ言語による柔軟なコード変換
- 多彩なライブラリの提供
- 拡張性に優れたツールと環境

## 制御構文 (制御フロー)

### if式

if 式は、条件分岐を行なうための制御フローです。構文は以下の通りです。

``` Racket
(if (<術後>)
  ( [真の場合の処理] )
  ( [偽の場合の処理] )
)
```

**重要事項**

- Racket では、真偽値を返す関数を`<述語>`と呼びます。複数の`<述語>`があった場合はさいごに評価した結果を返します
- Racket の if 式は、`<述語>`の結果により`[真の場合の処理]`か`[偽の場合の処理]`のどちらかを評価します。両方を評価することはありません
- Racket の if 式では、**条件の結果が偽(`#f`)の場合に必ず何かを返す必要がある点**に注意しましょう。もし何も返せない場合は、`void`を返すべきです

例をあげると、

``` Racket
(define x 5)
(define y 3)

(if (> x y)
  (display "xはyよりも大きい")
  (display "xはyよりも小さい"))

```

となります。

#### ifの特殊な使い方

次のようなコードも使えます。

``` Racket
(define x 2)
(define y 3)

((if #f * /) x y)

```

### beginブロック

begin ブロックは、複数の式をひとまとめにします。begin ブロック内の式は、先頭から順番に実行されます。また、begin ブロック自体の値は、最後に実行された式の値となります。

構文は、以下のとおりです

``` Racket
(begin
  (<式1>)
  (<式2>)
   ...
  )
```

例をあげると、

``` Racket
(define x 3)
(define y 5)
(if (> x y)
  (begin
    (display "xはyよりも大きい")
    (display "\n")  ;  改行
    )
  (begin
    (display "xはyよりも小さい")
    (display "\n")  ;  改行
    ))

```

となります。

## さいごに

以上で、Racket の if 式と begin ブロックについて説明しました。これらの制御構文は、プログラムの制御フローをうまく制御するために欠かせないものです。
Racket プログラミングの技術的な理解の向上に役立ててください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Racket Documentation](https://docs.racket-lang.org/)
- [第4章 条件分岐 if 文](https://sites.google.com/site/atponslisp/home/scheme/racket/schemenyuumon-1/schemenyuumon/dai-4shou--jouken-bunki--if-bun)
- [第3回講義レジュメ - 愛媛大学 講義資料 プログラミング言語(Scheme)](http://aiweb.cs.ehime-u.ac.jp/~ninomiya/archive/scheme/itp-3.pdf)
