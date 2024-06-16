---
title: "Racket: Racketで\"Hello World\"を出力する"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "REPL", "helloworld", ]
published: false
---

## はじめに

現在、関数型プログラミング言語`Racket'を学習しています。ここでは、学習したことを備忘録的にメモしておきます。

## `REPL`で`Hello World`

### `REPL`の起動

まずは、`Racket`のインタープリターである`REPL`モードで`Hello World`を出力します。
次のようにして、`Racket`を`REPL`モードで起動します。

```powershell
# racket
Welcome to Racket v8.13 [cs].
>

```

### `Hello World`の出力 (シンボル)

`REPL`モードで`Hello World`と入力します。
結果は、次のようになります。

```powershell
> Hello World
Hello: undefined;
 cannot reference an identifier before its definition
  in module: top-level
 [,bt for context]
World: undefined;
 cannot reference an identifier before its definition
  in module: top-level
 [,bt for context]

```

上記のように、`undefined`というエラーメッセージが出力されます。
これは、`Hello`,`World`がシンボル (`Racket`における変数名のようなもの) として解釈され、変数の値、または関数の評価を出力しようとするためです。

シンボルをそのまま出力するには、シンボルの前に`'`をつける必要があります。
この場合、結果は次のようになります。

```racket
> 'Hello 'World
'Hello
'World

```

`Hello`と`World`が別のシンボルになっているため、2行で出力されます。

### `Hello World`の出力 (空白を含んだシンボル)

`Hello World`を出力するためには、空白も含めて 1つのシンボルとする必要があります。
シンボルは、`|`で囲った文字列を 1つのシンボルと見なします。

すなわち、`|Hello World|`と入力すると`Hello World`という 1つのシンボルになります。

```racket
> |Hello World|
Hello World: undefined;
 cannot reference an identifier before its definition
  in module: top-level
 [,bt for context]

```

`Hello World`が`undefined`になりました。
`Hello World`だけではシンボルとして評価されるため、`'`をつかってクオートする必要があります。

```racket
> '|Hello World|
'|Hello World|

```

また、`\`でエスケープすることでも、空白などの文字を含むことができます。

```racket
> 'Hello\ World
'|Hello World|

```

### 関数を使った`Hello World`

関数`display`を使うと、`'`や`|`のようなクオートを外して表示します。
関数を使う場合は、`(<関数> <パラメータ>)`のように`()`でくくって使用します。

```racket
> (display '|Hello World|)
Hello World

```

### "文字列"による`Hello World`

`Racket`では、シンボルのほかに数値や文字列も入力できます。
文字列は、`"`でくくって入力します。

```racket
> "Hello World"
"Hello World"

```

上記のように、文字列であることを示すために`"`でくくられて出力されます。

`display`関数を使うことで、`"`を外すことができます。

```racket
> (display "Hello World")
Hello World

```

## プログラムによる`Hello World`

### 基本的なプログラム

`Racket`での`Hello World`プログラムは、次のようになります。

```racket: helloworld.rkt
#lang racket

"Hello World!!"

```

出力は、次のようになります。

```bash
"Hello World!!"

```

### 基本的なプログラムの解説

このセクションでは、先ほどのプログラムの解説をします。
1行目の`#lang racket`は、どの言語でプログラムを書くかを示しています。

`Racket`では、`Algol 60`などのほかの言語のプログラムを書くことができます。
`#lang racket`では`racket`を使用することを宣言しています。この行は、省略できません。

3行目の`"Hello World!!"`が、プログラムの本体です。
この行では、`Racket`に文字列`"Hello World!!"`を渡しています。
これを評価した結果である文字列`"Hello World!!"`が出力されます。

### シンボルによる`Hello World`

文字列の代わりにシンボルを使った場合は、次のようになります。

```racket: helloworld.rkt
#lang racket

'|Hello World!!|

```

出力は、次のようになります。

```bash
'|Hello World!!|

```

### 関数による`Hello World`

同様に、関数`display`を使うと、次のようになります。

```racket: helloworld.rkt
#lang racket

(display "Hello World!!")

```

出力は、次のようになります。

```bash
Hello World!!

```

関数`display`の作用により、クオートを外した`Hello World!!`が出力されます、
また、`display`は値を返さないため、ほかの出力はありません。

## おわりに

以上で、`Hello World!!`を出力するプログラムが書けました。
先頭に`#lang racket`と書き、続けて`Racket`のプログラムを書いていきます。

`Racket`の文法やイディオムを覚えていけば、複雑なプログラムを書けるようになってくるでしょう。

それでは、Happy Hacking!
