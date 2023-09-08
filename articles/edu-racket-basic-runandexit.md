---
title: "Education: Racketの起動と終了"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket" ]
published: false
---

## はじめに

Racket は、Scheme をもとにしたマルチパラダイムなプログラミング言語です。
教育用のプログラミング言語として採用されており、プログラマーや研究者だけでなく教育者によっても使用されています。

この記事では、Racket の基本操作である「Racket の起動方法」と「Racket の終了方法」について詳しく説明します。

## 1. Racket の特徴と利点

Racket は、関数型プログラミングを主軸に掲げておりシンプルなルールでのプログラミングが可能です。また、オブジェクト指向プログラミングにも対応しており、大規模なアプリケーションの開発にも適しています。

## 2. Racket の起動と終了手順

このセクションでは、Racket の起動と終了手順について説明します。
Racket を効果的に使用するためには、これらの基本的な操作を理解することが重要です。

### 2.1. RacketとREPL (対話型インタフェース)

Racket を引数なしで実行すると、対話型インタフェースである REPL (Read-Eval-Print-Loop) が起動します。
REPL を使用することで、コマンドラインから Racketプログラムを即座に評価できます。

REPL に、`EOF`を入力する、あるいは終了コマンドを実行することで、Racket を終了します。

Racket では REPL に便利なメタコマンドを追加した XREPL (eXtend REPL)も利用できます。
たとえば、メタコマンド`,exit`を入力すると、Racket を終了できます。

### 2.2. Racketの起動方法

コマンドラインで`racket`と入力することで、Racket を起動できます。
以下の手順で、Racket を起動します:

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

Racket を終了する方法は `EOF`を入力する方法とコマンドを入力する方法の 2つがあります。
XREPL を使っている場合は、メタコマンドを使って Racket を終了できます。

#### Racketの終了 (`Ctrl+D`を入力する)

Racket は、`Ctrl+D`キーで終了できます。
以下の手順で、Racket を終了します。

```racket
Welcome to Racket v8.9 [cs].
> [Ctrl+Dキーを入力]

C: /lisp >
```

入力中の時は`Ctrl+D`キーで終了できません。この場合は`Ctrl+C`キーで入力を中断してから、`Ctrl+D`キーで終了します。

```Racket
Welcome to Racket v8.9 [cs].
> Hello  [Ctrl+C ← 入力を中断して、プロンプトに戻る\]
> [Ctrl+D ← Racketを終了する]

C: /lisp >
```

上記のように、`[Ctrl+C]、[Ctrl+D]`で Racket を終了します。

#### Racketの終了 (`exit`コマンドを入力する)

Racket は、終了関数`exit`で終了できます。
関数を実行するさいには、`(exit)`のように`()`でくくります。

以下の手順で、Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>  (exit)

C: /lisp >
```

上記のように`(exit)`を入力すると、Racket を終了してコマンドラインに戻ります。

`(exit)`を入力した場合は、入力途中でも Racket を終了します。
下記のようにして、Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>   Hello(exit)
Hello: undefined;
 cannot reference an identifier before its definition
  in module: top-level
 [,bt for context]

C: /lisp >
```

この場合、入力中の`Hello`について未定義のエラーを出力します。
その後、`(exit)`が実行されるので、Racket が終了します。

## 3. XREPLの基本

`XREPL`では、通常のコマンドのほかにメタコマンドが実行できます。
メタコマンドは','+英単語の型式で、"`.help`"、"`,exit`"といった通常のコマンドのほかに、"`,shell`"によるシェルコマンドの実行ができます。

### 3.1 メタコマンドの基本的な使い方

メタコマンドは、Racket の REPL コマンドラインで実行します。

たとえば、`,help`コマンドの場合は次のようになります。

```racket
;;  ,helpコマンドの使用例
,help
; General commands:
;   help (h ?): display available commands
;   exit (quit ex): exit racket
;   cd: change the current directory
;   pwd: display the current directory
;   shell (sh ls cp mv rm md rd git svn): run a shell command
;   edit (e): edit files in your $EDITOR
;   drracket (dr drr): edit files in DrRacket
; Binding information:
 .
 .
 .

```

同様に`,exit`メタコマンドで Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>  ,exit

C: /lisp >
```

メタコマンドでは、プログラムのデバッグなど、もっとシステムに近いことも行えます。

### 3.2 基本的なメタコマンド

以下に、主なメタコマンドを紹介します。

| メタコマンド | 説明 | 内容 |
| --- | --- |--- |
| ,help | ヘルプ | 使用できるメタコマンドの一覧を表示します |
| ,exit | 終了 | Racket を終了し、コマンドラインに戻ります |
| ,shell | シェル | 指定したシェルコマンドを実行します。 ディレクトリの移動、表示などに使われます |
| ,edit | 編集 | 指定したファイルを OS 指定のエディタで編集します |

これ以外にも、さまざまなメタコマンドが用意されています。
詳細は、[XREPL: eXtended REPL](https://docs.racket-lang.org/xrepl/index.html)を参照してください。

## おわりに

この記事では、Racket の基本操作として起動と終了を説明しました。
次は、実際に Racket を操作しながら関数型プログラミング言語の学習を進めましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [The Racket Guide](https://docs.racket-lang.org/guide/)
- [XREPL: eXtended REPL](https://docs.racket-lang.org/xrepl/)
