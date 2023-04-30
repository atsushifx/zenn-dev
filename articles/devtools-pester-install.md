---
title: "PowerShell: Pesterをインストールする方法"
emoji: "🚀 "
type: "tech
topics: ["PowerShell", "Pester", "BDD", "ユニットテスト", "インストール" ]
published: false
---

## はじめに

Pester は BDD(振る舞い駆動開発)のために使用されるユニットテストフレームワークです。
この記事では、Pester のインストール方法について紹介します。
Pester の基本的な使い方については、別記事で紹介します。

## Pesterとは

Pester は、PowerShell における BDD のためのフレームワークであり、It、Should 関数から成り立っています。
TDD(テスト駆動開発)とは異なり、BDD は**コードがどのように振る舞うべきか**という視点でをテストします。

## Pesrterで使えるコマンドレット

Pester では、以下のコマンドレットが使えます。

| コマンドレット | 意味 | 使用例 |
| --- | --- | --- |
| New-Fixture | ユニットテストのひな形の作成 | New-Fixture sampleFunc1 |
| Invoke-Pester | ユニットテストの実行 | Invoke-Pester |
|

各コマンドレットの詳しい説明は、[公式サイト](https://pester.dev/)を参照してください。

### Pesterの基本的な使い方

以下のように、コマンドを使って BDD を実践します。

1. テストの作成
  `New-Fixture`コマンドを用いて、コードおよびテストのひな形を作成します。

  ``` PowerShell
  New-Fixture sampleFunc
  ```

2. ファイルの確認
  コード用とテスト用の 2 種類のスクリプトファイルができていることを確認します。

  ``` PowerShell
  sampleFunc.ps1
  sampleFunc.Tests.ps1
  ```

3. テストの実行
  `Invoke-Pester`を実行し、`Fail`が出力されることを確認します。

  ``` PowerShell
  Invoke-Pester
  ```

4. コードの実装
  テストが通るように、コードを実装します。

  ``` PowerShell: samplefunc.ps1
  function sampleFunc {
    return "YOUR_EXPECTED_VALUE"
  }
  ```

5. テストの実行 (2)
  テストを実行し、テストを`pass`することを確認します。

以上で、Pester の基本的な使い方は終了です。

## Pesterのインストール手順

### 前提条件

- PowerShell 7 以降がインストールされていること

### 1. 旧Pesterの削除

以下の手順で、組み込み済みの旧 Pester を削除します。
(**管理者権限でPowerShellを実行する必要があります**)。

``` PowerShell
$module = "C:\Program Files\WindowsPowerShell\Modules\Pester"
takeown /F $module /A /R
icacls $module /reset
icacls $module /grant "*S-1-5-32-544:F" /inheritance:d /T
Remove-Item -Path $module -Recurse -Force -Confirm:$false

```

以上で、旧 Pester の削除は終了です。


### 2. 最新のPesterのインストール

最新の Pester は[PowerShell Gallery](https://www.powershellgallery.com/)からインストールできます。

以下の手順で、Pester をインストールします。

全ユーザー用にインストールする場合は、**管理者権限**で以下のコマンドを実行します。

``` PowerShell
Install-Module Pester -Scope AllUsers -Force
```

管理者になれない場合は、以下の手順で個人ユーザー用に Pester をインストールします。

``` PowerShell
Install-Module Pester -Force
```

どちらの手順でも、`Warning`が出力されます。
これは公式の Pester と Microsft 組み込みの Pester で Certification が違うためです。無視してかまいません。

### 3. Pesterのバージョンチェック

インストール後、Pester のバージョンを確認します。
以下のコマンドで、バージョンを確認します。

``` PowerShell
Get-Module -ListAvailable -Name Pester
```

上記のように`5.x.x`の Version が表示されていれば、インストールは成功です。

## さいごに

この記事では、Pester のインストール方法を紹介しました。
Pester でユニットテストを実行することで、より品質の高いコードを作成できます。

## 技術用語

- TDD__(テスト駆動開発)__: ユニットテストを使ってコードの品質を上げる開発手法
- BDD__(振る舞い\駆動開発)__: **コードの振る舞い**を焦点にした TDD

## 参考資料

### 公式

- [Pester公式サイト](https://pester.dev/)

### Webサイト

- [PowerShell Gallery](https://www.powershellgallery.com/)
