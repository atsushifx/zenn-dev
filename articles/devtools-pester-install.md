---
title: "PowerShell: Pesterのインストール手順"
emoji: "🚀"
type: "tech"
topics: ["PowerShell", "Pester", "BDD", "ユニットテスト", "開発環境" ]
published: false
---

## はじめに

この記事では、BDDスタイルのテストフレームワークである「`Pester`」を導入する方法を紹介します。
PowerShellスクリプト開発において、ユニットテスト[^1]を活用することで、品質の高いスクリプトを開発できます。
以下では、Pester を導入する手順を説明します。

[^1]: ユニットテスト: テスティングフレームワークを利用した単体テスト

## BDDとTDDについて

### TDD __(テスト駆動開発)__

TDD(テスト駆動開発)[^2]は、コードの品質を高めるためにユニットテストを使う開発手法です。目的のコードを書く前にテストを作成することで、テストしやすいコードを作成できます。

### BDD __(振る舞い駆動開発)__

BDD(振る舞い駆動開発)[^3]は、**コードの振る舞い**に重点をおいてユニットテストを行なう手法です。

[^2]: TDD __(テスト駆動開発)__: ユニットテストを使ってコードの品質を高める開発手法
[^3]: BDD __(振る舞い駆動開発)__: コードの振る舞いを焦点にした TDD の一種

## Pesterとは

Pester は、PowerShellスクリプト用のユニットテストを記述するためのフレームワークで、
以下の 3つのコマンドレットを使用することで、BDDスタイルのテストスイートを作成できます。

- Describe
- Context
- It

## Pesterの主要なコマンドレット

Pester にはいくつかのコマンドレットが用意されています。以下は、よく使われるコマンドレットの一部を紹介します。

| コマンドレット | 意味 | 使用例 |
| --- | --- | --- |
| New-Fixture | ユニットテストのひな形の作成 | New-Fixture -Name sampleFunc1 |
| Invoke-Pester | ユニットテストの実行 | Invoke-Pester |
| Describe | ユニットテストのグループ化 | Describe `<スクリプト名>` { <テストケース> } |
| Context | ユニットテストのサブグループ化 |Context `<コンテキスト>` { <テストケース> } |
| It | テストケースの定義 | It "<テストの説明>" { <テスト> } |
| Should | テスト結果のアサーション | `<テストするコード>` &#124 Should -BeTrue |

ユニットテストの例は、以下のとおりです。

``` PowerShell
Describe `<スクリプト名>` {
  Context `<コンテキスト>` {
    It `<テスト名>` {
      `<テストするコード>`| Should -Be `<期待した返り値>`
    }
  }
}
```

各コマンドレットの詳しい説明は、[公式サイト](https://pester.dev/)を参照してください。

## Pesterの基本的な使い方

Pester の基本的な使い方は、以下の通りです。

1. `New-Fixture`を使い、テストのひな形を作成

2. `Describe`,`Context`,`It`を使って、テストコードを実装

3. `Invoke-Pester`を使って、テストを実行

4. 作成したユニットテストをパスするように、目的のコードを実装

5. すべての機能の実装が終わるまで、2-4. を繰り返す

詳細な使い方については、[Pesterの公式サイト](https://pester.dev/)を参照してください。


## Pesterのインストール手順

以下では、最新の Pester v5 をインストールする手順を解説します。

### 1. 組み込み済みPesterの削除

以下の手順で、組み込み済みの旧 Pester を削除します。
(**管理者権限でPowerShellを実行する必要があります**)。

1. 以下のコマンドを実行し、Pester の各ファイルの登録を外す

``` PowerShell
$module = "C:\Program Files\WindowsPowerShell\Modules\Pester"
takeown /F $module /A /R
icacls $module /reset
icacls $module /grant "*S-1-5-32-544:F" /inheritance:d /T
```

2. 以下のコマンドを実行し、Pester の各ファイルを削除する

``` PowerShell
Remove-Item -Path $module -Recurse -Force -Confirm:$false
```

以上で、旧 Pester の削除は終了です。


### 2. 最新のPesterのインストール

以下の手順で、Pester をインストールします。

管理者権限、またはユーザー権限で以下のコマンドを使用し、[PowerShell Gallery](https://www.powershellgallery.com/)から Pester をインストールします。

``` PowerShell
Install-Module Pester -Force -SkipPublisherCheck
```

### 3. Pesterのバージョンチェック

インストール後、Pester のバージョンを確認します。
以下のコマンドで、バージョンを確認します。

``` PowerShell
Get-Module -ListAvailable -Name Pester
```

正しくインストールされていれば、以下のように表示されます。

``` PowerShell
    Directory: C:\Program Files\WindowsPowerShell\Modules

ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
---------- -------    ---------- ----                                --------- ----------------
Script     5.4.1                 Pester                              Desk      {Invoke-Pester, Describe, Context, It…}

```

## おわりに

PowerShellスクリプト開発用の BDDスタイルのテストフレームワーク「`Pester`」のインストール方法を解説しました。
Pester を活用することで、ユニットテストを用いて高品質なスクリプト開発が可能になります。
PowerShell開発において Pester を活用しましょう。

## 参考資料

### 公式

- [Pester公式サイト](https://pester.dev/)
- [Microsoft PowerShell 公式ドキュメント](https://learn.microsoft.com/ja-jp/powershell/)

### Webサイト

- [Pester - GitHub](https://github.com/pester/Pester)
- [PowerShell Gallery](https://www.powershellgallery.com/)
