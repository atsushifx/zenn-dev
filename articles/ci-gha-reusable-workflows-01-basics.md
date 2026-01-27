---
title: "Reusable Workflows 入門: GitHub ActionsにおけるCI/CD基盤の共通化"
emoji: "🔧"
type: "tech"
topics: ["GitHub Workflow", "GitHub Actions", "CI/CD", "Reusable Workflows"]
published: false
---

<!-- textlint-disable ja-technical-writing/sentence-length -->

## はじめに

atsushifx です。
この記事では、GitHub 上の複数リポジトリで CI/CD 基盤を共通化し、**品質を安定して確保するための考え方**を説明します。

複数のリポジトリを並行して運用する場合、CI/CD による一貫した品質確保が重要になります。
そのため、リポジトリを横断して同一の検査フローを適用できる [GitHub Actions](https://docs.github.com/ja/actions) を CI/CD の基盤として活用します。

CI/CD では、最低限として次のような検査が欠かせません。

- 機密情報が漏れないようにするためのスキャン
- GitHub Actions の設定自体が正しいかどうかのチェック

これらを各プロジェクトごとに個別管理すると、設定のばらつきや更新漏れが起きやすくなります。
この連載では **Reusable workflows を使って CI/CD 基盤を共通化する考え方**を、段階的に整理していきます。
この記事では、Reusable workflows の概要と位置づけを扱います。具体的な設計や実装については後の回で説明します。

> Note:
> 本記事では、見出しでは **Reusable Workflows**、
> 機能として言及する場合は **Reusable workflows** と表記します (GitHub Docs に準拠)。

## 用語集

この記事で扱う主要な技術用語を解説します。
この解説を頭に入れておくことで、記事本文の理解に役立ちます。

- `Reusable Workflows`:
  GitHub Actions において、workflow や job 単位の処理を、権限や実行環境を含めて再利用できる仕組み。

- `Composite Actions`:
  複数の step を 1 つの action として再利用するための仕組み。job や workflow は再利用対象外。

- `Workflow Templates`:
  新規 workflow 作成時に用いるテンプレート。生成後は各リポジトリで独立して管理される。

- `Caller Workflow`:
  Reusable Workflows を呼び出す側の workflow。

- `permissions`:
  GitHub Actions におけるトークン権限設定。Reusable Workflows では基盤側で権限を定義・統制でき、最小権限設計を一貫して適用できる。

- `secrets: inherit`:
  呼び出し元 workflow の `secrets` を reusable workflow 側に引き継ぐ指定方法。
  利用には呼び出し元と参照先の権限設計を理解したうえで、意図しない権限昇格を避けるための明示的な判断が必要となる。

## 1. Reusable Workflows とは何か

この章では、GitHub Actions における Reusable workflows を、他の再利用手法と何が異なるのかという観点から整理します。
とくに、「どの実行単位が、どこまで再利用されるのか」に注目します。

### 1.1 Reusable Workflows による workflow の再利用

Reusable workflows は GitHub Actions で使用している workflow を再利用するための仕組みです。
再利用したい workflow を reusable workflow として設定することで、他の workflow から呼び出せるようにします。

従来の再利用手法 (Composite Actions など) と異なり、Reusable workflows では**workflowそのもの**をまとめて外部から呼び出せます。
このため、Reusable workflows には、job 構成・runner・権限設定が含まれます。
Reusable workflows には、次の特徴があります。

- CI/CD に必要な検査フローを 1カ所で定義し、複数リポジトリから参照
- 権限 (`permissions`)や `secrets` の扱いを基盤側で一元管理
- 呼び出し元 (caller workflow) は最小限の記述で済む

結果として、**「CI/CD 基盤としての責務」と「プロジェクト固有の処理」**を明確に分離できます。

### 1.2 何が「workflow」レベルで再利用されるのか

Reusable workflows で再利用されるのは、**workflow全体、あるいは job という実行境界**です。
GitHub Actions でいう **workflow** は 1つのファイルで示される一連の処理を指します。
**job**は、workflow 内で定義される個々の実行単位を指します。

これには、次が含まれます。

- job 構成
  job の分割、依存関係 (`needs`)、並列・直列の設計

- 実行環境
  `runs-on` による runner 指定、前提 OS やアーキテクチャ

- 権限境界
  `permissions` による最小権限設計 (read/write の粒度を含む)

- `secrets`の受け渡し規則
  `secrets: inherit`を含む、呼び出し側／基盤側の責務分離

- 失敗時の意味づけ
  fail-fast、continue-on-error、基盤としての合否判断基準

「リポジトリをチェックアウトし、lint や機密情報のスキャンを実行し、結果を返す」という一連の処理が、Reusable workflows では 1つの処理として参照できます。
上記の一連の処理が、**workflow あるいは job 単位の設計判断としてまとめられ、再利用**されます。

これらは YAML 上では独立した記述に見えますが、**CI/CD 基盤としては一体の設計判断**です。
呼び出し側の workflow (caller workflow)では、この判断結果を参照するだけですみます。

## 2. GitHub Actions における再利用の仕組み

GitHub Actions には、設定や処理を再利用するための仕組みが複数用意されています。
この章では、代表的な 3つの仕組みを紹介し、それぞれの設計思想と適用範囲を確認します。

### 2.1 Composite Actions

Composite actions は、workflow 内の複数の step を 1つの action としてまとめ、**同一 job 内で繰り返される処理を再利用するための仕組み**です。
この仕組みでは、再利用の対象は step に限定されます。
そのため、job 構成や runner、権限設定といった workflow 全体の設計判断は、呼び出し側が引き続き担います。

主な特徴は、次のとおりです。

- 再利用単位は step
- job 構成・runner・権限は呼び出し側が保持
- ローカル処理の共通化に向いている

一方、制約は、次のとおりです。

- job の分割や依存関係を隠蔽できない
- 権限設計を action 側に閉じ込められない
- CI/CD 全体の合否判断や品質基準を統一できない

Composite actions が向いているのは、次のような処理です。

- 同一 job 内で繰り返される処理の削減
- workflow の可読性向上
- 小さな処理単位の再利用

総じて、workflow 内の処理を部品化し、workflow を単純化し読みやすくするのに向いています。
しかし、「CI/CD 基盤としての責務」を共通化する用途には向きません。

### 2.2 Workflow Templates

Workflow templates はあらかじめテンプレートとして用意された workflow 定義をもとに新しい workflow を作成する仕組みです。
Reusable workflows や Composite actions と違い、各リポジトリに独立した workflow として記述されるのが特徴です。
通常、新しいプロジェクトで GitHub Actions を初期設定する際に、テンプレートによって体系的な処理を即座に配置する目的で利用されます。

Workflow Templates の主な特徴と限界は次のとおりです。

- 特徴:
  - 再利用単位は workflow (コピー)
    テンプレートから生成された workflow は、各リポジトリにコピーされ、独立して存在する
    以降の判断や更新は、それぞれのリポジトリに委ねられる
  - 初期統一に強い
    命名規則、基本構造、推奨ジョブ構成を揃えやすい
  - 導入コストが低い
    GitHub 標準機能のみで完結し、理解もしやすい
- 限界:
  - 更新は自動で伝播しない
    テンプレートを修正した場合、既存リポジトリは手動での更新が必要
  - 権限・品質基準の強制力が弱い
    最初は template 通りのワークフローでも、編集で自由に変更可能
  - 運用が進むほど乖離しやすい
    リポジトリ数増大により、管理工数も増大

Workflow Templates は、次の用途に適しています。

- 新規プロジェクト立ち上げ時の初期統一
- ベースライン (workflow の作成基準) の提示
- workflow 作成用のサンプル、ガイド用途

逆に、**継続的に品質やセキュリティを保証する CI/CD 基盤の共通化**には向いていません。

### 2.3 Reusable Workflows

Reusable workflows は、GitHub Actions における workflow や job を再利用する仕組みです。
重要なのは、workflow の一連の処理を提供するだけでなく、権限や`secrets`といった workflow に関するものをまとめて提供する点です。
このため、実行環境・権限・品質基準といった判断は、reusable workflow 側が引き受けます。

Reusable Workflows の主な特徴は次のとおり:

- 再利用単位は workflow / job
  job 構成、依存関係、runner 指定を含めて再利用される
- 権限と `secrets` の設計を基盤側に集約可能
  `permissions` や `secrets` の扱いを呼び出し元から切り離せる
- 更新が即時に伝播する
  reusable workflow を更新すれば、呼び出し側は自動的に最新状態を利用できる
- バージョン固定が可能
  `@ref` (tag / SHA) 指定により、意図しない変更を防げる

Reusable workflows の使用は、単なる再利用ではなく **CI/CD の責務の委譲** となります。

CI/CD 基盤の共通化を考えた場合、Reusable Workflows では次のような点を実現できます。

- 各リポジトリに権限設計を委ねない
- 品質基準をコードとして集中管理できる
- 更新・修正を「配布」ではなく「参照切り替え」で済ませられる

### 2.4 再利用の仕組み比較

ここまで見てきたように、 3つの仕組みは「再利用」の対象と責務の切り出し方が本質的に異なります。
それぞれの特徴の向き／不向きをまとめると次の表となります。

| 観点                 | Reusable Workflows | Composite Actions  | Workflow Templates |
| -------------------- | ------------------ | ------------------ | ------------------ |
| 再利用の単位         | workflow / job     | step               | workflow (コピー)  |
| 再利用の方法         | 参照               | 参照               | 複製               |
| job 構造の隠蔽       | 可能               | 不可               | 不可               |
| runner 指定の集約    | 可能               | 不可               | 初期のみ           |
| 権限 (`permissions`) | 基盤側で統制可能   | 呼び出し側依存     | 呼び出し側依存     |
| `secrets` の責務分離 | 可能               | 不可               | 不可               |
| 更新の反映           | 即時（参照先更新） | 即時（参照先更新） | 手動               |
| CI/CD 基盤への適性   | ◎                  | ×                  | ×                  |

## 3. なぜ、Reusable Workflows が「CI/CD 基盤の共通化」に向いているか

Reusable Workflows が、なぜ「CI/CD 基盤の共通化」に向いているかを、複数リポジトリ運用での問題点や共通化すべき責務などから明確化します。

### 3.1 複数リポジトリ運用で起きる問題

複数のリポジトリを並行して運用していると、CI/CD に関して次のような問題が発生しやすくなります。

- workflow 定義のばらつき
  lint やセキュリティスキャンの有無、実行順序、失敗時の扱いがリポジトリごとに異なる

- 権限設定の不統一
  `permissions` が過剰に付与されたまま放置される、あるいは設定自体が省略される

- 更新漏れ
  脆弱性対応やツールを更新しても、すべてのリポジトリに反映されない

- 判断基準の分散
  "どこまで通れば CI を成功とみなすか"という合否基準が各 workflow に散在する

これらの問題は、個々の workflow の正しさではなく、CI/CD 全体としての一貫性や再現性を損なう点に本質があります。

### 3.2 共通化すべき責務

CI/CD 基盤を共通化する際に重要なのは、「どの処理を共通化するか」ではなく、
**「どの責務を基盤側に集約するか」**を明確にすることです。

Reusable Workflows が担うべきなのは、次のような基盤固有の責務です。

- 前提とする実行環境
  runner、OS、アーキテクチャ、前提ツールや初期化手順など、実行結果に影響する環境要因

- 権限境界と機密情報の扱い
  `permissions` の最小権限設計、`secrets` の受け渡し方法、`secrets:inherit` の可否判断

- 品質・セキュリティ判断
  lint、機密情報スキャン、Actions 設定検証など、CI/CD として必須とする検査の定義

- 合否の意味づけ
  どの失敗を致命的とし、どこまでを許容するかという基準の統一

これらの責務は、実行結果やセキュリティ要件が共通であるため、プロジェクトごとに差異を持たせる合理性はほとんどありません。
一方で、設定ミスや判断の揺れが直接リスクにつながるため、各リポジトリに任せるのは不適切です。

Reusable Workflows では、これらの責務を呼び出し側からは **「触れられない前提」**として提供できます。
呼び出し側は、次の点に集中できます。

- トリガー条件や入力値など、プロジェクト固有の設定
- 基盤が提供する結果を前提とした後続処理の設計

結果として、**「CI/CD の正しさを判断する責務」と「プロジェクトの事情を反映する責務」**が明確に分離されます。
この分離こそが、CI/CD 基盤を共通化する際の本質的な価値です。

### 3.3 「基盤」という言葉の意味づけ

ここでいう「CI/CD 基盤」とは、単に複数の workflow を集約したものではありません。
CI/CD 基盤とは、**判断を内包した実行境界**です。

- どの処理を実行するか
- どの権限で実行するか
- どの失敗を許容し、どこで止めるか

Reusable workflows は workflow そのものを再利用するため、上記の設計判断、すなわち権限設定や合否判断なども含めて共有できます。
つまり、Reusable workflows が、呼び出し側の自由度を奪う代わりに、CI/CD における正しさや一貫性を引き受けます。

「基盤」とは、Reusable workflows が CI/CD の責務を引き受けることを意味しており、GitHub Actions の構造によって、このことを自然な形で実現します。

## 4. Reusable Workflows でできること／できないこと

Reusable Workflows は強力な仕組みですが、万能ではありません。
できること／できないこと、向いている用途／向いていない用途を理解しておくことが重要です。

### 4.1 向いている用途

Reusable Workflows が最も力を発揮するのは、**CI/CD における「判断」を共通化したい領域**です。

具体的には、次のような用途に向いています。

- 共通の検査フローの提供
  lint、機密情報スキャン、GitHub Actions 設定の検証など、すべてのリポジトリで必須としたい検査を一括で定義できる

- 単純な処理の部品化、リポジトリへの提供
  コードの品質チェック、ファイル名の命名規則のような定型的で包括的な処理を部品化し、それぞれのリポジトリに提供できる

- 権限と `secrets` の設計集約
  `permissions` の最小権限設計や `secrets` の受け渡しルールを、 呼び出し側から切り離して管理できる

- 合否基準の統一
  fail-fast の有無、失敗の重要度の判断を CI/CD 基盤として一貫して適用できる

- 更新の集中管理
  reusable workflow を更新するだけで、参照しているすべての workflow に変更を反映できる

これらはいずれも、各プロジェクトが個別に判断する合理性が乏しく、誤ると影響が大きい領域です。
Reusable Workflows は、このような領域を「基盤の責務」として切り出すための仕組みだと言えます。

### 4.2 向いていない用途

Reusable Workflows は CI/CD 基盤として強力ですが、**すべての再利用を担う仕組みではありません**。

次のような用途には向いていません。

- プロジェクト固有の分岐が多い処理
  リポジトリごとに条件や例外が大きく異なる処理を組み込むと、基盤側の workflow が複雑化し、可読性と保守性を損ないます

- step レベルの小さな共通処理
  単一コマンドの実行やツールセットアップなどは、Composite Actions のほうが適切です

- 頻繁に仕様が変わる実験的な処理
  試行錯誤中の処理を基盤に含めると、すべての利用リポジトリに影響が波及し、変更コストが増大します

- 各リポジトリに裁量を残したい判断
  否基準や権限設計をプロジェクト側で自由に調整したい場合、Reusable Workflows による集中管理は過剰な制約になります。

Reusable Workflows は、**「すでに決まっており、安定した判断を提供する場所」**として設計されるべきです。
変化の激しい処理や、試行錯誤そのものを価値とする領域は、基盤の外に置くほうが合理的です。

### 4.3 誤解されやすいポイント

Reusable Workflows を導入する際、基盤として使用するための性質が理解されないままで使われることがあります。
次のような誤解には気をつける必要があります。

- 「YAML を DRY にするための仕組み」だと思われがち
  Reusable Workflows の本質は、記述量削減ではありません。
  **権限、実行環境、合否基準といった判断を基盤側に集約する仕組み**です。

- 自由度が下がることを欠点と捉えてしまう
  権限や検査内容を呼び出し側で自由に変更できないことは、基盤としては欠点ではなく、一貫性を保証するための仕組みです。

- すべてを Reusable Workflows で解決しようとする
  小さな処理の再利用や、試行錯誤が前提の処理まで含めると、基盤が肥大化し、かえって扱いづらくなります。

Reusable Workflows は、**「何でも共通化するための道具」ではありません**。
どこまでを基盤が引き受け、どこからをプロジェクトに委ねるか、その境界を明確にするための仕組みです。

この前提を共有できれば、CI/CD 基盤は「守るべき制約」と「委ねるべき自由」を統合し予測可能なものとなります。

## おわりに

以上、この記事では、GitHub Actions における Reusable Workflows を、CI/CD の基盤という位置づけで整理しました。

Reusable workflows は、単に workflow を再利用する仕組みではなく、**権限・前提環境・品質判断といった CI/CD の責務を委譲できる**仕組みです。

この仕組みが、機密情報を含む処理などリポジトリを横断して共通の責務を引き受けることで、各リポジトリはプロジェクト固有の関心事に集中できます。

プロジェクト間で共通の責務は Reusable Workflows に集約し、プロジェクトごとの責務はプロジェクト固有の workflow に委ねることで、
CI/CD は予測可能で一貫したものになります。

このように、Reusable Workflows を活用することで、ソフトウェア開発の速度や品質を向上させることができます。
その結果、CI/CD 全体の一貫性が高まり、開発の生産性向上につながります。
よろしければ、自身の CI/CD 環境に Reusable Workflows を取り入れ、その効果を体感してみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- ワークフローを再利用する: <https://docs.github.com/ja/actions/how-tos/reuse-automations/reuse-workflows>
  GitHub 公式による Reusable Workflows の説明

- ワークフロー構成の再利用: <https://docs.github.com/ja/actions/reference/workflows-and-actions/reusing-workflow-configurations>
  既存の workflow を reusable workflow として使用する方法

## Appendix

### 付録A: Reusable Workflows を基盤として使う際のアンチパターン

1. DRY 目的で導入
   - 症状: 入力が肥大、if 条件だらけ
   - 対処:「判断」は呼び出し側で行い、処理のみを Composite actions に委譲する

2. プロジェクト差分を吸収しすぎる
   - 症状: Reusable Workflows が読めない
   - 対処: 差分は Caller Workflow へ返す

3. バージョン固定をしない
   - 症状: 予期せぬ破壊的変更
   - 対処: @tag or @sha を必須化

### 付録B: 採用判断チェックリスト

- [ ] 権限設計を各リポジトリに任せたくない
- [ ] 合否基準を一箇所で決めたい
- [ ] 更新を「配布」ではなく「参照」で済ませたい
- [ ] プロジェクト差分は入力で表現できる

<!-- textlint-disable -->

3つ以上 YES → Reusable Workflows を検討すべき
