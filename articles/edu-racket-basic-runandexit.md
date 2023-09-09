---
title: "Racketの起動方法と終了方法"
emoji: "🎾"
type: "idea"
topics: ["プログラミング言語", "Racket" ]
published: true
---

## はじめに

この記事では、Racket の起動と終了方法について詳しく説明します。

Racket は Scheme に基づいたマルチパラダイムなプログラミング言語で、教育者、プログラマー、研究者など、さまざまな人々によって用いられています。

この記事では、関数型プログラミングを学んでスキルアップしたい ITエンジニア向けに、Racket の基本操作を解説しています。

## 1. Windows Terminalによるコンソール入出力

この記事では、Windows のコンソールでの操作を使って、Racket の使い方を説明しています。
ここでは Windows 用コンソールである`Windows Terminal`の使い方を簡単に説明します。

この記事でのコマンドは、`Windows Terminal`+`PowerShell`で入力しています。

### 1.1. Windows Terminalの起動と終了方法

`Windows Terminal`はショートカットコマンド`wt`で起動します。
`Win+R`キーでコマンドウィンドウを開き`wt`と入力すると`Windows Terminal`が起動します。

![Windows Terminal](https://i.imgur.com/2YbB7lj.png)
*図1: Windows Terminalの起動*

`Windows Terminal`上のコマンドラインに、`exit`を入力すると`Windows Terminal`を終了します。

```powershell
exit
```

## 2. Racket の起動と終了手順

ここでは、Racket の起動と終了手順について詳しく説明します。
Racket を効果的に活用するためには、これらの基本操作を理解することが重要です。

### 2.1. RacketのREPLについて

Racket を引数なしで実行すると、REPL[^1] (`Read`-`Eval`-`Print`-`Loop`)という対話型インタフェースが起動します。
REPL を使用することで、コマンドラインから Racketプログラムを即座に評価できます。

REPL に、`EOF`を入力する、あるいは終了コマンドを実行することで、Racket を終了します。

Racket では通常の REPL に追加機能を持たせた XREPL[^2] (eXtended REPL)も利用できます。
たとえば、メタコマンド`,exit`を入力すると、Racket を終了できます。

[^1]: REPL: `Read`-`Eval-`Print`-Loop`の略で、コンソールで入力した式、関数を評価して結果を返す対話式インタフェース
[^2]:XREPL: REPL にメタコマンドを追加した対話式インタフェース、シェルコマンドの実行機能などやエディタ飛び出しなどの拡張機能を搭載する

### 2.2. Racketの起動方法

`racket`とコマンドラインに入力することで、Racket を起動できます。
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

#### Racketの終了方法 (`Ctrl+D`を入力する)

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

#### Racketの終了方法 (`exit`コマンドを入力する)

Racket は、終了関数`exit`で終了できます。
関数を実行するさいには、`(exit)`のように`()`でくくります。

以下の手順で、Racket を終了します。

```Racket
Welcome to Racket v8.9 [cs].
>  (exit)

C: /lisp >
```

`(exit)`を入力することで上記のように Racket が終了し、コマンドラインに戻ります。

`(exit)`を入力すれば、入力途中でも Racket は終了します。
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

## 3. XREPLの基本操作

このセクションでは、Racket の標準`REPL` である`XREPL` について説明します。

### 3.1 XREPLとは

REPL は、通常の REPL を拡張した対話型インタフェースです。
ヘルプ、シェル、終了などの基本機能から外部ファイルのロード、エディタでの編集、デバッグ機能など、多岐にわたるメタコマンドによる機能拡張が特徴です。
XREPL を使いこなすことで、Racket プログラミングにおける生産性が向上します。

### 3.2. メタコマンドの使い方

`XREPL`では、追加された機能をメタコマンドを通して実行します。
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

タコマンドを使えば、プログラムのデバッグなど、システムの深い部分へのアクセスも可能です。

### 3.3 基本的なメタコマンド

以下に、主なメタコマンドを紹介します。

| メタコマンド |  説明   |  内容 |
| --- | ---  | --- |
| ,help | ヘルプ | 使用できるメタコマンドの一覧を表示します |
| ,exit | 終了 | Racket を終了し、コマンドラインに戻ります |
| ,shell | シェル | 指定したシェルコマンドを実行します。 ディレクトリの移動、表示などに使われます |
| ,edit | 編集 | 指定したファイルを OS 指定のエディタで編集します |

これ以外にも、さまざまなメタコマンドが用意されています。
詳細は、[XREPL: eXtended REPL](https://docs.racket-lang.org/xrepl/index.html)を参照してください。

## おわりに

この記事では、Racket の基本操作として起動と終了を説明しました。
Racket を効果的に活用するためには、これらの基本操作を理解することが重要です。

また、Racket の終了方法として`Ctrl+C`キーによる入力の中断と`Ctrl+D`キーによる終了を学びました。
これにより、どのような状態からでも`PowerShell`に復帰できます。

Racket の XREPL を使えば、関数型プログラミングの試すだけでなく実際のプログラミングからデバッグまで行えます。

これを機会に、Racket で関数型プログラミング言語を学習してみてはどうでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [The Racket Guide](https://docs.racket-lang.org/guide/)
- [XREPL: eXtended REPL](https://docs.racket-lang.org/xrepl/)
- [Racket 公式ドキュメント](https://docs.racket-lang.org/)
