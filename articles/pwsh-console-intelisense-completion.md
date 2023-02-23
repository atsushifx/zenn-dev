---
title: "PowerShell: Powershellのintelisenseで補完機能を使う"
emoji: "🐢"
type: "tech"
topics: ["PowerShell", "予測機能", "intelisense","補完" ]
published: true
---

## tl;dr

- PowerShell の Intelisense は、プラグインモジュールで機能拡張できる
- `CompletionPredictor`モジュールは、tab補完機能を追加する
- 実際に、`CompletionPredictor'モジュールを使ってみた

## はじめに

PowerShell の intelisense は、さまざまなプラグインモジュールで機能を拡張できます。
'CompletionPredictor'モジュールは、 PowerShell の補完機能を Intelisense に実装します。

`CompletionPredictor'の実行例は、つぎのようになります。

``` PowerShell
C: > cd ~/D
> cd C:\Users\atsushifx\Desktop                                                         [Completion]
> cd C:\Users\atsushifx\Documents                                                       [Completion]
> cd C:\Users\atsushifx\Downloads                                                       [Completion]

```

このように、コマンドラインの下に Path の候補が表示され、カーソルキーで選択できます。もちろん、キー入力による絞り込みも可能です。

## `CompletionPredictor`プラグインのインストール

`CompletionPredictor`モジュールは、モジュール配布サイト [PowerShell Gallery](https://www.powershellgallery.com/)で配布されています。次の手順で、`Completion1@redictor'モジュールをインストールします。

1.　コマンドラインで`Install-Module`を実行する

``` PowerShell
> Install-Module -Name CompletionPredictor -Repository PSGallery -force
   
>
```

2.　`Import-Module`を $profile に追加する

``` PowerShell: $profile
.
.
### Modules
Import-Module -Name CompletionPredictor

```

3.　PowerShell を再起動する

以上で、`CompletionPredictor`モジュールのインストールは終了です。

## `CompletionPredictor`を使う

`CompletionPrredictor`が正常にインストールできていれば、候補の一覧に補完によるものが表示されます。
たとえば、次の画面のように右に[Completion]が表示されている候補は`CompletionPredicor`によるものです。

``` PowerShell
C: > cd ~/.
> cd C:\Users\atsushifx\.config                                                         [Completion]
> cd C:\Users\atsushifx\.dotnet                                                         [Completion]
> cd C:\Users\atsushifx\.local                                                          [Completion]
> cd C:\Users\atsushifx\.vscode                                                         [Completion]

```

また、[F2]キーで ListView / InlineView を切り替えられます。
InlineView では、カーソル位置に候補が順番に表示されます。

## おわりに

上記のように、`CompletiobPredictor`モジュールを使うことで補完機能を使えるようになりました。
パスを一覧から選べるようになるなど、PowerShell の入力がもっと便利になりました。

それでは、Happy Hacking!

## 参考資料

- [CompletionPredictor - GitHub](https://github.com/PowerShell/CompletionPredictor)
