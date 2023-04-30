---
title: "PowerShell: Pesterをインストールする"
emoji: "🧑‍💻"
type: "tech
topics: ["PowerShell", "Pester", "BDD", "ユニットテスト", "チュートリアル" ]
published: false
---

## はじめに

Pester は BDD(振る舞い駆動開発)のために使用されるユニットテストフレームワークです。
この記事では、Pester のインストール方法について説明します。

## 目的

この記事は、Pester のインストール方法を解説したものです。
Pester を使うためには、Pester がまさしくインストールされている必要があります。

この記事では、Pester のバージョンを確認し、最新の Pester をインストールすることを目的とします。
Pester を使った BDD の方法については、別記事で紹介します。

## Pesterとは

Pester は、PowerShell における BDD のためのフレームワークであり、It、Should 関数から成り立っています。
BDD は、TDD(テスト駆動開発)とは違い**コードが望ましい振る舞いをするか**をテストします。

### BDD__(振る舞い駆動開発)__とは

BDD(振る舞い駆動開発)は、TDD(テスト駆動開発)と同じく、コードの品質をユニットテストを用いて高める手法の 1 つです。
BDD では、「コードがどう振る舞うべきか」にフォーカスして、テストコードを作成します。

### Pesrterで使えるコマンドレット

Pester では、以下のコマンドが使えます。

| コマンドレット | 意味 | 使用例 |
| --- | --- | --- |
| New-Fixturev | ユニットテストのひな形の作成 | New-Fixture sampleFunc1 |
| Invoke-Pester | ユニットテストの実行 | Invoke-Pester |
|

各コマンドレットの詳しい説明は、[公式サイト](https://pester.dev/)を参照してください。

## Pesterのインストール

Pester は PowerShell 7 にすでに組み込まれています。
が、バージョンが古いため、最新の Pester にバージョンアップる必要があります。

### Pesterのバージョンチェック

以下の手順で、Pester のバージョンチェックを行います。

``` PowerShell
> Get-Module -ListAvailable -Name Pester

Directory: C:\Program Files\WindowsPowerShell\Modules

ModuleType Version    PreRelease Name
---------- -------    ---------- ----
Script     3.4.0                 Pester

>

```

上記のように`Version`が`3.x.x`となっている場合は、PowerShell に組み込まれている Pester が表示されています。

### 旧Pesterの削除

上記の Pester は使わないので、Windows から削除します。
以下の手順で、旧 Pester を削除します(**なお、管理者権限が必要です**)。

``` PowerShell
> $module = "C:\Program Files\WindowsPowerShell\Modules\Pester"

>takeown /F $module /A /R
 .
 .
 .
成功: ファイル (またはフォルダー): "C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Snippets\ShouldNotThrow.snippets.ps1xml" は現在 Administrators グループによって所有されています。

成功: ファイル (またはフォルダー): "C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Snippets\ShouldThrow.snippets.ps1xml" は現在 Administrators グループによって所有されています。


> icacls $module /reset
処理ファイル: C:\Program Files\WindowsPowerShell\Modules\Pester\
1 個のファイルが正常に処理されました。0 個のファイルを処理できませんでし

> icacls $module /grant "*S-1-5-32-544:F" /inheritance:d /T
 .
 .
 .
処理ファイル: C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Snippets\ShouldNotMatch.snippets.ps1xml
処理ファイル: C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Snippets\ShouldNotThrow.snippets.ps1xml
処理ファイル: C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Snippets\ShouldThrow.snippets.ps1xml
105 個のファイルが正常に処理されました。0 個のファイルを処理できませんでした

> Remove-Item -Path $module -Recurse -Force -Confirm:$false

>
```

以上で、旧 Pester の削除は終了です。
安全のため、一度、ターミナルを終了させます。


### 最新のPesterのインストール

最新の Pester は[PowerShell Gallery](https://www.powershellgallery.com/)からインストールできます。
以下の手順で、Pester をインストールします。

``` PowerShell : (Admin)
# Install-Module Pester -Scope AllUsers -Force

WARNING: Module 'Pester' version '3.4.0' published by 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US' will be superceded by version '5.4.1' published by 'CN=Jakub Jareš, O=Jakub Jareš, L=Praha, C=CZ'. If you do not trust the new publisher, uninstall the module.

#
```

上記のインストールには、管理者権限が必要です。

管理者になれない場合は、以下の手順で自分用にインストールします。

``` PowerShell
> Install-Module Pester -Force
WARNING: Module 'Pester' version '3.4.0' published by 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US' will be superceded by version '5.4.1' published by 'CN=Jakub Jareš, O=Jakub Jareš, L=Praha, C=CZ'. If you do not trust the new publisher, uninstall the module.

>
```

両方の手順で`Warning`が出力されますが、これは公式の Pester と Microsft 組み込みの Pester で Certification が違うためです。無視してかまいません。

再度、バージョンを確認します。

``` PowerShell
C: /workspaces > Get-Module -ListAvailable -Name Pester

    Directory: C:\Users\atsushifx\Documents\PowerShell\Modules

ModuleType Version    PreRelease Name
---------- -------    ---------- ----
Script     5.4.1                 Peste

>
```

上記のように`5.x.x`の Version が表示されていれば、インストールは成功です。

## さいごに

## 参考資料

### 公式

[Pester公式](https://pester.dev/)

### Webサイト

[PowerShell Gallery](https://www.powershellgallery.com/)
