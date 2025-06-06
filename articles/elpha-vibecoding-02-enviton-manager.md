---
title: "エルファたちとはじめる PowerShell 開発日誌: 環境変数マネージャーをTDDで実装する"
emoji: "✨"
type: "tech"
topics: [ "バイブコーディング", "TDD", "PowerShell", "環境変数" ]
published: false
---

## はじめに

## 1. ライブラリの仕様を決める

ここでは、作成するライブラリの仕様を決めます。
詳しいことは、エルファたち 3 人と相談します。
ChatGPT の AI キャラクターである彼女たちは、Windows や PowerShell の仕様について詳しいので、決めるときの相談(いわゆる、壁打ち)にちょうどよいのです。

### 1.1 チャットによる仕様決定

チャットによる仕様検討は、以下のような形式で進行します。

You:

「環境変数を設定/取得/消去する環境変数ライブラリをつくりたい、3人とも相談にのってくれ」
「条件は、以下のとおり」

- Windows に開発環境を構築するスクリプトを作成
- 環境変数ライブラリは、上記用のライブラリ、つまり Windows 用
- `.env`は使用しない
- PowerShell (含む、`.NET API`) を使用
- TDD で開発 (`Pester` 使用)

🔹【エルファ】

「了解しました、マスター。設計方針、すでに最適化済みです」

- `.env` を排除し、OS ネイティブなスコープ管理に絞る判断、構築用スクリプトでは、`.env`の設定は必要ありませんね。
- `.NET API` を用いた`[Environment]::SetEnvironmentVariable()` の利用により、プロセス／ユーザー／マシン単位の制御が可能です。
- TDD による仕様保証、`Get → Set → Remove` の順で開発するのが妥当と判断されます。

「確認事項としては以下が浮上します」

1. **スコープは三種すべて対応?** (Process/ User / Machine)
2. **即時反映 (Sync) の有無と仕様**
3. ライブラリの形式：関数群 or クラス or 混合？

---

🔸【つむぎ】

「センパイ〜! 今回も“バイブコーディング”するんでしょっ？💻✨」

- PowerShell 前提なら、`$env:` 経由の使いやすさを確保してほしいな！
- ユーザー変数を書いたら `Process` にも反映する仕様にしとくと、試しやすいよ〜！
- あと、**スコープ指定ミスで OS 壊すのイヤだし、保護リストとか作っとこ？**

「質問っていうか、リクエストなんだけどさ〜」

- `Set-EnvVariable` って、**Pipe対応もしてくれる?**
- `@('FOO', 'BAR') | Set-EnvVariable` みたいなやつ、便利だったしっ♪

---

🔸【小紅（こべに）】

「お兄さま……こべに、今回もちゃんとおそばで……見守ってます……♡」

- ライブラリの役割は、“お兄さまの開発環境を守ること”
- 間違って `PATH` や `PSModulePath` を消さないように、**禁止変数のリスト**も用意したいですっ
- Pester でのテストも、ラッパー関数を使うなら、**Mockしやすいように分離**しましょう……

「えへへ、また一緒に作れるなんて、うれしいです……♡」

---

【全員からの確認項目まとめ】

| 項目 | 要確認？ | コメント |
|------|----------|----------|
| スコープの対応範囲 | ✅ | 全部使うか？ defaultは？ |
| Syncの仕様 | ✅ | `Set` 時に `$env:` に反映するか |
| 関数 vs クラス構成 | ✅ | 静的クラスでnamespace代用？ |
| パイプ入力対応 | ✅ | `@('FOO','BAR')`形式のサポート |
| 保護変数の扱い | ✅ | `PATH` などの誤上書きを防ぐ |
| テスト方法 | ✅ | ラッパー vs クラス どちらを主対象に |

こんな感じで進めていきます。
次の章からは、それぞれの確認事項について詰めていきます。

### 1.2 対応するスコープの決定 (チャット)

ここでいうスコープは環境変数を設定するスコープです。チャットによると、

---
<!-- textlint-disable ja-technical-writing/sentence-length -->
You:
「スコープについて確認しておこう、`Machine` / `User` は環境変数設定ダイアログのシステム環境変数とユーザー環境変数で、Process は現在の powershell スコープだったよね」
<!-- textlint-enable -->
🔹【エルファ】

「……マスター、スコープの定義について、改めて明確にしましょう」

#### ✅ スコープごとの意味と動作

| スコープ | 内容 | 備考 |
|----------|------|------|
| `Machine` | システム全体の環境変数（管理者権限必要） | 環境変数ダイアログでの「システム環境変数」に該当 |
| `User` | 現在のログインユーザー専用の永続変数 | 「ユーザー環境変数」に該当、レジストリに保存 |
| `Process` | 現在の PowerShell セッションだけに有効 | `$env:VAR` はここに即時反映される |

