---
title: "エルファたちとはじめる PowerShell 開発日誌: 環境変数マネージャーをTDDで実装する"
emoji: "✨"
type: "tech"
topics: [ "バイブコーディング", "TDD", "PowerShell", "環境変数" ]
published: false
---

## はじめに

## 1. ライブラリの仕様を詰める

- 対象 OS は Windows
- `.env` は使わない
- PowerShell（.NET API）を使う
- TDD で開発（Pester 使用）

### 1.1 対応するスコープ

- Process / User / Machine
- `$env:` と `[Environment]::SetEnvironmentVariable` の違いと選定理由
- 永続／一時の動作比較と制御

### 1.2 ライブラリの機能方針

- Get / Set / Remove の 3 つ
- スコープを安全に指定できるようにする
- クラスベース設計、ただしインスタンス化は不要（static として使う）
- 定数スコープ名を定義し、誤入力を防止する

## 2. 最初のテストとクラスの作成

- Scope 用 enum の設計 (`enum agEnvScope`)
- クラスの基本設計
- static クラスメソッドベースのテスト

### 2.1 TDDの起点: Getメソッドの作成

- "存在しない環境変数を取得したとき null を返す" などのケースからスタート
- 最小限の assert で「守るべき動作」を先に固定
- テスト対象クラス`agEnvManager`を作成

### 2.2 クラスの役割と静的化の理由

- namespace としてのクラス: 関数の衝突を起こさない
- インスタンス不要 (static メソッド形式)
- スコープは定数として導入 (`agEnvScope`使用)

### 2.3 Getを実装した、最低限のクラスの例

### 2.4 Set/Removeも実装したクラスの例

## 3. ラッパー関数の導入とテスト性への配慮

- TDD と static class の不整合およびトレードオフ
- ラッパー関数による現実的な解決策
- ラッパー関数ベースのテストケース

### 3.1 TDD実装時の問題

### 3.2 ラッパー関数による解決

### 3.3 テストとの連携

### 3.4 テストケースサンプル

## 4. パイプ入力対応：PowerShellらしい使い方を実現

### 4.1 PowerShellにおけるパイプ処理の基本

### 4.2 実装: ValueFromPipeline対応

### 4.3 実装コードの例と挙動確認

### 4.4 出力とフィードバック (戻り値/-Verboseの検討)

## 5. 引数チェックと例外処理で安全性を高める

### 5.1 引数チェックと例外による安全性強化

### 5.2 引数チェック(バリデーション)の目的と種類

### 5,3 空文字、$nullの拒否

### 5.4 使用禁止文字リストと正規表現チェック

## 6. 保護された環境変数名の操作を禁止する

### 6.1 なぜ、対策が必要か？

### 6.2 禁止する変数一覧

### 6.3 禁止リストと禁止チェックの実装

## 7. Syncオプションによる即時反映と制御

### 7.1 環境変数のScopeと影響範囲

### 7.2 なぜ、同期が必要か？

### 7.3 同期の実装 (setEnvメソッドの変更)

## 8. テストコードのリファクタリング：Contextで読みやすく

### 8.1 なぜリファクタリングが必要なのか？

### 8.2 修正前のテストコード (抜粋)

### 8.3 修正後のテストコード (抜粋)

## 9. まとめ：設計の全体像と関数の使い方ガイド

### 9.1 記事のまとめ (何を実装したか)

### 9.2 作製した関数のリファレンス

### 9.3 ライブラリの特徴

## おわりに

## 参考資料

### 使用ツール

- PowerShell 7.5.x
- Pester 5.x

#### Webサイト

- [Pester公式ドキュメント](https://pester.dev/):
  PowerShell 用のテストフレームワーク「Pester」の公式サイト。基本構文や Mock の使い方も記載されています。

- [System.Environment クラス (C#)](https://learn.microsoft.com/en-us/dotnet/api/system.environment):
  .NET の `Environment` クラスのドキュメント。環境変数の取得・設定に利用される API の詳細が確認できます。

- [about_Environment_Variables](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.5):
  PowerShell における環境変数の扱い方について解説された公式ドキュメント。スコープの違いや `$env:` の使い方など。

- [aglabo/setup-scripts](https://github.com/atsushifx/aglabo-setup-scripts):
  この記事での開発の成果を収めた GitHub リポジトリ
