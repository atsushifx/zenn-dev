---
title: 'Racket: Racket で "Hello World" を出力する方法'
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "REPL", "helloworld", ]
published: true
---

## はじめに

この記事では、Windows 上で `Racket` の開発環境が設定済みであることを前提に進めます。
開発環境の設定については、[`Zenn` の `Racket` に関するトピックス](https://zenn.dev/topics/racket) を参照してください。
トピックス内の記事で、`Racket`のインストール方法や、`Visual Studio Code` の `Racket` プログラミング用の設定などを紹介しています。

この記事では、設定済みの `Racket`開発環境を使って `Hello World` プログラムを作成します。

プログラムが正常に `Hello World` を出力すれば、学習は次の段階、つまり、`Racket` を使用した関数型プログラミングの学習に進められます。

## 1. `REPL`を使用した`Hello World`の出力

最初に、`REPL` (`Read-Eval-Print-Loop`) を使って `Hello World` を出力します。
`REPL`は入力したコードを即座に実行し、結果を見ることができるツールです。
このため、プログラミングの学習やデバッグプロセスを効率的かつ効果的に行なえます。

### 1.1 `REPL`の起動

まずは、`Racket` のインタープリターである `REPL`モードで `Hello World` を出力します。
次のようにコマンドを入力して、`Racket` を `REPL`モードで起動します:

```powershell
> racket

Welcome to Racket v8.13 [cs].
>

```

### 1.2 `Hello World`の出力 (シンボル)

`REPL`モードで `Hello World` と入力します。
次のようなエラーメッセージを出力します:

```racket
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

上記のエラーは、 `Hello` と `World` の 2つが未定義のシンボルであるために発生します。
このエラーを解決し、`Hello World` を出力するためには、シンボルをクオートしてリテラルとして扱う必要があります。

`Racket` では、シンボルをリテラルとして扱うために、シンボルの前にクオート (`'`) を付ける必要があります。
これにより、`Racket` はシンボルを特定の値として扱います。

次のようになります:

```racket
> 'Hello 'World
'Hello
'World

```

`Hello` と `World` が別のシンボルになっているため、2行で出力されます。

### 1.3 `Hello World`の出力 (空白を含むシンボル)

`Racket` では、空白を含む文字列をシンボルとして扱うには、バーティカルバー(`|`)でクオートします。
たとえば、`'|Hello World|` と入力すると、`Hello World` を 1つのシンボルとして扱うことができます。

次のようになります:

```racket
> '|Hello World|
'|Hello World|

```

また、シンボルにはバックスラッシュ(`\`)を使ったエスケープシーケンスを含めることができます。

次のようになります:

```racket
> 'Hello\ World
'|Hello World|

```

### 1.4 `display`関数を使った`Hello World`の出力

`display`関数を使用すると、引数に与えた文字列やシンボルをクオートなしで出力できます。
たとえば、`(display "Hello World")` を実行すると、画面にはクオートなしの `Hello World` が表示されます。

次のようになります:

```racket
> (display '|Hello World|)
Hello World

```

### 1.5 "文字列"による`Hello World`の出力

`Racket` では、シンボルのほかに数値や文字列も入力できます。
文字列は、`"`でくくります:

```racket
> "Hello World"
"Hello World"

```

上記のように、文字列は`"`でくくられて出力されます。

`display`関数を使うことで、`"`を外すことができます:

```racket
> (display "Hello World")
Hello World

```

## 2. プログラムによる`Hello World`の出力

### 2.1 基本的なプログラム

`Racket` での `Hello World`プログラムは、次のようになります:

```racket: helloworld.rkt
#lang racket

"Hello World!!"

```

出力は次のようになります:

```bash
"Hello World!!"

```

### 2.2 基本的なプログラムの解説

次に、[2.1](#21-基本的なプログラム)で挙げたプログラムを解説します。

`#lang racket` は、このファイルが `Racket`言語で記述されていることを示す宣言です。
この宣言があることで、`Racket`プログラムとして正しく解析・実行されます。
省略できません。

プログラムの本体は、 `"Hello World!!"` です。
この行では、`Racket` に文字列 `"Hello World!!"` を渡しています。
これを評価した結果である文字列 `"Hello World!!"` が出力されます。

### 2.3 シンボルを使った`Hello World`プログラム

次のようになります:

```racket: helloworld.rkt
#lang racket

'|Hello World!!|

```

出力は、次のようになります:

```bash
'|Hello World!!|

```

### 2.4 `display`関数を使った`Hello World`プログラム

同様に、`display`関数を使うと、次のようになります:

```racket: helloworld.rkt
#lang racket

(display "Hello World!!")

```

次のようになります:

```bash
Hello World!!

```

`display`関数の作用により、クオートを外した `Hello World!!` が出力されます。また、`display` は値を返さないため、ほかの出力はありません。

## おわりに

以上で、`Racket` で `Hello World!!` を出力する基本的な方法をマスターしました。
この記事を読んで、実際に `Hello World` が出力できることを願っています。それは、関数型プログラミングの学習の第一歩となるでしょう。
`Racket` の文法やイディオムに慣れれば、もっと複雑なプログラムも自由自在に書けるようになるでしょう。

`Racket` の学習を進めることで、関数型プログラミングへの理解を深め、プログラマーとしてまた 1つ成長しましょう。

それでは、Happy Hacking!

## 技術用語と注釈

この記事で使用する技術用語に関して、注釈を示します。

- `Racket`:
  `LISP`系のプログラミング言語で、とくに教育や研究目的で使用されることが多い言語

- `REPL` (`Read-Eval-Print-Loop`):
  `Read-Eval-Print-Loop` の略で、コードを一行ずつ実行し結果を確認できる開発環境

- `display`関数:
  `Racket` に用意されている関数の 1つで、引数に与えたデータを文字列としてクオートを外して出力する関数

- `シンボル`:
  プログラミング言語内で、特定の値や関数を指し示す識別子

- `クオート`:
  プログラミング言語内でリテラルやシンボルを評価させずにそのままの形で扱うために用いる記号

## 参考資料

### リンク

- [`Racket Documentation`](https://docs.racket-lang.org/)
  `Racket`言語に関するドキュメンテーション