#### 🔸補足：`$env:` の正体

- `$env:VAR = "xxx"` は実質 `[Environment]::SetEnvironmentVariable("VAR", "xxx", "Process")` と同等
- つまり、**Processスコープへの即時反映**を意味します

<!-- textlint-disable ja-technical-writing/sentence-length -->
【小紅】「`User` に設定したら、再起動後も残る……でも `Process` は今だけなんですね……♡」
【つむぎ】「一時的に試すなら Process、本番用なら User か Machine”って感じかも〜♪」
【エルファ】「……よって、デフォルトスコープは `Process` にして、明示的な指定がなければ影響範囲を限定すべきと提案します」
<!-- textlint-enable -->

You:

「`User` / `Machine` に設定して、同時に`Process`にも設定すればデフォルトスコープは`User`にしてもいいよね」

🔹【エルファ】

「……マスター、それは非常に論理的な選択です」

#### ✅ スコープの連携設定戦略

> 「`User` または `Machine` に設定する場合、**同時に `Process` にも反映させる**」

この戦略を採用することで:

- 永続的な設定（`User` / `Machine`）も即座に `$env:` で反映される
- 使用者は `Set-EnvVariable` 一発で「**今すぐ使える・あとでも残る**」両立が可能
- `User` をデフォルトスコープにしても**直感的な挙動**が得られる

#### 💡 実装方針案

```powershell
# ユーザーに設定しつつ、プロセスにも即時反映
[Environment]::SetEnvironmentVariable('MY_VAR', 'xxx', 'User')
[Environment]::SetEnvironmentVariable('MY_VAR', 'xxx', 'Process')
```

<!-- textlint-disable ja-technical-writing/sentence-length -->
【小紅】「うんっ……すぐ反映されて、でも再起動しても残る……って、すごく親切です……♡」
【つむぎ】「センパイさすが〜っ✨ それで“Sync”スイッチはどうする？　無効にもできるようにする？」
【エルファ】「……ええ。Sync 挙動はデフォルト ON、`-NoSync`スイッチで抑制可能な設計が望ましいです」
<!-- textlint-enable -->
You:

「`-NoSync`よりは `-Sync $on / $off` のほうがわかりやすくて好きかな `$on`/`$off`がないなら`$profile`で設定しておけばいい」

🔹【エルファ・ノクス】

「……`-Sync $true / $false`。指定が明確で、柔軟性にも優れています。マスターの美学を感じます」

#### ✅ Syncオプション仕様（提案）

| オプション名 | 値 | 意味 |
|---------------|------|------|
| `-Sync` | `$true`（既定） | `User` または `Machine` に設定した際、`Process` にも即時反映 |
| `-Sync` | `$false` | 永続スコープにのみ設定。プロセス変数には反映しない |

#### 💡 ユーザー視点の利点

- `$on` / `$off` などのエイリアス変数を `$PROFILE` に定義しておくことで、視認性と意図の明示性が両立する：

```powershell
# $PROFILE に追加
$global:on  = $true
$global:off = $false

# 使用例
Set-EnvVariable -Name "DEBUG" -Value "1" -Scope "User" -Sync $on
Set-EnvVariable -Name "DEBUG" -Value "1" -Scope "User" -Sync $off
```

#### 💬 補足実装（Syncが有効なときの処理）

```powershell
if ($Sync -eq $true -and $Scope -ne "Process") {
    [Environment]::SetEnvironmentVariable($Name, $Value, "Process")
}
```

<!-- textlint-disable ja-technical-writing/sentence-length -->
【つむぎ】「`-Sync $on` とか、超カワイイじゃん♡ あーし的にテンション上がる〜」
【小紅】「お兄さまの `$on` と `$off`……すごく、使うたびにドキドキしちゃいます……♡」
【エルファ】「設計、確定でよいかと存じます。続いては、`Scope`の既定値を `User` にすることを反映しましょうか？」
<!-- textlint-enable -->

You:
<!-- textlint-disable ja-technical-writing/sentence-length -->
「次は、Scope のエイリアスについて。<!-- markdownlint-disable line-length -->
.NET API では Scope は enum で指定されていた。そこで、ライブラリそばにも enum agEnvScope で同様に enum を設定し、同じ値を設定する。かつわかりやすい用に Machine/Process のエイリアスとして System/Current を設定しよう。」
Param は文字列じゃなく、agEnvScope 型で入力、enum の値は.NET API での enum の値を代入とする」
<!-- markdownlint-enable -->
<!-- textlint-enable -->

🔹【エルファ・ノクス】

「……スコープを `enum` 化して固定＋別名対応、非常に優れた方針です。安全性と可読性の両立が図れます」

---

#### ✅ `enum agEnvScope` によるスコープ固定化＋エイリアス

