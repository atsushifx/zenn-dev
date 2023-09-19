---
title: "Education: Racketの Symbol についてもっと詳しく"
emoji: "🎾"
type: "idea"
topics: ["Education", "Racket", "識別子", #Symbol", ]
published: false
---

## はじめに

## Symbol とは

Symbol は、Symbol データ型のデータで、Racket プログラミングにおきて一意な識別子を表します。
Racket では、Symbol は任意の文字列で表現され、変数や関数として使用されます。

プログラム中で一度定義されたシンボルは変更されません。

### Symbolに使えない文字

Symbol には、文字列の区切りを示すスペースや、データを記述するときに使う特殊記号は使えません。
つまり、以下の文字は使えません。

   ```racket
       (  )  [  ]  { }   "  ,  '  `  ;  #  |  \
   ```

また、数字や文字列など、データを表す文字列も、Symbol には使えません。

### Symbol のエスケープ

Racket で Symbol を扱うには、Symbol をエスケープする必要があります。
エスケープは、戦闘に`'`を追加します。

```racket
(define x 'hello)
x
'hello
```

Symbol は、`|`でくくってもエスケープできます。
この場合、スペースなど特殊な文字を含んだ Symbol を作成できます。

```racket
(define x '|hello world~|)
x
'|hello world|
```

### エスケープ文字を使ったSymbolの宣言

`\`を使うと、空白や特殊記号を含んだ Symbol が作成できます。

```racket
(define x 'hello\ world)
x
'|hell world|
```

### 文字列から Symbolを作成する

関数`string->symbol`を使って、文字列から Symbol を作成できます。

```racket
(string->symbol "hello world")
'|hello world|
```

### Symbolと同一性 (interned)

Racket における Symbol は interned です。つまり、同じ名前の Symbol は同一のオブジェクトであることが保証されています。
ですから、`eq?`関数の結果で`#t`が返ります。

```racket
(define x 'hello)
(define y (string->symbol "hello"))
(eq? x y)
#t
```

## おわりに

## 参考資料

### 本

- [How to Design Programs](https://htdp.org/)

### Webサイト

- Racket Guide- Symbols: <https://docs.racket-lang.org/guide/symbols.html>
- Racket Reference - Symbols: <https://docs.racket-lang.org/reference/symbols.html>
