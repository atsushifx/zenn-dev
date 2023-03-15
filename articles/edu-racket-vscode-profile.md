---
title: "Education: Racket: `Visual Studio Code`で'Racket'を使う"
emoji: "🎾"
type: "tech"
topics: ["Racket", "環境構築", "勉強", "vscode" ]
published: false
---

## はじめに

`Racket`には、教育用に強力な統合開発環境`DrRacket`があります。
自分は、使いなれたエディタを使いたいので`Visual Studio Code`用に`Racket`用の環境を構築します。

## VS Code の設定

### プロファイルの設定

自分は、"[既定のプロファイルの拡張を最小限にする](devtools-vscode-profile-minimumextensions)"で既定のプロファイルを最小限にしています。
なので、"既定のプロファイル"をもとに"Racket 用のプロファイル"を作成して、プログラミング用、Racket 用の`extension`をインストールします。

### `extension`のインストール

`Racket`用に、次の`extension`をインストールしました。
プログラミング全般で使うものと、`Racket`用の拡張の 2種類をインストールしています。

| extension | 機能 | 備考 |
| --- | --- | --- |
| Better Comments | コメントにアノテーション機能とシンタックスハイライトを追加 | |
| Code Runner | プログラムをコマンドラインで実行する | VS CodeにRacket用のデバッガ拡張がないのので、こっちでRacketプログラムを実行する |
| Magic Racket | Racket用lspを使って、補完機能などを提供する | |
| racket-fmt | `raco fmt`パッケージを使って、racketプログラムをフォーマットする |
| Tabnine AI Autocomplete | AIを使った自動コード補完 | |

### Racket パッケージのインストール

`extension`を動かすには、`racket fmt`などの racket パッケージが必要です。
次の手順で、パッケージをインストールします。

``` Powershell
> raco pkg install racket-langserver
Resolving "racket-langserver" via https://download.racket-lang.org/releases/8.8/catalog/
Resolving "racket-langserver" via https://pkgs.racket-lang.org
Using cached16786990271678699027496 for https://github.com/jeapostrophe/racket-langserver.git
The following uninstalled packages are listed as dependencies of racket-langserver:
   compatibility-lib
   data-lib
   drracket-tool-lib
   gui-lib
   syntax-color-lib
   scribble-lib
   racket-index
   html-parsing
   chk
Would you like to install these dependencies? [Y/n/a/c/?] a
 .
 .

>

```

上記の手順で、つぎのパッケージをインストールします。

| パッケージ | 機能 | 使用する`extension` | 備考 |
| --- | --- | --- | ---|
| racket-langserver | racket 用 lsp | Magic Racket | コード補完 |
| fmt | フォーマッタ | racket-fmt | コードフォーマッタ |

### VS Code 起動前の処理

VS Code を起動する前に、racket-langserver を動かしておく必要があります。
コマンドラインで、次のコマンドを実行します。

``` Powershel
> racket --lib racket-langserver &

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Running       True            localhost            racket racket-langserver

C: /scheme >

>
``` Windows Terminal

racket用lspを起動しておくと、コード補完などの機能が使えます

## さいごに

これで VS Code で`Racket`が使えるようになりました。
Racketを覚えて、一段上のソフトウェアエンジニアを目指しましょう。

それでは、Happy hacking!