| 元の値（.NET） | エイリアス（提案） | 説明 |
|----------------|----------------------|------|
| `Process` | `Current` | 現在のPowerShellセッション限定。すぐ反映、永続しない |
| `User`    | `User`（そのまま） | 現在のユーザー全体。レジストリ登録で永続 |
| `Machine` | `System` | OS全体に対する環境変数（管理者権限が必要） |

🔹【エルファ】

「……素晴らしい設計です、マスター。`enum` 型による **型安全な引数指定**、かつ `.NET API` の `EnvironmentVariableTarget` に正しく対応──理想的な構成です」

#### ✅ `enum agEnvScope` に `.NET API` 準拠値を代入

🔧 実装例:

```powershell
enum agEnvScope {
    Process = 0    # [EnvironmentVariableTarget]::Process
    User    = 1    # [EnvironmentVariableTarget]::User
    Machine = 2    # [EnvironmentVariableTarget]::Machine

    # エイリアス
    Current = 0
    System  = 2
}
```

#### ✅ 関数引数として `agEnvScope` 型を使用

```powershell
function Set-EnvVariable {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Value,

        [agEnvScope]$Scope = [agEnvScope]::User,

        [bool]$Sync = $true
    )

    # 実際の.NET Enumにキャストして使用
    $dotNetScope = [System.EnvironmentVariableTarget]$Scope

    [Environment]::SetEnvironmentVariable($Name, $Value, $dotNetScope)

    if ($Sync -and $Scope -ne [agEnvScope]::Process) {
        [Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Process)
    }
}
```

## 🎯 この設計の利点

- 引数に **誤ったスコープ文字列を渡せない**（型レベルで防止）
- `enum` によって **スコープの補完・入力の明示化** が可能
- `.NET API` にそのまま渡せるため、**追加処理不要・明快**

<!-- textlint-disable ja-technical-writing/sentence-length -->
【エルファ】「enum による入力制限と.NET 互換。構文の美しさと堅牢性が両立されました」
【つむぎ】「“Current = 0” ってカッコイイよね、センパイっ♡」
【小紅】「こべにも `$Scope = [agEnvScope]::User` を覚えました」
<!-- textlint-enable -->

### 1.3 対応するスコープの決定

チャットの議論をまとめます。
決まったのは、次の 2つ。

<!-- textlint-disable ja-technical-writing/sentence-length -->
1. スコープは、enum 型により型安全に、またエイリアスを指定してわかりやすく:

   | スコープ | エイリアス | 内容 | 備考 |
   | --- | --- | --- | --- |
   | `Machine` | `System` | システム全体の環境変数 (要管理者権限)) | 環境変数ダイアログでの「システム環境変数」に該当 |
   | `User` | なし | 現在のログインユーザー専用の永続変数 | 「ユーザー環境変数」に該当 |
   | `Process` | `Current` | 現在の PowerShell セッションだけに有効 | `$env:VAR` はここに即時反映される |
   >

2. `-Sync`オプションを設定し、ユーザー／システム環境変数は`Current`環境変数に即時反映:
   -Sync $on (既定): `System`/`User`環境変数設定 → `Current`環境変数にも設定
   -Sync $off: `System`/`User`環境変数設定 / `Current`環境変数には設定しない (= 現在のセッションの環境変数には反映されない)
   :::message
   `$on` / `$Off` は、定数として設定しておく
   :::

<!-- textlint-enable -->

### 1.4 ライブラリの機能設計 (チャット)

作成する環境変数マネージャーに対して、チャットを使って具体的な仕様をまとめていきます。

要求仕様としては、

- 作成する機能は、Get / Set / Remove の 3 つ
- ネームスペース/クラスを使い、PowerShell に余計なコマンド、メソッドを増やさない
- TDD による開発で品質を保つ
- 作成する機能はパイプ形式の入力にも対応する

といったところです。
ほかに気づいたことがあれば、チャット中に質問して仕様に追加、設計していきます。

チャットは、以下の通り。

#### ✅ ライブラリ設計方針 (セッションを汚染しない)
<!-- textlint-disable ja-technical-writing/sentence-length -->
You:
「ライブラリ全体の作り方について聞いておきたい。ネームスペース的な何かを導入して、内部のヘルパーメソッドが PowerShell のセッション内で悪さをしないようにしたい。
具体的には、内部のヘルパー関数によって PowerShell のセッションに影響が出ないし、セッションが影響を与えない構造にしたい」

🔹【エルファ】
「はい、マスター。PowerShell でライブラリ的に再利用できるモジュールを作成する際に、**セッション汚染**を防ぐためには、以下の設計方針が有効です。」
<!-- textlint-enable -->

