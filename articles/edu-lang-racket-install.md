---
title: "Education: Racket: 関数型言語'Racket'をインストールする"
emoji: "🎾"
type: "tech"
topics: ["プログラミング言語", "Racket", "環境構築", "勉強" ]
published: true
---

## tl;dr

- winget で`Racket`をインストールする
- 環境変数、path を設定して Windows を再起動する
- `racket`を起動して、動かせるか確かめる

Enjoy

## もっと詳しく

`Racket`は、`scheme(LISP)`から派生したプログラミング言語です。LISP 系なので、 [Paul Graham](http://www.paulgraham.com/)の"[普通のやつらの上を行け](http://practical-scheme.net/trans/beating-the-averages-j.html)"にしたがえば、ぜひ覚えるべきプログラミング言語といえるでしょう。

## Racketのインストール

`Racket'は、winget を使えば簡単にインストールできます。また、インタプリターが内蔵されているのですぐに`Racket`を使うことができます。

### Racketをインストールする

`PowerSHell`のコマンドラインで`winget`を実行します。

``` powershell
> winget install Racket.Racket -i --location c:\lang\racket
見つかりました Racket [Racket.Racket] バージョン 8.8
このアプリケーションは所有者からライセンス供与されます。
Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
インストーラーハッシュが正常に検証されました
パッケージのインストールを開始しています...
インストールが完了しました

>
```

このようにして、`Racket`を`c:\lang\racket`下にインストールします。

なお、`Racket`には`DrRacket`などの各種ツールが含まれていない minimal版があります。
こちらをインストールするには、<https://racket-lang.org> を見てください。

### 環境変数を設定する

つぎに、環境変数や'path'を設定してコマンドラインから`Racket`を使えるようにします。

1. "システムのプロパティ"から"環境変数"ダイアログを開きます。

2. "システム環境変数"に`RACKET_HOME'を追加し、"c:\lang\racket"と設定します。

3. 環境変数"Path"に"%RACKET_HOME%"を追加します。

4. "OK"をクリックして、"環境変数"および"システムのプロパティ"を閉じます。

5. 設定を反映させるため、PC を再起動します。

以上で、コマンドラインから`Racket`を使えるようになります。

## Racketの起動

インストールが終わったら、`Racket`を使ってみましょう。
コマンドラインで`racket`と入力すると、`Racket`が起動します。`,exit`、または Ctrl+D で`Racket`を終了してコマンドラインに戻ります。

``` PowerShell
> racket

Welcome to Racket v8.8 [cs].
> "Hello,World!!"
"Hello,World!!"
> ,exit

>
```

以上で`Racket`が使えるようになりました。

## おわりに

Windows の`Power Shell`で、とりあえず`Racket`が使えるようになるまでをまとめました。
あとは、`Racket`をいろいろと触っていけばいいでしょう。

それでは、Happy Hacking!
