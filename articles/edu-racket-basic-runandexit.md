---
title: "Racket: Racketの起動方法と終了方法"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "tutorial" ]
published: false
---

## はじめに

Racket は、Scheme から派生したマルチパラダイムなプログラミング言語です。
教育用のプログラミング言語として採用されており、プログラマーや研究者だけでなく教育者によっても使用されています。

この記事では、Racket の基本操作である Racket の起動と終了について詳しく説明します。

## 1. Racket の概要

Racket は、Scheme をもとに作成されたマルチパラダイムなプログラミング言語です。関数型プログラミングを主軸としておりシンプルなルールでプログラミングを行えます。
一方、オブジェクト指向プログラミングにも対応しており、大規模なアプリケーションの開発にも対応できます。

## 2. Racket の起動と終了

このセクションでは、Racket の起動と終了手順について説明します。
Racket を効果的に使用するためには、これらの基本的な操作を理解することが重要です。

### 2.1. RacketとREPL (対話型インタフェース)

Racket を引数なしで実行すると、対話型インタフェースである REPL (Read-Eval-Print-Loop)が起動します。
REPL を使用することで、コマンドラインから Racketプログラムを即座に評価できます。
また、Racket では REPL に便利なメタコマンドを追加した XREPL (eXtend REPL)も利用できます。

### 2.2. Racketの起動方法

コマンドラインで`racket`と入力することで、Racket を起動できます。
次の手順で、Racket を起動します:

```powershell
racket
```

起動すると、次のプロンプトが表示されます:

```racket
Welcome to Racket v8.9 [cs].
>
```

以上で、Racket の起動は終了です。

### 2.3. Racketの終了方法

Racket を終了する方法は 2つあります。

#### Racketの終了 (`Ctrl+D`を入力する)

Racket は、`Ctrl+D`キーで終了できます。
入力の途中の場合は`Ctrl+C\`で入力を中断してから、`Ctrl+D`で Racket を終了します。

次の手順で、Racket を終了します。

```racket
Welcome to Racket v8.9 [cs].
>\[`Ctrl+D`を入力\]

C: /lisp >
```

入力中の時は`Ctrl+D`で終了できません。この場合は`Ctrl+C`で入力を中断してから、`Ctrl+D`で終了します。

```Racket
Welcome to Racket v8.9 [cs].
>  Hello\[`Ctrl+C`\ ←入力を中断して、プロンプトに戻る\]
> \[Ctrl+D ← Racketを終了する\]

C: /lisp >
```

上記のように、\[`Ctrl+C`\]、\[`Ctrl+D`\]で Racket を終了します。

#### Racketの終了 (`exit`コマンドを入力する)

Racket は、終了関数`exit`で終了できます。
Racket の場合、関数を実行させるためには'()’で括る必要があるので、`(exit)`を入力します。

以下の手順で、Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>  `(exit)`

C: /lisp >
```

上記のように`(exit)`を入力すると、Racket を終了してコマンドラインに戻ります。

`(exit)`を入力した場合は、入力途中でも Racket を終了します。
下記のようにして、Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>   Hello `(exit)`
Hello: undefined;
 cannot reference an identifier before its definition
  in module: top-level
 [,bt for context]

C: /lisp >
```

この場合、入力中の`Hello`について未定義のエラーを出力します。
その後、`(exit)`が実行されるので、Racket が終了します。

## 3. XREPLの基本

### 3.1 XREPLのメタコマンド

## おわりに

この記事では、Racket の基本操作として起動と終了を説明しました。
Racket は、このようにインタープリターで入力したプログラムの実験ができます。

まずは、Racket の REPL を使うことで、Racket のプログラミングになれていきましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [The Racket Guide](https://docs.racket-lang.org/guide/)
- [XREPL: eXtended REPL](https://docs.racket-lang.org/xrepl/)