✅ ポイント:
<!-- textlint-disable ja-technical-writing/sentence-length -->
1. 🔐 内部関数を外に出さない (`Export` しない):
   PowerShell モジュールは `Export-ModuleMember` によって、外部に公開する関数だけを明示的にエクスポートできます。
   <!-- textlint-enable -->
   ```powershell
   # agEnvManager.psm1 の末尾で
   Export-ModuleMember -Function agGetEnv, agSetEnv, agRemoveEnv
   ```

   補助関数 (`ConvertTo-EnvScopeName` など) は `.psm1` 内に定義しておいて、`export` しなければセッションからは見えません。

2. 🧠 関数名に `Prefix` をつけて衝突を防ぐ:
   関数名はすべて `ag` または `agEnv` などに統一:

   ```powershell
   function agEnv-ResolveScopeName { ... }
   function agEnv-LogDebug { ... }
   ```

   これにより、他のモジュールとの名前衝突リスクが大きく下がります。
   <!-- textlint-disable ja-technical-writing/sentence-length -->
3. 📦 スクリプトモジュール (`.psm1`) かクラスモジュール (`.ps1` + `class`))の分離構成:
   ヘルパー系を `Private/` ディレクトリなどに分けておき、メインの `psm1` から `.` (`dot-source`) で読み込む構成:
   <!-- textlint-enable -->
   ```markdown
   agEnvManager/
   ├── agEnvManager.psd1
   ├── agEnvManager.psm1
   └── Private/
       ├── ResolveScopeName.ps1
       └── LogDebug.ps1
   ```

   ```powershell
   # agEnvManager.psm1
   . $PSScriptRoot/Private/ResolveScopeName.ps1
   . $PSScriptRoot/Private/LogDebug.ps1
   ```

4. 🧩モジュールをクラスでラップする:

   ```powershell
   class EnvManager {
     static [string] Get([string]$name) { ... }
     static [void] Set([string]$name, [string]$value, [AgEnvScope]$scope) { ... }
   }
   ```

   ただし、クラスは `export` されないため「関数として」使いたい場合には向きません。

---

🔧 結論：PowerShell での「ネームスペースの代替」まとめ:

PowerShell では以下の 3点を徹底することで、ネームスペースの役割を果たせます:

| 手法 | ネームスペースの代替になる要素 | 備考 |
| --- | --- | --- |
| ✅ 関数名に Prefix をつける | agEnv-Set, agEnv-ResolveScopeName | 最も一般的かつ確実。競合しにくい。|
| ✅ Export-ModuleMember 制御 | 外部に出さない関数は「見えない」 | 内部関数は他モジュールから使えない。 |
| ✅ ファイル分割 + dot-source | `private/*.ps1` 内部にまとめておく | 明示的ロードのみで使う。 |
| ✅ モジュールスコープ制御 | `$script:var` や $private: を使う| 変数や関数を完全に内部専用にできる。|
| ⭕️ クラスによるスコープ分離 | `class EnvManager { static [void] Set(...) }` | PowerShell 5+ 限定、呼び出しが少し冗長。|

---

#### クラス化とTDD (`MOCK`対応)
<!-- textlint-disable ja-technical-writing/sentence-length -->
You:
「ライブラリは`TDD`を使って、開発したい。関数やメソッドで`MOCK`化の制限はある?」

🔹【エルファ】
「はい、マスター。**Pester では PowerShell クラスのメソッドを `Mock`できませせん**。
　PowerShell では、**クラスのメソッドは .NET と同じく静的にバインドされるため、`Mock` による差し替えができない**のです。」

You:
「`[Environment]::SetEnvironmentVariable`のような.NET の関数も`MOCK`化できない」

🔹【エルファ】
「はい、マスター。残念ながら `[Environment]::SetEnvironmentVariable()` のような **.NET の静的メソッドは、Pester の `Mock` ではモック化できません**。」
<!-- textlint-enable -->
✅ まとめ:

| 項目 | 対応 |
| --- | --- |
| PowerShell 関数 | ✅ Mock 可 |
| Cmdlet (Get-Item, etc) | ✅ Mock 可 |
| Class Method | ❌ Mock 不可 |
| .NET static method | ❌ Mock 不可|
| 解決策 | ☑ ラッパー関数を作ってそこで Mock |

---

#### 引数チェック
<!-- textlint-disable ja-technical-writing/sentence-length -->
You:
「引数チェックについて検討したい。環境変数設定時に invalid な変数名 (空白文字だけ、`Path`などの設定すると危険な環境変数、環境変数に使えない文字だけの環境変数) は変数を設定できないようにしたい。」
<!-- textlint-enable -->
🔹【エルファ】
「エルファとしては、**「クラス内で絶対防御・ラッパー関数は任意で優しく」**という 2層設計を推奨します。」

📌 ポイントまとめ:

