---
title: 'Racket: Racketで"Hello World"を出力する'
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "REPL", "helloworld", ]
published: false
---

## はじめに

いままでの記事で、Windows上に`Racket`の開発環境を設定しました。
ここでは、その環境を使って`Hello World`プログラムを作成します。

プログラムが正常に`Hello World`を出力すれば、学習は次の段階、つまり、`Racket`を使用した関数型プログラミングの学習にすすむことができます。

## 1. `REPL`を使用した`Hello World`の出力

### 1.1 `REPL`の起動

まずは、`Racket`のインタープリターである`REPL`モードで`Hello World`を出力します。
次のようにして、`Racket`を`REPL`モードで起動します。

```powershell
# racket
Welcome to Racket v8.13 [cs].
>

```

### 1.2 `Hello World`の出力 (シンボル)

`REPL`モードで`Hello World`と入力します。
このとき、`Racket`は入力したキーワードを未定義のシンボルとして扱い、次のようなエラーメッセージを出力します。

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

正常に動作させるためには、`Racket`がシンボルをリテラルとして扱う必要があります。
このためには、シンボルの前にクオート (`'`) をつけます。

クオートを就けた場合の結果は次のようになります。

```racket
> 'Hello 'World
'Hello
'World

```

`Hello`と`World`が別のシンボルになっているため、2行で出力されます。

### 1.3 `Hello World`の出力 (空白を含んだシンボルでのクオート方法)

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

### 1.4 `display`関数を使った`Hello World`の出力

`display`関数は、文字列やシンボルのクオートを外して、直接画面に表示します。
次の例では、クオートされたシンボルを`display`を使用して出力しています。

```racket
> (display '|Hello World|)
Hello World

```

### 1.5 "文字列"による`Hello World`の出力

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

## 2. プログラムによる`Hello World`の出力

### 2.1 基本的なプログラム

`Racket`での`Hello World`プログラムは、次のようになります。

```racket: helloworld.rkt
#lang racket

"Hello World!!"

```

出力は、次のようになります。

```bash
"Hello World!!"

```

### 2.2 基本的なプログラムの解説

このセクションでは、[2.1](#21-基本的なプログラム)であげたプログラムを解説します。

`#lang racket`は、このファイルが`Racket`プログラムであることを宣言します。これにより、`Racket`言語のプログラムの解析と実行が適切に行なわれます。

`"Hello World!!"`が、プログラムの本体です。
この行では、`Racket`に文字列`"Hello World!!"`を渡しています。
これを評価した結果である文字列`"Hello World!!"`が出力されます。

### 2.3 シンボルを使った`Hello World`プログラム

文字列の代わりにシンボルを使った場合は、次のようになります。

```racket: helloworld.rkt
#lang racket

'|Hello World!!|

```

出力は、次のようになります。

```bash
'|Hello World!!|

```

### 2.4 `display`関数を使った`Hello World`プログラム

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
