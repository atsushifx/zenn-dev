---
title: "PowerShell: Powershellの予測機能を使う"
emoji: "🐢"
type: "tech"
topics: ["PowerShell", "予測機能", "intelisense" ]
published: true
---

## tl;dr

- PowerShell 付属の PSReadLineモジュールには、予測機能がある
- 予測機能(Intelisense)を設定して、使い方を解説する

## はじめに

PowerShell に付属している PSReadLineモジュールは、Version 2.2.6 から入力予測機能がつきました。この記事では、PSReadLineモジュールのバージョンを確認して、必要ならバージョンアップする方法と、予測機能の設定方法を解説します。

## PSReadLineモジュールのバージョンアップ

予測機能をつかうには、PSReadLine の Version が 2.2.x 以降である必要があります。
次の手順で、PSReadLine の Version を確認します。

``` PowerShell
> get-module -Name PSReadLine

ModuleType Version    PreRelease Name                      ExportedCommands
---------- -------    ---------- ----                      ----------------
Script     2.2.6                 PSReadLine                Get-PSReadLineKeyHandler, Get-PSReadLineOption, …

>
```

Version が 2.2.x 未満の時は、次の手順で PSReadLine をバージョンアップします。

``` PowerShell
> install-Module -Name PSReadLine -AllowClobber -Force。

>
```

## Intelisenseの設定

Intelisense は、`Get-PSReadLine`コマンドで確認できます。また、`Set-PSReadLine`オプションで設定できます。
下記のようにして、オプションを確認、設定します。

``` PowerShell
> Get-PSReadLineOption | Select-Object -Property *predict*
PredictionSource            : HistoryAndPlugin
PredictionViewStyle         : ListView
InlinePredictionColor       :
ListPredictionColor         :
ListPredictionSelectedColor :

> Set-PSReadLineOption -PredictionViewStyle List

>
```

これらの設定を`$profile`内で指定することで、すべての PowerShell で Intelisense が使用できます。

自分の場合は、次のように設定しています。

| Property | 設定 | 備考 |
| ---| --- | --- |
| PredictionSource | HistoryAndPlugin | 過去の入力履歴および Plugin から補完します |
| PredictionViewStyle | ListView | 候補を一覧形式で表示します |
| InlinePredictionColor | Cyan | 入力文字を Cyan で表示します |

上記の設定は、下記のコードになります。

``` PowerShell : $profile
## input History Plugin
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{ InLinePrediction = [ConsoleColor]::Cyan }

```

## Intelisenseを使う

上記のように設定すると、PowerShell で入力補完ができます。
たとえば、コマンドラインで`cd`と入力したときの画面はつぎのようになります。

``` PowerShell : Windows Terminal
C: /workspaces > cd
> cd .\gitworks\zenn-cli\                                                                  [History]
> cd C:\Users\atsushifx\.local\dotfiles\.settings\powershell\                              [History]
> cd .\zenn-cli\                                                                           [History]
> cd ..                                                                                    [History]
> cd .\hello\                                                                              [History]
> cd .\temp\                                                                               [History]
> cd C:\Users\atsushifx\Documents\powershell\                                              [History]
> cd C:\Users\atsushifx\workspaces\gitworks\zenn-cli\                                      [History]
> cd C:\Users\atsushifx\.local\dotfiles\                                                   [History]
> cd C:\Users\atsushifx\workspaces\                                                        [History]

```

上記のように`path`の一覧が表示されるので、カーソルキーで選んだりインクリメンタルサーチでしぼり込んだりすることで、簡単に行き先`path`が入力できます。

## さいごに

Intelisense 機能のおかげで、History がいっそう使いやすくなりました。また、Intelisense 機能はモジュールで拡張できるので、さらに使いやすくできます。
これを機会に PowerShell を使ってみてください。

それでは、Happy Hacking !!

## 参考資料

- [PSReadLine の予測機能を使用する - PowerShell](https://learn.microsoft.com/ja-jp/powershell/scripting/learn/shell/using-predictors?view=powershell-7.3)
- [窓の杜 : 入力しようとしているコマンドを予測 ～PowerShellで「Predictive IntelliSense」が既定有効に](https://forest.watch.impress.co.jp/docs/news/1420812.html)