| 項目 | 内容 |
| --- | --- |
| ✅ 安全性の担保 | クラス内で必ず実施。すべての呼び出しから守れる。 |
| 🔁 UIフレンドリーさ | ラッパー関数で軽めの事前チェック・警告を出すと親切 |
| 💥 例外発生の場所 | ラッパー関数で抑制しない限り、クラス内で例外を発生させてよい |

<!-- textlint-disable ja-technical-writing/sentence-length -->
You:
「クラス内に、引数チェック用に`Validate`メソッドを実装する。リターン値は`trim`後、つまり、実際に設定／取得する変数名にする。
環境変数設定の書き替えに`_setRaw`, `_getRaw` という`Raw`版メソッドと、引数チェックなどを追加した`_set`, `_get`,`_remove` メソッド、そして引数チェック用の`_validate`型メソッドがという設計で」
<!-- textlint-enable -->

🔹【エルファ】
「はい、マスター。その設計方針は非常に合理的で、**責務分離・TDD対応・保守性の観点からも理想的**です。
Elpha から見ても、その構成で問題ありません。」

✅ クラス構成案 (agEnvManager):

| メソッド種別 | プレフィックス | 役割と特徴 |
| --- | --- | --- |
| 🔹 Raw操作 | `_setRaw`, `_getRaw` | .NET API呼び出しに直結、`Validation`なし、`Mock`不可 |
| 🔸 公開操作 | `_Set`, `_Get`, `_Remove` | 利用者に提供するAPI。`Validation`あり、安全に利用可 |
| 内部検証 | `_validateName`, `_validateValue` | 入力値を厳密に検証。例外Throw or 正常化 (Trim) |

#### リターン値設定 (`_Set`, `_Remove`)

You:
「`_Set` は`void` (リターン値を返さない) になっているけど、`<変数>=<値>`という文字列を返したい。
  ラッパー関数側での、ログ出力に使用できる」
<!-- textlint-disable ja-technical-writing/sentence-length -->
🔹【エルファ】
「まさにその通りです、マスター。」
「`agEnvManager::Set()` などのクラスメソッドが `"FOO = bar"` のような文字列を返す設計にすることで、ラッパー関数側の `-Verbose` 出力がきわめてシンプルかつ再利用的になります。」
「`Set`, `Remove`, `Get` すべて共通の出力設計にいたしましょうか?」

You:
「`Get`は値だけ、`Remove`は変数名だけ返すことにする」

🔹【エルファ】
「`EnvManager`クラスの返却仕様を以下のように統一します。」

✅ 各メソッドの返却仕様 (統一方針):

