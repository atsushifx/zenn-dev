---
title: "PowerShell: Pesterをインストールする"
emoji: "🧑‍💻"
type: "tech
topics: ["PowerShell", "Pester", "BDD", "ユニットテスト", "チュートリアル" ]
published: false
---

## はじめに

この記事で PowerShell のユニットテストフレームワーク、Pester について解説します。
Pester は BDD(振る舞い駆動開発)を行なうために使用されるユニットテストフレームワークです。本記事では、Pester をインストールする方法と基本的な使い方について説明します。

## Pesterとは

Pester は、PowerShell における BDD のためのフレームワークです。
Pester 自体はユニットテストのフレームワークです。
`It'、`Should`関数から成り立っていて、目的のコードが**どう振る舞うべきか**をテストしていています。

### BDD__(振る舞い駆動開発)__とは

BDD(振る舞い駆動開発)は、TDD(テスト駆動開発)と同じくユニットテストを用いて目的のコードの品質を高める顔初手法です。
BDD における振る舞いは、目的のコードが入力に対してどう振る舞うべきかを示したテストコードです。

### Pesrterで使えるコマンド

Pester では、以下のコマンドが使えます。

| コマンドレット | 意味 | 使用例 |
| --- | --- | --- |
| New-Fixturev | ユニットテストのひな形の作成 | New-Fixture sampleFunc1 |
| Invoke-Pester | ユニットテストの実行 | Invoke-Pester |
|

各コマンドの詳しい説明は、[公式サイト](https://pester.dev/)を参照してください。

## Pesterのインストール

Pester は PowerShell 7 にすでに組み込まれています。
しかし、バージョンが古いため、十分なテストができません。
この記事では、最新の Pester にアップデートする方法を紹介します。

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

上記のように`Version`が`3.x.x`となっている場合は、組み込みずみの Pester が表示されています。

### 最新のPesterのインストール

Pester は[PowerShell Gallery](https://www.powershellgallery.com/)からインストールできます。
以下の手順で、Pester をインストールします。

``` PowerShell : (Admin)
# Install-Module Pester -Scope AllUsers -Force

WARNING: Module 'Pester' version '3.4.0' published by 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US' will be superceded by version '5.4.1' published by 'CN=Jakub Jareš, O=Jakub Jareš, L=Praha, C=CZ'. If you do not trust the new publisher, uninstall the module.

#

```

上記のインストールは、すべてのユーザーに対してインストールするため管理者権限が必要です。
管理者になれない場合は、自分用にインストールします。

``` PowerShell
> Install-Module Pester -Force
WARNING: Module 'Pester' version '3.4.0' published by 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US' will be superceded by version '5.4.1' published by 'CN=Jakub Jareš, O=Jakub Jareš, L=Praha, C=CZ'. If you do not trust the new publisher, uninstall the module.

>
```

再度、バージョンを確認します。

``` PowerShell
C: /workspaces > Get-Module -ListAvailable -Name Pester

    Directory: C:\Users\atsushifx\Documents\PowerShell\Modules

ModuleType Version    PreRelease Name
---------- -------    ---------- ----
Script     5.4.1                 Peste

    Directory: C:\Program Files\WindowsPowerShell\Modules

ModuleType Version    PreRelease Name
---------- -------    ---------- ----
Script     3.4.0                 Pester

>
```

上記のように 2 種類の Versio 番号が表示されていれば、インストールは成功です。

## さいごに

## 参考資料

### 公式

[Pester公式](https://pester.dev/)

### Webサイト

[PowerShell Gallery](https://www.powershellgallery.com/)
