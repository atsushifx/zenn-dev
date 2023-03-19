---
title: "Education: Racket: `Racket`で\"Hello World\"を出力する"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket", "scheme", "helloworld" ]
published: true
---

## はじめに

現在、関数柄言語`Racket'を学習しています。ここでは、学習したことを備忘録的にメモしておきます。

### Racketとは

`Racket`は、`LISP`の方言`Scheme`から派生したプログラミング言語です。
Racket には、`DrRacket`という統合開発環境があり教育用に十分かつ高価な機能を備えています。

なお、自分は`VSCode`に`Racket`用のプロファイルを作成して開発をしています。
詳しいやり方は、[Visual Studio Codeで'Racket'を使う](edu-racket-vscode-profile)を見てください。

## Racket の起動と終了

コマンドラインで`Racket`を起動すると`Racket`インタプリタが起動します。`Ctrl+Z`と入力するか、`,exit`コマンドを入力するとコマンドラインに戻ります。

``` Racket
C: > Racket.exe
Welcome to Racket v8.8 [cs].
>
> (display "Hello World")
Hello World
> ^Z

C: >
```

## Hello World プログラム

### 単純な Hello World

次は、ファイルにプログラムを書きます。
"hello.rkt"という名前のファイルを作成し、次のようにプログラムを書きます。

``` Racket: hello.rkt
#lang racket

(display "Hello 世界")

```

プログラムを実行します。
コマンドラインで、`racket hello.rkt`と入力すると"Hello 世界"と表示されます。
なお、[Replit](https://replit.com/@atsushifx/helloworld?embed=true)でプログラムを試せます。

``` Powershell
C: > racket hello.rkt
Hello 世界

C: >
```

VS Code の場合は、簡単な方法でプログラムを実行できます。
右クリックで"Run Code"を選択すると、出力ペインに実行結果が表示されます。
あるいは、Ctrl+Shift+P で"Racket: Run file in terminal"を実行します。この場合は、ターミナルペインに実行結果が表示されます。
"Run file in terminal"には、ショートカットキーが設定できます。自分は、`Ctrl+ENTER`に設定してます。

### "Hello World"の解説

Racket のプログラムファイルには、次の特徴があります。まずは、これをおさえてください。

- rkt 拡張子
  racket プログラムは、.rkt という拡張子をつけて保存します。Racket は Scheme ベースなので、拡張子。scm も使えます。この場合は、.scm プログラムが Racket を呼びだすよう設定する必要があります。

- 言語指定
  Racket は、文頭に"#lang <言語名>"で解釈するプログラミング言語を指定します。指定できるプログラミング言語には、"Racket"のほかに型付きの"Typed Racket"や"ALGOL"があります。
  自分でオリジナルの言語を作成して、新たに登録することも可能です。

- Racket の関数
  Racket は LISP より派生した関数型言語です。すなわち、すべての処理は"(<関数> <引数>)"のかたちで表現します。

では、さきほどの"hello.rkt"プログラムについて解説します。
1行目の"#lang racket"で、`Racket`でプログラムことを指定しています。この文はコメント分を除き、ファイルの先頭にある必要があります。

3行目の"(display )"が"Hello World"プログラムの本体です。`display`関数は、引数を標準出力ポートに出力します。ここでは、引数"Hello 世界"を画面に出力しています。

## さいごに

この記事では、最初のプログラムである"Hello World"を作成し、Racket プログラムの基本について説明しました。
次からは、基本的なデータ型や変数、リストなどについて学んでいこうと思います。

それでは、Happy Hacking!