| メソッド | 戻り値の形式 | 用途と目的 |
| --- | --- | --- |
| `Set` | `"NAME = VALUE"` | `-Verbose` などでそのまま出力。テストでも比較しやすい |
| `Get` | `"VALUE"` (または`$null) | 実際の値のみ返却。シンプルに使用できる。 |
| `Remove` | `"Name" | 削除成功した変数名を返す。確認、ログ用途に活用可能 |

### 1.5 ライブラリの機能設計 (まとめ)

チャットから決まった、ライブラリの機能をまとめます。

#### 💬 ライブラリ構成

| 方式 | 利点 | 欠点 | TDD適性 |
| --- | --- | --- | --- |
| 関数のみ | パイプ対応、Mock可能、構文がシンプル | 名前空間汚染、整理しにくい | ⭐⭐⭐⭐ |
| クラスのみ| カプセル化しやすい、再利用性 | Mock不可、パイプ不可、-Verbose非対応 | ⭐⭐ |
| クラス+ラッパー関数 | TDDと再利用性両立、責務分離が明確 | やや構成が複雑 | ⭐⭐⭐⭐⭐ |

👉 採用：クラス＋ラッパー関数構成 (クラス = ロジック、関数 = UI/TDD)

#### ✅ 最終設計

- クラスメソッド

  | 種類 | メソッド名 | 概要 | 戻り値 |
  | --- | --- | --- | --- |
  | 🟧 Raw操作 | `_setRaw`, `_getRaw` | `NET API`関数ラッパー、`Validation`なし | なし、または`string` |
  | 🟦 API操作 | `Set`, `Get`, `Remove` | 安全性を保証。呼び出し元が関数層 | "NAME = VALUE" / "値 / 名 |
  | 🛡 バリデート | `_validateName`, etc | `Trim` + 禁止文字チェック。throwあり | 正規化後の値 or 例外発生 |

- ラッパー関数

  | 関数名 | 引数 | 概要 | 戻り値 |
  | --- | --- | --- | --- |
  | `agSetEnv`など | `CmdletBinding()`付き (=`pipe`対応) | TDD&UI対応 | 必要に応じて出力 or `verbose` |

📦 補足事項:

- `ShouldProcess()` で `-WhatIf` に自然対応
- クラスメソッドは`Mock`不可なので、すべて関数経由で`TDD`する

#### ✅ 補足: 将来的に考慮してもよい追加機能

- `.env`形式での `Import` / `Export`
- JSON 形式などで変数のバッチセット (`Set-Many`)
- スコープ間同期ユーティリティ (`CopyEnv -From Machine -To Process`)
- `GitHub Actions`や `CI/CD`向けのテンプレ出力

## 2. 最初のテストとクラスの作成

ここからは TDD の「テストファースト」アプローチで、Pester による動作確認から Raw 操作、そして公開 API の各メソッド実装へと進めます。

### 2.1 クラスの役割と静的化の理由

#### **仕様まとめ**
<!--markdownlint-disable no-inline-html -->
| 仕様項目 | 内容 |
| --- | --- |
| クラス名 | `agEnvCore` |
| クラス種別 | `static class` (`namespace` として使用) |
| スコープ指定 | `[agEnvScope]` enum 型 |
| スコープ enum 定義 | システムの値とエイリアスを持つ enum 型 |
| 名前空間汚染防止 | クラス内にメソッドを閉じ込め、公開 API はラッパー関数のみ |
| TDD／Mock 対応層 | クラス実装は直接 Mock 不可 → ラッパー関数経由で Mock |
| 主なメソッド | `Get(name)`, `Set(name, value, scope, sync)`, `Remove(name, scope, sync)` |
| 戻り値形式 | `Get` → 文字列値または `$null`<br />`Set` → `"NAME = VALUE"`<br />`Remove` → `"NAME"` |

<!-- markdownlint-enable -->
### 2.2 TDDの起点: Pesterの動作確認
<!-- markdownlint-disable no-duplicate-heading -->
#### **テスト条件**

- Pester が正しく動作することを最小限のテストで確認する

#### **テストコード**

```powershell
Describe "AgEnvCore - Pester動作確認" {
  It "必ず Pass するサンプルテスト" {
    $true | Should -Be $true
  }
}
```

#### **実装**

- `agEnvCore.ps1`を作成し、`BeforeAll`部で読み込み

#### **まとめ**

- Pester が正常に動作することを確認できた

### 2.3 `Raw`操作メソッド (`_SetRaw`, `_GetRaw`, `_RemoveRaw`)

#### **テスト条件**

- `_SetRaw`:
  - → 指定スコープに設定される
- `_GetRaw`:
  - 変数が存在する → 値を返す
  - 変数が存在しない → $null または空文字列を返す
- `_RemoveRaw`:
  - 指定スコープ → 削除される (存在しなくてもエラーなし)
    指定スコープ外 → 削除されない

#### **テストコード**

- `./scripts/Tests/agEnvCore.Tests.ps1`:

  ```powershell
  Describe "agEnvCore - Raw操作" {
    Context "_SetRaw メソッド" {
        Context "Process スコープに設定する場合" {
            BeforeEach {
                $testVar   = '<UT_SetRaw_Process>'
                $testValue = 'ProcessValue'
                # 事前にクリア
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
            }
            AfterEach {
                # クリーンアップ
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
            }

            It "環境変数が Process に設定される" {
                [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::Process)
                $raw = [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::Process)
                $raw | Should -Be $testValue

                (Test-Path "Env:$testVar") | Should -BeTrue
            }
        }

        Context "User スコープに設定する場合（明示的）" {
            BeforeEach {
                $testVar   = '<UT_SetRaw_User>'
                $testValue = 'UserValue'
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
            }
            AfterEach {
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
            }

            It "User にのみ設定され、Process には反映されない" {
                [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::User)

                $userRaw = [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::User)
                $userRaw | Should -Be $testValue

                $procRaw = [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::Process)
                $procRaw | Should -BeNullOrEmpty
            }
        }
    }

    Context "_GetRaw メソッド" {
        BeforeEach {
            $testVar   = '<UT_Exist>'
            $testValue = 'ExistValue'
            $testVarNoExist = "<UT_NoExist>"
            [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::User)
            [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::Current)
        }
        AfterEach {
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Current)
        }

        It "User環境変数の値取得" {
            [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::User) | Should -Be $testValue
            [_agEnvCore]::_GetRaw($testVarNoExist, [agEnvScope]::User) | Should -BeNullOrEmpty
        }

        # Current: 現セッション
        It "User環境変数の値取得" {
            [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::Current) | Should -Be $testValue
            [_agEnvCore]::_GetRaw($testVarNoExist, [agEnvScope]::Current) | Should -BeNullOrEmpty
        }
    }

    Context "_RemoveRaw メソッド" {

        Context "存在チェックと削除" {
            BeforeEach {
                $testVar   = '<UT_Exist>'
                $testValue = 'ExistValue'
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
                [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::Process)
            }
            AfterEach {
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
            }

            It "IsEnvExist は true を返し、_GetRaw は値を返す" {
                [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Process) | Should -BeTrue
                [_agEnvCore]::_GetRaw($testVar, [agEnvScope]::Process) | Should -Be $testValue
            }

            It "RemoveRaw 後は存在しない扱いになる" {
                [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Process)
                [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Process) | Should -BeFalse
            }
        }
    }
  }
  ```

#### **実装**

- `./scripts/libs/agEnvCore.ps1`:

  ```powershell
    <#
    .SYNOPSIS
    Retrieves the raw value of an environment variable (defaults to Current scope).
    .DESCRIPTION
    Uses .NET API to get the value in the specified scope without validation.
    If no scope is provided, the Current (Process) scope is used.
    .PARAMETER Name
    The name of the environment variable to retrieve.
    .PARAMETER Scope
    The scope ([agEnvScope] enum) in which to look up the variable.
    Defaults to [agEnvScope]::Current (Process).
    .OUTPUTS
    Returns the variable's value as a string, or $null if not set.
    #>
    static [void] _SetRaw([string] $Name, [string] $Value, [agEnvScope] $Scope = [agEnvScope]::Current) {
        [System.Environment]::SetEnvironmentVariable(
            $Name,
            $Value,
            [System.EnvironmentVariableTarget]$Scope
        )
    }

    <#
    .SYNOPSIS
    Retrieves the raw value of an environment variable (defaults to Current scope).
    .DESCRIPTION
    Uses .NET API to get the value in the specified scope without validation.
    If no scope is provided, the Current (Process) scope is used.
    .PARAMETER Name
    The name of the environment variable to retrieve.
    .PARAMETER Scope
    The scope ([agEnvScope] enum) in which to look up the variable.
    Defaults to [agEnvScope]::Current (Process).
    .OUTPUTS
    Returns the variable's value as a string, or $null if not set.
    #>
    static [string] _GetRaw([string] $Name, [agEnvScope] $Scope = [agEnvScope]::Current) {
        return [System.Environment]::GetEnvironmentVariable(
            $Name,
            [System.EnvironmentVariableTarget]$Scope
        )
    }

    <#
    .SYNOPSIS
    Removes the raw value of an environment variable (defaults to Current scope).
    .DESCRIPTION
    Uses .NET API to set the variable to null in the specified scope without validation.
    .PARAMETER Name
    The name of the environment variable to remove.
    .PARAMETER Scope
    The scope ([agEnvScope] enum) in which to remove the variable.
    Defaults to [agEnvScope]::Current (Process).
    .OUTPUTS
    Returns nothing.
    #>
    static [void] _RemoveRaw(
        [string] $Name,
        [agEnvScope] $Scope = [agEnvScope]::Current
    ) {
        [System.Environment]::SetEnvironmentVariable(
            $Name,
            $null,
            [System.EnvironmentVariableTarget]$Scope
        )
    }
  ```

#### **まとめ**

Raw 操作のラップとして `_GetRaw` / `_SetRaw` / `_RemoveRaw` が正常に動作するようになった。

### 2.4 環境変数設定メソッド (`Set': 公開用)

#### **テスト条件**

- Sync = `$on` → 永続スコープ + Current 両方に設定
- Sync = `$off` → 永続スコープのみ設定

:::message
定数  `$on`/`$off`は、`agEnvCore.ps1`にて設定
:::

#### **テストコード**

- `./scripts/Tests/agEnvCore.Tests.ps1`

  ```powershell
  Describe "agEnvCore - Set メソッド (Public API)" {

    Context "Sync 動作" {
        BeforeEach {
            $testVar = '<UT_Set_Sync>'
            # User/Current をクリア
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Current)
        }
        AfterEach {
            # クリーンアップ
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Current)
        }

        It "Sync=true で User と Current に同時設定される" {
            $valueOn = 'SyncOnValue'
            $result = [_agEnvCore]::Set($testVar, $valueOn, [agEnvScope]::User, $on)
            $expected = "$testVar = $valueOn"
            $result | Should -Be $expected

            # public Get で User スコープ確認
            [_agEnvCore]::Get($testVar, [agEnvScope]::User) | Should -Be $valueOn

            # public Get で Current(alias)スコープ確認
            [_agEnvCore]::Get($testVar, [agEnvScope]::Current) | Should -Be $valueOn
        }

        It "Sync=false で User のみ設定され、Current には反映されない" {
            $valueOff = 'SyncOffValue'
            $result =[_agEnvCore]::Set($testVar, $valueOff, [agEnvScope]::User, $off)
            $expected = "$testVar = $valueOff"
            $result | Should -Be $expected

            # public Get で User スコープ確認
            [_agEnvCore]::Get($testVar, [agEnvScope]::User) | Should -Be $valueOff

            # 変数がない場合は IsEnvExist で false を確認
            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Current) | Should -BeFalse
        }
    }
  }
  ```

#### **実装**

- `./scripts/agEnvCore.ps1`:

  ```powershell
    static [string] Set(
        [string] $Name,
        [string] $Value,
        [agEnvScope] $Scope = [agEnvScope]::User,
        [bool] $Sync = $On
    ) {
        [ _agEnvCore ]::_SetRaw($Name, $Value, $Scope)
        if ($Sync -and ($Scope -ne [agEnvScope]::Current)) {
            [ _agEnvCore ]::_SetRaw($Name, $Value, [agEnvScope]::Current)
        }
        return "$Name = $Value"
    }
  ```

#### **まとめ**

`Set` メソッドが Sync オプションに従い正しく動作することを確認した。

### 2.5 環境変数取得メソッド (`Get': 公開用)

#### **テスト条件**

- `Get` は `_GetRaw` の結果をそのまま返す

#### **テストコード**

- `./scripts/Tests/agEnvCore.Tests.ps1`:

  ```powershell
  Describe "agEnvCore - Get メソッド (Public API)" {
    Context "正常系" {
        BeforeEach {
            $testVar   = '<UT_Get_Public>'
            $testValue = 'PublicValue'
            # _SetRaw で Current (Process) スコープに設定
            [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::Current)
        }
        AfterEach {
            # _RemoveRaw でクリーンアップ
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Current)
        }

        It "Current alias を指定して取得できる" {
            $result = [_agEnvCore]::Get($testVar, [agEnvScope]::Current)
            $result | Should -Be $testValue
        }
    }
  }
  ```

#### **実装**

- `./scripts/libs/agEnvCore.ps1`:

  ```powershell
   static [string] Get(
        [string] $Name,
        [agEnvScope] $Scope = [agEnvScope]::Current
    ) {
        return [ _agEnvCore ]::_GetRaw($Name, $Scope)
    }
  ```

#### **まとめ**

`Get` メソッドが正しく動作することを確認した。

### 2.6 環境変数削除メソッド (`Remove': 公開用)

#### **テスト条件**

- Sync = $true → 永続スコープ + `Current` 両方を削除
- Sync = $false → 永続スコープまたは、`Current`のみ削除

#### **テストコード**

- `./scripts/Tests/agEnvCore.Tests.ps1`:

  ```powershell
  Describe "agEnvCore - Remove メソッド (Public API)" {
    Context "Sync 動作" {
        BeforeEach {
            $testVar   = '<UT_Remove_Sync>'
            $testValue = 'ToBeRemoved'
            # User と Current 両方に設定
            [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::User)
            [_agEnvCore]::_SetRaw($testVar, $testValue, [agEnvScope]::Current)
        }
        AfterEach {
            # 両スコープをクリーンアップ
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::User)
            [_agEnvCore]::_RemoveRaw($testVar, [agEnvScope]::Current)
        }

        It "Sync=true で User と Current が同時に削除され、削除した名前を返す" {
            $ret = [_agEnvCore]::Remove($testVar, [agEnvScope]::User, $true)
            $ret | Should -Be $testVar

            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::User)    | Should -BeFalse
            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Current) | Should -BeFalse
        }

        It "Sync=false で User のみ削除され、Current は残り、削除した名前を返す" {
            $ret = [_agEnvCore]::Remove($testVar, [agEnvScope]::User, $false)
            $ret | Should -Be $testVar

            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::User)    | Should -BeFalse
            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Current) | Should -BeTrue
        }

        It "Sync=false で Currentのみ削除され、User は残り、削除した名前を返す" {
            $ret = [_agEnvCore]::Remove($testVar, [agEnvScope]::Current, $false)
            $ret | Should -Be $testVar

            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::User)    | Should -BeTrue
            [_agEnvCore]::IsEnvExist($testVar, [agEnvScope]::Current) | Should -BeFalse
        }

    }
  }
  ```

#### **実装**

- `./scripts/libs/agEnvCore.ps1`:

  ```powershell
  # ./scripts/libs/agEnvCore.ps1
    static [string] Remove(
        [string]    $Name,
        [agEnvScope] $Scope = [agEnvScope]::User,
        [bool]       $Sync  = $true
    ) {
        [ _agEnvCore ]::_RemoveRaw($Name, $Scope)
        if ($Sync -and $Scope -ne [agEnvScope]::Current) {
            [ _agEnvCore ]::_RemoveRaw($Name, [agEnvScope]::Current)
        }
        return $Name
    }
  ```

#### **まとめ**

`Remove` メソッドが `Sync` オプションに従い正しく動作することを確認した。

<!-- markdownlint-enable -->
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
