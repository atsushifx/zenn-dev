---
title: "GitHub CI/CD: reusable workflowsを使って、シンプルなGitHub Actionsを実現する方法"
emoji: "🔁"
type: "tech" # tech: 技術記事
topics: ["GitHub", "GitHub Workflows", "GitHub Actions", "CI/CD"]
published: false
---

## はじめに

atsushifx です。
GitHub で自プロジェクトにかかりきりでした。
ここで大事なのは、プロダクトだけでなくその基盤である CI/CD もセキュアにすることです。
この記事では、GitHub での CI/CD 基盤となる GitHub Workflows を効率的に管理・運用するための、Reuseable Workflows を紹介します。

### この記事の目的

この記事では、`Reusable Workflows` (再利用可能なワークフロー)を使って、複数のリポジトリでの GitHub Actions を効率的に整備/運用する方法を紹介します。
とくに、`.github`リポジトリにテンプレート化した`GItHub Actions`をまとめ、リポジトリを横断して使い回すことで、CI/CD 環境の標準化・保守性向上・運用コスト削減を目指します。

### GitHub Actions を複数リポジトリで運用する際の課題

GitHub Actions を複数のプロジェクトに適用する場合、テンプレートとなるリポジトリから各リポジトリに GitHub Workflows をコピーして使用するケースが散見されます。
この場合、以下のような課題が発生します。

- 同一内容を複数箇所で定義するため、変更時の対応漏れリスクが高まる
- 各リポジトリごとにバージョンや設定が異なり、統一性が損なわれる
- ベストプラクティスを全プロジェクトで反映させるための修正が手間になる
- セキュリティ／permissions／依存関係の管理が個別に発生し、運用負荷が増大する

このような課題により、CI/CD 環境そのものが “動いているが最適とは言えない” 状態に陥ることがあります。

### Reusable Workflows が解決する問題

再利用可能なワークフローを活用することで、以下のようなメリットを得ることができます。

- ワークフロー定義を一元化し、管理・変更を一箇所で行なうことが可能
- 各リポジトリから同じワークフローを呼び出すだけで、設定漏れやバラつきを防止
- 共通処理 (例：lint／security scan／build／test) を統一して簡易化
- ワークフロー更新時の影響範囲を把握しやすく、メンテナンス効率が向上

## 1. Reusable Workflows の基礎

この章では、`Reusable Workflows`とは何かについての説明を、作成方法、使用方法を説明します。

### 1.1 Reusable Workflows とは

`Reusable Workflows`は指定した`GitHub Actions`を複数のリポジトリで共有するための仕組みです。
`workflow_call`トリガーを介して、他リポジトリから`Reusable Workflows`を呼び出すことができ、結果として CI/CD を標準化できます。

`Reusable Workflows`を`.github`リポジトリ内にまとめることで、保守の負荷を下げることができます。

`GitHub Workflows`で使用する`GitHub Actions`は、本来リポジトリごとに別々です。
`Reusable Workflows`を使って、機密情報の解析のような各リポジトリで共通の処理を 1つにまとめることで保守性や安全性を高めることができます。

### 1.2 Reusable Workflows の作成と呼び出し

`Reusable Workflows`には、トリガーとして`on: workflow_call`を設定します。呼び出し側の`GitHub Workflows`からは`uses:`ディレクティブで`Reusable Workflows`を呼び出せます。

このとき、`Reusable Workflow`を特定する`ref`として`\<ブランチ名>`, `\<タグ>`が使用できます。

- Reusable Workflow: `.github/workflows/lint.yml`

  ```yaml
  # reusable側
  on:
    workflow_call:
      inputs:
        config:
          required: false
          type: string
  ```

- Caller Workflow: `./github/workflows/caller.yml`

  ```yaml
  # caller側
  jobs:
    lint:
      uses: <owner>/<repository>/.github/workflows/lint.yml@r1.0.0
      with:
        config: ".shared/configs/lint.yml"
  ```

上記のように、呼び出し側からリポジトリ、ファイル名、タグなどを指定することで Reusable Workflows を呼び出せます。

### 1.3 Reusable Workflowsの構成要素

`Reusable Workflows` を設計する際に理解すべき主要要素は、次の 4つです。
`workflow_call` / `inputs` / `secrets` / `outputs`。
これらは、Reusable Workflow を「外部から安全に呼び出すための API」として機能し、CI/CD の標準化と再利用性を支える基盤になります。

#### 1. workflow_call

`workflow_call`は、Reusable Workflow を外部に公開するためのインターフェースです。
ここで定義した inputs／secrets／outputs を通じて呼び出し側と連携します。

```yaml
on:
  workflow_call:
    inputs:
      config:
        type: string
        required: false
    secrets:
      token:
        required: false
    outputs:
      exit_status:
        description: "Lint exit status"
        value: ${{ jobs.lint.outputs.exit_status }}
```

<!-- textlint-disable prh -->

ポイント:

- Reusable Workflow として機能させるための必須要素
- CI/CD の共通基盤として扱う際、ここが“仕様書”となる
- 呼び出し側が利用できるパラメータの一覧が明確になる

<!-- textlint-enable -->

#### 2. inputs

`inputs`は、リポジトリごとに異なる値の定義です。
設定ファイル、検査するファイル、ば-ジョン番号などを、ここで設定し、実際のアクションするフェーズで値を参照します。

```yaml
inputs:
  version:
    type: string
    default: "8.29.0"
  config-path:
    type: string
    default: .shared/configs/config.yaml
    required: false
```

#### 3. secrets

`secrets` は機密情報を安全に受け渡す手段です。
API トークンやアクセスキーなど、オープンにしたくない情報を caller 側から扱う際に使用します。

```yaml
secrets:
  github-token:
    required: true
```

用途:

- private リポジトリ参照
- 権限が必要な API の実行
- セキュアな CI/CD 運用の確保

注意点:

- 不要な secrets を要求すると、呼び出し元の権限設定が過剰になる
- ワークフロー全体の permissions と整合性が必要

#### 4. outputs

`outputs` は reusable workflow から caller workflow に値を返すための仕組みです。
lint 結果のパス、生成したバージョン番号、判定フラグなどを返却できます。

```yaml
outputs:
  report-path:
    description: "Lint result path"
    value: ${{ jobs.lint.outputs.report }}
```

用途:

- 後続処理で使用する情報（artifact 名、結果パスなど）を返却
- 複数ワークフローを連携させる際のデータ受け渡しに使用

caller 側:

```yaml
steps:
  - name: Print report path
    run: echo "Report: ${{ needs.lint.outputs.report-path }}"
```

### 1.4 最小構成

Reusable Workflow の最小構成は、次のようなサンプルになります。

- `reusable workflow` (短縮版)
  `Reusable`側は、共通化したい処理を最低限だけ記述し、`inputs`で呼び出し側の設定を吸収します。

  ```yaml
  name: reusable lint
  on:
    workflow_call:
      inputs:
        config-path:
          type: string
          required: false
          default: ".shared/configs/lint.yml"
  jobs:
    lint:
      runs-on: ubuntu-latest

      steps:
        - uses: actions/checkout@v4

        - name: Run lint
          run: |
            echo "Lint with ${{ inputs['config-path'] }}"
            # lint 実行に相当する処理
  ```

  要点:

  - `workflow_call` を宣言することで「外部から呼び出せる状態」になる
  - `inputs` を利用し、最低限の可変部分を caller 側から指定できる
  - `reusable workflow` は複雑にせず、単一責務に留めるほうが保守しやすい

- `caller workflow` (短縮版)
  `caller`側は、`uses:`ディレクティブで`reusable workflow`を呼び出します。
  CI 定義の大半は`Reusable`にあるため、`caller`側の設定は`uses`と入力パラメータだけになります。

  ```yaml
  name: call reusable lint

  on:
    pull_request:

  jobs:
    lint:
      uses: <owner>/<repository>/.github/workflows/lint.yml@r1.0.0
      with:
        config-path: ".shared/configs/override/lint.yml"
  ```

  要点:

  - reusable workflow をタグ (例: `r1.0.0`) で固定
  - caller 側は workflow の本体を一切持たず、ただ呼び出すだけ
  - 呼び出し側の責務は「パラメータを渡す」ことに限定される

### 1.5 複数リポジトリでの利用時に注意すべき点

Reusable Workflow を複数リポジトリで使う場合、運用規則を定めて一貫性を保たないと Workflow が破綻します。
この章では`Reusable Workflows`を設計するうえで、特に重要な注意点を説明します。

#### 1 `\<ref>` による workflows の固定

Reusable Workflow は、`caller workflow` (呼び出し基のワークフロー) から`uses`ディレクティブで呼び出すことができます。

`uses:` の形式:

```yaml
uses: <owner>/<repository>/.github/workflows/<workflow-file>@<ref>
```

`GitHub Actions`の特性上、Reusable Workflows の参照は**SHA固定では安定しない**場合があり、意図しない挙動を引き起こす可能性があります。
とくに、private リポジトリの場合、SHA 解決が失敗する既知の挙動が存在します。
このため、`Reusable Workflows`の固定にはタグが推奨されます。

SHA 固定が推奨されない理由:

- commit SHA が reusable workflow のパス解決に失敗するケースが存在
- private リポジトリ参照では SHA が安定しない
- GitHub Actions のセキュリティポリシーの影響を受けやすい

タグ固定による指定の例:

```yaml
uses: org/.github/.github/workflows/lint.yml@r1.0.0
```

タグを用いることで、caller workflow 側の構成を固定し、上位バージョンへの変更にコントロールを持たせられます。
組織全体で reusable workflow` を安全に運用するための基盤となるポイントです。

#### 2. `permissions`の明記

Reusable Workflows を安全に運用するためには、`permissions`を明示することが重要です。
`permissions`は、実行中のワークフローがリポジトリのどの範囲まで走査できるかを指定できる仕組みです。
Reusable Workflows 側で`permissions`を指定することで、意図しない書き込みや変更が怒らないようにします。

最小権限の例:

```yaml
permissions:
  contents: read
```

この設定により、対象リポジトリのコンテンツの読み取り権限のみ付与され、不要な書き込み操作を防げます。
明確な理由で権限が必要な場合は、下記のように限定的な権限を付加します。

```yaml
permissions:
  contents: read
  security-events: write
```

ポイント:

- reusable workflow 側での明示により、caller workflow の設定漏れを防ぐ
- 必要な権限のみ付与することでセキュリティリスクを低減
- 各 reusable workflow ごとに、必要最小限な設計をすることが重要
- 特に問題がなければ、`contents: read`権限で十分なことが多い

#### 3. 共通`config`の設定

Reusable Workflows のなかには、設定ファイルを参照する Actions が存在します。
これらの設定ファイルは、`.github`上に設定ファイルを集約し、Reusable Workflow が集約した config を参照するようにします。

下記のように、`.shared`下に共通 config をチェックアウトします。

```yaml
# Step 2: Checkout shared configs from atsushifx/.github
- name: Checkout shared configs
  uses: actions/checkout@v4.3.0
  with:
    repository: atsushifx/.github
    ref: releases
    path: .shared
    persist-credentials: false
```

実行時には、下記のように`.shared`下の config を設定します。
(`input.config-file`に共通設定ファイル`.shared/configs/gitleaks.yaml`が設定されている)

```yaml
- name: Run ghalint
  id: ghalint
  run: |
    ghalint run --log-color always -c ${{ inputs.config-file }} > report.log
```

`caller workflow`は、`with`句で`config-file`を設定することで、自リポジトリ専用の config を指定できます。

```yaml
jobs:
  scan-gitleaks:
    name: "Gitleaks Secret Scan with my config"
    uses: atsushifx/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
      with:
        config-file: "./configs/gitleaks.local.yaml"
```

このように、`with`句を使い、自リポジトリ用の設定ファイルを指定できます。

#### 4. `inputs`の厳選

Reusable Workflow を設計する際には、入力パラメータ(`inputs`)の厳選が不可欠です。
`inputs`が増加することでワークフローが複雑化し、運用コストが増します。
`inputs`を最低限に絞り込み、可変部分だけを`caller`へ委譲する形が理想です。

`inputs` の例:

```yaml
inputs:
  config-file:
    type: string
    required: false
    default: ".shared/configs/gitleaks.toml"

  version:
    type: string
    required: false
    default: "8.30.0"
```

上記のように、「`caller`による上書きが自然に起きる」パラメータを`inputs`として用意するのが適切です。

設計判断の原則:
`inputs`を追加するときは、いかの問いを満たすか確認します。

```bash
- 追加する`inputs`は `caller` が変えたいものか？
- `inputs`を変えないリポジトリでも安全に扱えるか？
- 増やした結果、workflow の単一責務を揺らしていないか？
```

#### 5. `secrets`の最小限化

`secrets`は、`GitHub Actions`が外部へ露出させたくない情報を安全に受け渡すための仕組みです。
そのため、`secrets`に指定する情報は少ないほうが望ましく、必要がなければ`secrets`を使わないアクションにすべきです。

`secrets`に設定される値の具体例:
実務でよく利用される`secrets`には、以下のようなものがあります。

- `GITHUB_TOKEN` (**GitHubが自動付与するトークン**)
  リポジトリ読み込み、Actions 実行など標準処理に利用

- `PAT` (`Personal Access Token`)
  - private リポジトリの読み書き
  - organization 内の workflow トリガー
  - 外部サービス API 認証

- アクセストークン
  - AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
  - GHCR (`GitHub Container Registry`)の PAT
  - npm publish 用トークン

こういった秘密にすべき情報は、caller から`secrets`として渡すようにします。

例:

```yaml
jobs:
  scan:
    uses: org/.github/.github/workflows/scan.yml@r1.0.0
    secrets:
      api-token: ${{ secrets.MY_API_TOKEN }}
```

注:
ここで `MY_API_TOKEN` は caller リポジトリ側で事前定義されている必要がある。

- `secrets`の設計判断:
  `secrets`に項目を追加する前に、次の問いを考えるべきです。

  <!-- textlint-disable ja-technical-writing/no-exclamation-question-mark  -->

  - `GITHUB_TOKEN` では本当に代替できないか?
  - `caller` の permissions を増やさずに済むか?
  - 追加した secret が将来の互換性を壊さないか？
  - この workflow の責務に対して、要求が過剰ではないか？

  <!-- textlint-enable -->

  上記の問いに、曖昧な答えしか出せないなら`secrets`を追加すべきではありません。

  秘密情報は、CI/CD で最優先で防御すべき部分です。
  `secrets`を最小限にすることで、CI/CD 全体の強度を支えるための根幹となります。

#### 6. ルールに則った出力パス、`artifact`名

Reusable Workflow を複数のリポジトリで利用する場合、`artifact` 名と出力パスの設計は CI/CD 全体の安定性を大きく左右します。
リポジトリによって出力先が異なる、出力する`artifact`名に一貫性がない。こういった場合は、caller のアクションが複雑化し、一貫性がなくなります。

保守や一貫性を考えた場合、Reusable Workflow の出力パスを統一し、出力する`artifact`名も一貫性のあるものにすべきです。

よい例 (統一パス):

```bash
./report/lint.log
./report/ghalint.log
./report/scan.json
```

Reusable Workflow 側で出力パスを統一することで、生成物が常に同じ場所に出力されます。

- `artifact` 名の統一による簡潔化
  `artifact`名が、ワークフロー屋リポジトリごとに異なると、それぞれのアクションごとに後続の分析、保存処理の調整が必要になります。
  Reusable Workflow 側で`artifact`名を固定することで、caller から見た理解コストを削減し、シンプルな活用ができるようになります。

  例:

  ```yaml
  - name: Upload lint result
    uses: actions/upload-artifact@v4
    with:
      name: lint-report
      path: ./report/lint.log
  ```

  上記の設定で、どのリポジトリでも`lint-report`という名前で、結果が保存されます。

- `outputs`による出力パスの受け渡し
  出力パスを`outputs`で公開することで Reusable 側の内部パスを意識する必要がなくなります。
  - Reusable Workflow

    ```yaml
    # reusable
    outputs:
      report-path:
        description: "Path to lint report"
        value: ./report/lint.log
    ```

  - caller workflow

    ```yaml
    # caller
    - name: Show report path
      run: echo "Report: ${{ needs.lint.outputs.report-path }}"
    ```

caller 側は、`outputs`を参照するため、`caller`側の変更にあわせて書き替える必要がありません。

**出力パス/`artifact`名設計原則**:
Reusable Workflow の出力設計では、以下のルールに従うべきです。

1. `artifact`名は、reusable workflow 側で固定する
2. reusable workflow 側で一貫性のあるルールに従って`artifact`名を決定する
3. 出力パスも reusable workflow 側で固定させる
4. 出力パス、`artifact`名は`outputs`で公開し、caller はそれを利用する
5. ディレクトリ構成は、workflow 内で完結させる

#### 7. `reuseable workflows`のバージョニング方針

Reusable Workflow を複数リポジトリで安定して利用するためには、
参照するバージョンを固定して扱う必要があります。
ここでは、基礎として押さえるべき最小限のバージョニング方針を説明します。

- **タグは、`vX.Y.Z` (Semantic Versioning) を使用**
  Reusable Workflow の参照には、SHA ではなくタグを用います。
  SHA は private リポジトリでの解決失敗や、意図しない更新を引き起こす可能性があるため、
  タグによる固定が安全です。

  推奨形式は vX.Y.Z。Semantic Versioning に準拠し、更新内容の性質を読み手が判断できます。
  - X: メジャーバージョン: 破壊的変更があった場合に、バージョンを上げる
  - Y: マイナーバージョン: 後方互換を伴う機能追加
  - Z:リビジョン: 軽微な修正

- **caller workflow はタグ固定で参照**
  呼び出し側は `uses:` でタグを指定し、更新の影響を制御します。

  ```yaml
  uses: org/.github/.github/workflows/lint.yml@v1.0.0
  ```

  これにより、ワークフロー更新があっても各リポジトリの CI が安定して動作します。

- **実践戦略 (`releases`ブランチや`rX.Y.Z`)**
  大規模、複数リポジトリに対応した実践的な戦略として、`releases`ブランチの採用、`rX.Y.Z`型式のバージョニングがあります。
  上記を採用した戦略は、[6. 実践運用](#6-実戦運用releases-ブランチと-rxyz-タグの活用) で解説します。

## 2. 実践サンプル：atsushifx/.github の reusable workflows

実際の運用例として [`atsushifx/.github`](https://github.com/atsushifx/.github) リポジトリにある
Reusable Workflows をもとに、構成・設計意図・利用方法を解説します。
Reusable Workflows の基礎概念を、どのように実務へ落とし込むのかを可視化します。

Reusable Workflows を`.github`のような特殊なリポジトリに集約することで、CI/CD の更新・保守・統一管理が容易になります。

### 2.1 `.github`リポジトリの構成 (抜粋)

特殊リポジトリ [`atsushifx/.github`](https://github.com/atsushifx/.github) に Reusable Workflows 関連の設定を集約します。

```bash
.github/
 ├─ workflows/
 │   ├─ ci-common-lint-ghalint.yml
 │   ├─ ci-common-lint-actionlint.yml
 │   ├─ ci-common-scan-gitleaks.yml
 │   └─ ...
 └─ configs/
     ├─ ghalint.yaml
     ├─ actionlint.yaml
     ├─ gitleaks.toml
     └─ ...
```

要点:

- Reusable Workflow 群を `.github/workflows/` に集約
- lint / security scan / actionlint など共通 CI を一本化
- `configs/` に共通設定をまとめ、各 workflow から参照可能にす

### 2.2 lint (ghalint) 用 reusable workflow (短縮版サンプル)

`ghalint` は GitHub Actions のセキュリティと構文の問題を検査する Linter です。
`ghalint`による GitHub Actions は、各リポジトリで共通なため Reusable Workflows として定義します。

```yaml
name: Common CI Lint (ghalint)

on:
  workflow_call:
    inputs:
      config-file:
        type: string
        required: false
        default: ".shared/configs/ghalint.yaml"

permissions:
  contents: read

jobs:
  ghalint:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      # .github上の共通configを.shared/以下にチェックアウト
      - name: Checkout shared configs
        uses: actions/checkout@v4
        with:
          repository: atsushifx/.github
          ref: v1.0.0
          path: .shared
          persist-credentials: false

      - name: Run ghalint
        run: |
          ghalint run -c ${{ inputs['config-file'] }} > ./report/ghalint.log

      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: ghalint-report
          path: ./report/ghalint.log
```

要点:

- `config-file` を input として扱い、caller 側で上書き可能
- shared config を `.shared` に展開する構造を統一
- 出力先は必ず `./report/ghalint.log` に固定
- artifact 名 `ghalint-report` も統一

### 2.3 actionlint 用 reusable workflow (短縮版サンプル)

`actionlint` は GitHub Actions YAML の文法をチェックする専用 Linter です。

```yaml
# actionlint.yaml
name: Common CI Lint (actionlint)

on:
  workflow_call:
    inputs:
      fetch-depth:
        type: number
        default: 0

permissions:
  contents: read

jobs:
  actionlint:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: ${{ inputs['fetch-depth'] }}

      - name: Run actionlint
        uses: reviewdog/action-actionlint@v1

      - name: Upload result
        uses: actions/upload-artifact@v4
        with:
          name: actionlint-report
          path: ./report/actionlint.log
```

要点:

- checkout の `fetch-depth` を input として調整可能
- 静的解析用の Linter を reusable workflow 化
- 出力物名を必ず `actionlint-report` に統一

### 2.4 gitleaks 用 reusable workflow (短縮版サンプル)

`gitleaks` は GitHub リポジトリ内の秘密情報を検出するセキュリティスキャナーです。

<!-- markdownlint-disable line-length -->

```yaml
# gitleaks 短縮版
name: Common CI Scan (gitleaks)

on:
  workflow_call:
    inputs:
      config-file:
        type: string
        required: false
        default: ".shared/configs/gitleaks.toml"
      version:
        type: string
        required: false
        default: "8.30.0"

permissions:
  contents: read

jobs:
  gitleaks:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Checkout shared configs
        uses: actions/checkout@v4
        with:
          repository: atsushifx/.github
          ref: v1.0.0
          path: .shared
          persist-credentials: false

      - name: Install gitleaks
        run: |
          curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v${{ inputs.version }}/gitleaks-linux-amd64 > gitleaks
          chmod +x gitleaks

      - name: Run gitleaks
        run: ./gitleaks detect -c ${{ inputs['config-file'] }} -r ./report/gitleaks.json

      - name: Upload result
        uses: actions/upload-artifact@v4
        with:
          name: gitleaks-report
          path: ./report/gitleaks.json
```

<!-- markdownlint-enable -->

要点:

- version を input として扱い柔軟にアップデート可能
- secret scan の出力フォーマットを JSON に統一

### 2.5 実運用版Reusable Workflowsサンプル

実運用で使用している Reusable Workflows のサンプルを [Gist](https://gist.github.com/atsushifx/c44a1fd8d3dd5d6b923a3d00775cce06) に掲載します。

1. caller workflow
   [caller workflow](https://gist.github.com/atsushifx/c44a1fd8d3dd5d6b923a3d00775cce06?file=ci-common-lint-actionlint-yml#file-ci-common-lint-actionlint-yml)

2. reusable workflows
   - [ci-common-lint-actionlint.yml](https://gist.github.com/atsushifx/c44a1fd8d3dd5d6b923a3d00775cce06?file=ci-common-lint-actionlint-yml#file-ci-common-lint-actionlint-yml)
   - [ci-common-lint-ghalint.yml](https://gist.github.com/atsushifx/c44a1fd8d3dd5d6b923a3d00775cce06?file=ci-common-lint-actionlint-yml#file-ci-common-lint-ghalint-yml)
   - [ci-common-scan-gitleaks.yml](https://gist.github.com/atsushifx/c44a1fd8d3dd5d6b923a3d00775cce06?file=ci-common-lint-actionlint-yml#file-ci-common-scan-gitleaks-yml)

実運用では、次の原則を満たす設計が採られています。

- permissions の最小化と明示
- 参照する外部 Actions の SHA 固定
- config の参照パスの統一
- artifact 名の標準化
- version input による柔軟なアップデート管理

これらのサンプルは、Reusable Workflow の基盤をどのように整えるかを理解する助けになります。
また、GitHub Actions を複数リポジトリで展開する際の標準構成として利用できます。

### 2.6 共通 reusable workflows が備えるべき基本パターン

複数リポジトリでの実運用のためには、Reusable Workflows は次の 4つの基本パターンに習う必要があります。

#### 1 外部ツールのバージョン管理

Reusable Workflows が使用する外部ツール (`actionlint`,`ghalint` など) の **version input を必ず用意する**。
これは、以下の理由による。

- caller が、**意図したバージョンを明示できる**
- reusable 側で内部固定すると、更新時に影響が他のリポジトリすべてに波及する
- CI/CD の段階化アップグレードができる

例:

```yaml
inputs:
  version:
    type: string
    required: false
    default: "8.30.0"
```

この設定があることで、組織横断のツール更新が「段階的」「安全」「後方互換的」なものにかわります。

#### 2 安全な permissions と SHA 固定

Reusable Workflow で caller の permissions に依存してしまう設計は、危険です。
そのため、以下の 2点が必要です。

1. reusable 側で最低限の permissions を宣言する
2. 参照する Actions を SHA で固定して `supply-chain` 攻撃を防ぐ

最小権限の例:

```yaml
permissions:
  contents: read
```

加えて、外部 Actions は必ず下記のように SHA で固定します。

```yaml
uses: actions/checkout@<sha256> # <version>
```

理由:

- permission 漏れによる「意図しない書き込み」を防ぐ
- 外部 Actions の改竄防止
- 全リポジトリで動作の揺らぎをゼロにする

#### 3 共通 config の利用

Reusable Workflows での処理を共通化するため、設定ファイルを`.github`リポジトリに集約し、共通化します。

- **共通 config を .github に集約する理由**
  共通 config を **1か所** にまとめることで、次のメリットを得られる。
  - lint／scan の結果がすべてのリポジトリで一貫
  - 設定変更が .github リポジトリ内だけで完結
  - reusable workflow の内部処理が固定化され、保守が容易
  - caller リポジトリに設定ファイルが存在しなくても CI が構築可能

  CI/CD の一貫性を維持するうえで必須となる設計原則です。

- **共通 config の使用方法**
  下記の処理を実行し、`.shared/configs/`下に共通の設定ファイルをチェックアウトする。
  `gitleaks`等は、チェックアウトした共通の設定ファイルを参照する。

  ```yaml
  - name: Checkout shared configs
    uses: actions/checkout@v4
    with:
      repository: atsushifx/.github
      ref: releases
      path: .shared
      persist-credentials: false
  ```

  この結果、全リポジトリの CI が安定した基盤として動作する:
  - 呼び出し側のリポジトリとは別に、システム共通の設定ファイルを参照
  - reusable workflow が、どのリポジトリでも同一の動作を保証
  - 航続ステップが`.shared/configs/`を参照

  結果として、全リポジトリの CI が「安定した基盤」として動作する。

- **特定リポジトリでの設定変更**
  特定のリポジトリで、設定を変更したい場合は`with:`で設定ファイルを変更する。

  ```yaml
  with:
    config-file: "./configs/gitleaks.local.yaml"
  ```

  設定ファイルは、下記の 2層構造になる。

  ```bash
  共通設定 → `/.shared/configs/`下に集約
  独自設定 → `with:`句で明示的に変更
  ```

  これにより、「標準化」と「柔軟性」の両立が実現できる。

- **設計原則**
  共通 config を使用するためには、以下の原則を守る必要がある。

  1. **共通configは、`.github`リポジトリに集約**
  2. reusable workflow 内で、`.shared/`をチェックアウト
  3. 呼び出し側は、`.shared/configs/`下の設定ファイルを参照
  4. リポジトリ独自の設定は、`with:`句で設定ファイルを指定
  5. 上記の`.shared/configs`はすべての`reusable workflows`で固定

共通 config は Reusable Workflows の「再利用性」「標準化」「保守性」を支える中核要素です。
CI/CD 基盤を共通化するためにも、設定ファイルを共通化すべきです。

#### 4. 出力結果の統一インターフェース

Reusable Workflows を利用する際に、ポイントとなるのが実行結果の受け渡しです。
**「結果をどこへ出力するか」をreusable側で固定し、caller 側は「出力値の受け取り」に責任をもつ**形が理想です。

これを実現するために、以下のようにします。

- **出力パスの固定**
  reusable workflow 側で出力するファイル(レポートなど)のパスを固定します。

  ```yaml
  run: |
    ghalint run -c ${{ inputs['config-file'] }} > ./report/ghalint.log
  ```

  固定化の利点：
  - どの caller から呼び出しても結果の場所が変わらない
  - 後続ステップ（artifact upload）が常に同じ定義で済む
  - CI の分析ステップを横断的に共通化できる

- **artifact 名の統一**
  reusable 側で artifact 名を固定します。

  ```yaml
  - name: Upload report
    uses: actions/upload-artifact@v4
    with:
      name: ghalint-report
      path: ./report/ghalint.log
  ```

  利点:
  - caller 側で artifact 名の差異を吸収する必要がなくなる
  - 多数リポジトリの管理時に、取得対象の artifact を簡潔に指定できる
  - 出力物を蓄積する監査・セキュリティログ収集で一貫性を確保
  - 命名規則を決めて、従うことで一貫性のある artifact 名が利用可能
    例:
    `<tool-name>-report`

- **`outputs`による出力パスの受け渡し**
  `outputs`を使って、作成した出力結果を受け渡すと、caller 側の処理がスムーズになります。

  ```yaml
  outputs:
    report-path:
      description: "Path to lint report"
      value: ./report/ghalint.log
  ```

  caller 側:

  ```yaml
  run: echo "Report: ${{ needs.lint.outputs.report-path }}"
  ```

  利点:
  - reusable の内部変更が caller に波及しない
  - caller は「値の意味」だけ扱える (reusable の中身を考える必要はない)
  - 組み合わせる workflow の拡張が容易

- **設計の基本原則**
  結果の出力は、以下の原則を守る必要があります。

  1. artifact 名は reusable 側で決める
  2. 出力パスは reusable 側で固定
  3. outputs で抽象化された値を返す
  4. caller は outputs 以外を参照しない
  5. 内部変更は outputs 値が不変である限り安全

このように出力結果の扱いを標準化することで、「**どのリポジトリでも、CI が同じように動く**」ようになります。

## 3. caller workflows の統合と利用方法

caller workflow は、Reusable Workflow を呼び出す側の CI 定義です。
CI/CD の「制御塔」として機能し、リポジトリごとの差異を吸収しながら、統一された共通処理を活用します。

役割は明確です。

- 必要な reusable workflows を選択し呼び出す
- 各リポジトリ固有の設定のみを指定する
- 共通処理そのものは reusable workflow に委譲する

これにより、次のような状態を実現します。

- CI/CD の「本体」を `.github` で集中管理
- caller workflow は**最小限の YAML** で運用
- 全プロジェクトで一貫した CI 基盤が維持される

つまり、caller workflow は、
**「設定を渡して動作を決めるだけ」の軽量なフロントエンド**、
という位置づけになります。

### 3.1 caller workflow の役割

caller workflow の最も重要な役割は、**共通化された処理を適切に呼び出す**ことです。
Reusable Workflow が CI/CD の「本体」を担う一方で、caller workflow は以下の責務に集中します。

- どの reusable workflows を組み合わせるかを選択する
- リポジトリ固有の設定や入力値を渡す
- 必要な permissions や secrets を最小限で構成する
- 後続処理 (artifact 取得、通知など) を調整する

これらの役割に徹することで、caller 側の YAML 記述は非常に小さく、理解しやすい構造になります。

```yaml
jobs:
  lint:
    uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0
    with:
      config-file: "./configs/custom-ghalint.yaml"
```

### 3.2 `uses:` で reusable workflow を呼び出す方法

reuseable workflow を呼び出すには、`uses:`ディレクティブを使用します。
型式は次の通り:

```yaml
uses: <owner>/<repository>/.github/workflows/<workflow-file>@<ref>
```

ここで`<ref>`には、次の値を使用できます。

| ref種別  | refの例            | 特徴                                                | 推奨度 |
| -------- | ------------------ | --------------------------------------------------- | ------ |
| タグ     | `v1.0.0`, `r1.0.0` | 安定バージョンで固定                                | ◎      |
| ブランチ | `main`, `releases` | 常に最新のバージョンを取得 (実行結果に揺らぎがでる) | △      |
| SHA      | '1ef2...`          | 厳密固定だが private repo で解決失敗例あり          | △      |

上記から、実運用では「タグ固定」が最適解となります。

#### caller workflowのサンプル

最小構成例:

```yaml
name: CI

on:
  pull_request:

jobs:
  lint:
    uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0
```

caller 側は`uses`句で呼び出すだけになり、YAML が短くなる。

---

`inputs`パラメータの使用:
設定ファイルなどの差異を、`with:`で受け渡します。

```yaml
jobs:
  lint:
    uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0
    with:
      config-file: "./configs/ghalint.local.yml"
```

上記のように、`with句`で差分を指定するだけとなります。

---

`secrets`を渡す例:

```yaml
jobs:
  deploy:
    uses: org/.github/.github/workflows/deploy.yml@r2.0.0
    secrets:
      token: ${{ secrets.DEPLOY_TOKEN }}
```

トークンなどの機密情報は caller 側で管理します。
必要最低限の機密情報を受け渡すだけにするため、reusable workflow の設計が重要になります。

---

複数 workflow を呼び出す例:

```yaml
jobs:
  actionlint:
    uses: org/.github/.github/workflows/ci-common-lint-actionlint.yml@r1.0.0

  scan:
    needs: actionlint
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
```

`needs:` により、依存を制御し統合 CI を組み立てることができます。

### 3.3 複数 `reusable workflows` の組み合わせ (actionlint + ghalint + gitleaks)

1つの caller workflow から、複数の reusable workflows を呼び出すことができます。
ここでは、次の 3つを組み合わせるケースを考えます。

- `actionlint`: YAML 構文と基本ルールの検査
- `ghalint`: GitHub Actions 専用のセキュリティ／設定チェック
- `gitleaks`: 秘密情報の漏洩検査

これらを reusable workflows として `.github` に集約し、各リポジトリの caller workflows から呼び出す構成を考えます。

#### 1 全体像

全体の関係性:

```bash
caller workflow (各リポジトリ側)
  ├─ job: lint-actionlint  ── uses: org/.github/.../ci-common-lint-actionlint.yml@r1.0.0
  ├─ job: lint-ghalint     ── uses: org/.github/.../ci-common-lint-ghalint.yml@r1.0.0
  └─ job: scan-gitleaks    ── uses: org/.github/.../ci-common-scan-gitleaks.yml@r1.0.0
```

それぞれの reusable workflow では、以下の 3つのパラメータを指定できます。

- 入力 (`inputs`)
- 共通 config の参照
- 出力パスと artifact 名

caller 側は「**どの組み合わせで実行するか**」と「**必要であれば inputs を上書きするか**」だけを記述します。

#### 2 並列実行パターン

3つの検査を互いに依存させず、並列に実行する構成です。

```yaml
name: ci-lint-and-scan

on:
  pull_request:

jobs:
  lint-actionlint:
    uses: org/.github/.github/workflows/ci-common-lint-actionlint.yml@r1.0.0

  lint-ghalint:
    uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0

  scan-gitleaks:
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
```

特徴:

- 3つの job は独立して動作
- artifact 名や出力パスは reusable 側で統一
- caller 側は「どの検査を有効にするか」を job の有無で制御

#### 3. 依存関係のあるパターン

「YAML が壊れているなら、以降の検査の意味は薄い」という方針の場合。
`actionlint`を入り口とし、他の job は`needs:`で連結する。
`actionlint`の結果が問題ありの場合は、ほかの job を実行しない。

```yaml
jobs:
  lint-actionlint:
    uses: org/.github/.github/workflows/ci-common-lint-actionlint.yml@r1.0.0

  lint-ghalint:
    needs: lint-actionlint
    uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0

  scan-gitleaks:
    needs: [lint-actionlint, lint-ghalint]
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
```

特徴:

- actionlint が失敗した場合、以降の job をスキップする構成も選択可能
- CI の消費リソースを抑えたい場合に有効
- 「どこまで進んだか」が job 単位ではっきり可視化される

依存関係は caller 側の責務であり、reusable 側は常に「単独で完結する 1処理」として設計される。

#### 4. `inputs` の組み合わせによる調整

同じ reusable workflow でも、リポジトリやブランチに応じて
inputs を切り替えることで、挙動を変えられる。

共通 config:

```yaml
jobs:
  scan-gitleaks:
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
    with:
      version: "8.30.0"
      config-file: ".shared/configs/gitleaks.toml"
```

リポジトリ専用の設定:

```yaml
jobs:
  scan-gitleaks:
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
    with:
      version: "8.30.0"
      config-file: "./configs/gitleaks.local.toml"
```

- 共通 → `.shared/configs/...`
- 独自 → `with:`句でリポジトリ独自の設定を参照

このようにファイルを配置することで、構成が整理される。

##### 5. 組み合わせ設計の原則

複数の reusable workflow を使う場合に、意識すべきポイントは次の通り。

- 単一責務:
  各 reusable workflow は「1種類の検査」に集中
- 出力の統一:
  `/report/〜` 配下と `*-report` の artifact 名を使い分けず、ルールを固定
- `inputs`は少数精鋭:
  バージョン・config・fetch-depth など、本当に変えたいものだけを入力にする
- 依存関係は caller 側で制御
  並列／直列は reusable に埋め込まず、caller の `needs:` で表現する

すなわち、caller は「構成図」、reusable は「構成図の部品」としての役割となります。

### 3.4 共通 config とローカル config による差分管理

reusable workflow は、共通 config を参照することで、どのリポジトリでも共通の動作を保証しています。
プロジェクト固有の動作をさせたい場合は、caller workflow 側でローカル config を設定します。

すなわち、組織全体での CI/CD の品質を揃えるために、共通 config を集中管理し、プロジェクト特集の動作はローカル config で対応させます。

Reusable Workflow では、**共通 config と ローカル config の二重構造**によって品質と柔軟性を両立させています。

#### 1. 共通 config で集中管理する意義

複数リポジトリに対して CI/CD を一貫した形で提供するためには、設定ファイルの共通化が不可欠です。
`.github`リポジトリに、共通の設定ファイルをまとめることで、以下の効果が得られます。

- lint / security scan の結果が、全リポジトリで統一される
- 設定値の変更を一カ所で管理できる
- reusable workflow の挙動を安定させられる
- caller に設定ファイルが存在しなくても、CI を構築できる

設定ファイルは CI の挙動に直接影響するため、共通化しておくことで組織全体の CI 品質が揺らがなくなります。

#### 2. ローカル config によるプロジェクト固有要件の管理

共通 config で CI の基準を統一しても、すべてのリポジトリが同じ条件で動作するとは限りません。
歴史的な経緯によるルール、依存パッケージの制約、検査対象ファイル構成の違いなど、個々のリポジトリには固有要件が存在します。

上記の要件に対応するため、`with:`句でローカル config ファイルを設定できるようにしておきます。

```yaml
with:
  config-file: "./configs/gitleaks.local.yaml"
```

このように指定された場合、reusable workflow は共通 config の代わりにローカル config を読み込みます。
そのため、ローカル config ファイルでは、プロジェクト特有の設定だけでなく、共通 config の設定も記述します。
(`import`などで、共通 config の設定を簡略化できる場合もあります)

ローカル config を利用することで、次のようなケースに対応できます。

- 特定リポジトリだけ除外ルールを追加したい
- スキャン対象パスを一部変更したい
- 過去のコード資産に対してのみ緩和設定を適用したい

このように、柔軟な例外処理を記述するための仕組みがローカル config です。

#### 3. reusable workflow の default としての共通 config

Reusable Workflows は、`inputs`で受け渡された引数によって動作を変更します。
引数が未指定の場合、`default`句で指定された値が動作を設定します。
設定ファイルが未指定の場合は、共通 config を参照すべきなので、`default`句に共通 config を設定しておきます。

```yaml
inputs:
  config-file:
    type: string
    required: false
    default: ".shared/configs/gitleaks.toml"
```

この `default`句には、次の役割があります。

- **共通基盤としての設定値を常に保証する**
- **caller が設定を省略しても CI が正しく動作する**

このように、共通設定を組み込むことで、reusable workflow は「最低限の挙動を常に保証する CI の基盤」として機能します。

#### 4. ローカル config による設定の上書き

caller workflow が `with:` で設定ファイルを指定した場合、reusable workflow はそのパスを優先し、default の共通 config は参照されません。
この動作は **完全な上書き**であり、共通 config の設定は引き継がれません。

- ローカル config を設定:

  ```yaml
  with:
    config-file: "./configs/gitleaks.local.yaml"
  ```

この指定がある場合、reusable workflow は `inputs.config-file` をそのまま参照して処理を実行します。

- reusable workflow での設定ファイル参照:

  ```yaml
  run: |
    gitleaks protect -c ${{ inputs['config-file'] }} -r ./report/gitleaks.json
  ```

多くのツール (`gitleaks`, `ghalint`など) は設定ファイルのマージ機能を持たないため、ローカル config を指定した時点で **全設定がローカル定義で置き換わる** 挙動になります。

そのため、ローカル config を利用する場合は、必要な設定をすべてファイル内に記述することが前提となります。

共通設定とローカル設定の役割は次の通りです。

- 共通設定 → 組織横断での標準化
- ローカル設定 → プロジェクト固有要件への対応（完全置換またはツール依存での差分）

> 補足: **設定ファイルの引き継ぎ**
> ツールによっては、共通 config から設定を引き継げるものもあります。
> たとえば、`commitlint`では、下記の記述で共通 config から設定を引き継げます。
>
> ```js
> // ./configs/commitlint.config.js
>
> import { default as baseConfig } from '.shared/configs/commitlint.config.base.js'; // ← .js拡張子を必ず付ける
>
> // override configs
> const config = {
>   ...baseConfig,
>   rules: {
>     ...baseConfig.rules,
>     // override rules write here
>   },
> };
>
> export default config;
> ```

#### 5. 共通化とローカル管理の設計原則

Reusable Workflow における設定管理は、共通 config とローカル config の二層構造によって成立します。
この二層構造を安定的に運用するためには、次の 5つの設計原則を踏まえる必要があります。

1. 共通設定は `.github` リポジトリに一元化:
   設定ファイルは CI の挙動を直接左右するため、複数リポジトリへ分散させず `.github` に集約します。
   これにより、設定変更を一か所で完結でき、すべてのリポジトリが同じ基準で動作します。

2. reusable workflow は共通 config を default として採用:
   `inputs` の `default`句に共通 config のパスを設定し、caller が何も指定しなくても安定した CI を提供します。
   共通 config が常に基盤として利用されるため、全体の動作の揺らぎがなくなります。

3. ローカル config は「完全上書き」として扱う:
   ローカル config を設定した場合、共通 config は読み込まれません。
   ローカル config には、共通 config の設定も含め、すべてを設定しなくてはいけません。

4. プロジェクト特有の要件は caller 側で明示:
   除外ルール、スキャンしない範囲の設定など、プロジェクト特有の要件は caller workflows 側から`with`句を通して設定します。
   プロジェクトごとの特殊要件を caller workflow で設定することで、共通基盤への影響を最小限にします。

5. 「共通化」と「柔軟性」の境界線を明確化
   共通化する設定、プロジェクト固有の設計を明確に分けることで、設計を安定化します。
   共通化の範囲が広すぎると例外処理が増えて、設計が破綻します。
   ローカル設定が多すぎると、標準化が意味をなさなくなります。
   そのため「全体で統一すべき基盤」と「プロジェクト固有の差分」を分離する設計が重要となります。

6. 「共通化」「ローカルに委譲」の指針
   処理、設定を共通化、ローカルに委譲のどちらかにするかは、以下の指針で判断します。
   - 共通化すべきもの：lint ルール、scan ルール、artifact 名、出力先、ツールの基本設定
   - ローカルに委譲すべきもの：歴史的資産、例外パス、段階的移行期間の緩和設定

これらの設計原則を踏まえることで、Reusable Workflow は
**標準化された CI 基盤と柔軟なプロジェクト適応性の両立**を実現できます。

### 3.5 `inputs`による挙動変更とパラメータ管理

Reusable Workflow を柔軟に運用するためには、`inputs` をどのように設計し、どのように扱うかが重要になります。
`inputs`は reusable workflow の可変部分を外部化し、共通化された処理を保ちながら、リポジトリ固有の要件を扱うための仕組みです。

本節では、`inputs` が担う役割、設計時の注意点、運用時の管理方法を整理します。

#### 1. `inputs` の役割

`inputs`は caller workflows が変更したい値を、reusable workflow に受け渡します。reusable workflows は値に応じて、動作を変更します。
`inputs`で指定されるパラメータには、次のようなものがあります。

- ツールのバージョン
- 設定ファイル (のパス)
- checkout 時の `fetch-depth`
- 特別なフラグや条件分岐の選択

典型的な定義は以下の通り:

```yaml
inputs:
  config-file:
    type: string
    required: false
    default: ".shared/configs/gitleaks.toml"
  version:
    type: string
    required: false
    default: "8.30.0"
```

このように reusable workflow 側で default を定義することで、caller workflow が何も指定しなくても安定した動作が保証されます。

#### 2. 設計指針: `inputs` を増やしすぎない

`inputs`は便利ですが、多すぎると`Reusable Workflows`の保守性を損ないます。
複雑なパラメータ設計は、全リポジトリの CI/CD に影響を与えるため、最小限の設計が求められます。

設計時の判断基準は、次の通り:

- caller が変更したくなる値か
- default のままでも安全に動作するか
- 追加する inputs がワークフローの単一責務を壊していないか

`inputs`は Reusable Workflows の可変部分を切り出すための手段です。
処理ロジックを切り替える用途として使用すると、reusable workflow の統一性が低下します。

#### 3. caller workflow でのパラメータ指定

caller workflow は `with:` を使って値を上書きします。
設定ファイルをプロジェクト固有のものに変更する場合は、次の通り:

```yaml
jobs:
  scan:
    uses: org/.github/.github/workflows/ci-common-scan-gitleaks.yml@r1.0.0
    with:
      config-file: "./configs/gitleaks.local.toml"
```

`fetch-depth`など、 Git 操作に関する値を切り替える場合も同様です。

```yaml
with:
  fetch-depth: 0
```

#### 4. `inputs` による条件分岐

設計によっては、`inputs`の値によって`reusable workflows`の動作自体を切り替えられます。
`inputs`に設定するパラメータの基本ルールは次の通り:

- 動作を切り替える分岐は避ける:
  例: `mode: 'lint: "lint" : "scan"`のようなパラメータは、workflows の責務を曖昧にする
- 規定値の差し替えだけに使う:
  例: config ファイルの切り替え、ツールバージョンの変更

#### 5. パラメータ管理のベストプラクティス

`inputs` を長期的に安定運用するためには、次の管理方法が重要です。

- デフォルトの設定: `inputs`の`default`句に共通基盤の値を設定し、caller の設定を簡素化
- 名称の統一: ネーミングルールを決め、workflow 間で同じ意味のパラメータは同一名称にする
- `version input`の使用: 使用するツールの`version`を`inputs`化し、段階的な移行を可能にする
- 設定ファイルパラメータの統一: 設定ファイル系の input は可能な限り単一名 (例: `config-file`) に統一する

特に version input の存在は、複数リポジトリで CI/CD を運用するうえで強力な仕組みになります。
組織横断でのツール更新を段階的に進められ、変更リスクを最小化します。

### 3.6 `outputs` による結果受け渡し

`outputs` は reusable workflow と caller workflow 間で、実行結果に関する情報を受け渡すための仕組みです。
`reusable workflows`が生成した出力を、判定値、レポートのパスなどのように抽象化し、`caller workflows`に受け渡します。
`caller`側は、`outputs`の各パラメータに応じて、出力結果をパース、表示します。

重要なのは、`outputs`が返すのは**出力結果のメタ情報** (パス、フラグ、バージョンなど) である点です。

#### 1. `outputs`の役割

`outputs` は、次のようなパラメータを受け渡します。

- `reusable workflow` が生成したレポートファイルのパス
- `判定フラグ`(`true`/`false`), exit code 相当の情報
- バージョン情報, 生成物 ID
- その他、後続 workflows が使用するメタデータ

この結果、caller workflow 側は reusable workflow の内部構造を知らなくても、必要な値だけを扱うことが可能になります。

#### 2. 実行結果の受け渡し (`artifact`, `file`)

`outputs`には文字列長 (10KB まで)、改行コード不可といった制限があり、実行結果の受け渡しには向きません。
そのため、実行結果はワークスペース内のファイルとして扱うか、artifact としてアップロードします。
`outputs`は、ファイルパスや artifact 名の受け渡しに利用します。

#### 3. `workflows`での`outputs`の使用例

- `caller workflows`での利用例

  ```yaml
  # caller 側は`outputs`で値を受け取る

  jobs:
    lint:
      uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0

  analyze:
    needs: lint
      runs-on: ubuntu-latest
      steps:
        - name: Print report
          run: echo "Report path: ${{ needs.lint.outputs.report-path }}"
  ```

  `caller workflow` 側は `outputs` だけを扱います。`reusable workflows`側の都合で、出力パスの変更があっても`caller workflows` に影響はありません。

- `reusable workflows`での`outputs`設定例

  ```yaml
  # 出力パスを`outputs`で受け渡し
  jobs:
    ghalint:
      outputs:
        report-path: ${{ steps.report.outputs.path }}

      steps:
        - name: Run ghalint
          id: report
          run: |
            ghalint run -c ${{ inputs['config-file'] }} > ./report/ghalint.log
            echo "path=./report/ghalint.log" >> $GITHUB_OUTPUT
  ```

  `reusable workflows`側のポイントは、次の通り:

  - 実行内容 (ログ、レポート) をファイルとして`./reports/`下に出力
  - 出力パス ('./report/`)、ファイル名(`ghalint.log`)を固定化し、インターフェイスを安定化
  - echo "path=..." >> $GITHUB_OUTPUT で、メタ情報(レポートファイルパス)を出力
  - outputs: {{ ...outputs.path }} でメタ情報を受け渡し

  これにより、`reusable workflows`の動作に関わりなく、`outputs.report-path`で出力結果を参照できます。

#### 4.`outputs` の設計原則

`outputs`設計は、以下の原則に従い標準化します。

- `outputs`はファイルパス、exit ステータスなどのメタ情報を受け渡す
- スキャンログなどの出力結果は、ファイルか artifact を使用して受け渡す
- 出力パス、ファイル名などはネーミングルールに則って固定し、インターフェイスを安定させる
- レポートなどの受け渡しは、`outputs.report-path`のように`outputs`経由でパスを受け渡す

上記のように`outputs`を標準化すると、`reusable workflows`で出力パスやファイルメイを変更しても、`outputs`を参照するだけで出力結果にアクセスできます。
結果として、複数リポジトリを横断した CI/CD 運用において、次の利点が生まれます。

- reusable workflow の内部変更による影響範囲を最小化
- caller 側の実装は「値を受け取るだけ」で成立
- レポート分析処理を横断的に共通化
- 長期運用における設定変更コストを削減

言い換えるなら`outputs` は reusable workflow の「安定した外部 API」です。
caller workflow は API の意味（例: `report-path`）だけを扱い、内部実装は reusable workflow にすべて委譲します。
これは、CI/CD の標準化と保守性を両立するための重要な設計原則となります。

### 3.7 private リポジトリを参照する際の注意点

private リポジトリを参照する場合は、**認証方式の厳格**、**ref解決の安定性確保**が必須。

#### 原則

`private`リポジトリを参照する場合は、以下の原則に従うこと:

1. タグ固定:
   private 参照では、`use: ...@<sha>`が解決できない事例あり、そのため、タグ固定が安定。

   ```yaml
   uses: org/.github/.github/workflows/ci.yml@r1.0.0
   ```

2. `permissions`の最小化:
   reusable 側で `contents: read` を明記し、設定漏れに対応

   ```yaml
   permissions:
     contents: read
   ```

3. checkout での credential 制限
   private リポジトリ取得は `persist-credentials: false` が必須。

   ```yaml
   - uses: actions/checkout@v4
     with:
       persist-credentials: false
   ```

4. PAT 使用の明示
   private リポジトリ取得に限り、必要最小限の PAT (`Personal Access Token`)が必要

   ```yaml
   secrets:
     token: ${{ secrets.REPO_ACCESS_TOKEN }}
   ```

#### 検証条件

- caller 側で **明示的に権限を付与したときのみ成功**する状態
- ref 解決が **全環境 (PR/branch/cron) で再現性を持つ**
- checkout 後の `.git/config` に credential が**残存していない**

を確認すること。

## 4. よくあるエラーとその対処

この章では、Reusable Workflows を使ううえでよくあるエラーと、それに帯する対処法についてまとめます。

### 4.1 設定エラー

#### (1) “workflow was not found”

結論:
`uses`: のパス／ref が誤っている。

主な原因:

- `Github/workflows/`下の相対パス誤り
- private リポジトリで SHA が解決できない
- タグ／ブランチが存在しない ref を指定

検証条件:

- `.github/.github/workflows/<file>.yml` と二重`.github` になっていない
- GitHub 上で対象タグを確認 (`git tag -lP ではなく **GitHub Portal**で確認)
- 参照対象が public / private どちらかをチェック

推奨対策:

- タグ固定 (`r1.0.0`) を使用
- パスは必ず `.github/workflows/` を含める

例:

```yaml
uses: org/.github/.github/workflows/ci-common-lint-ghalint.yml@r1.0.0
```

#### (2) ref の指定ミス (branch / tag / SHA)

結論:
private リポジトリを参照する場合、SHA 固定では失敗することがある。

リスク:

- 意図せぬ最新バージョン取得で CI が不安定化

推奨:

- **タグ固定**のみ使用
- ブランチは PoC（検証時）に限定

### 4.2 権限エラー

#### 1 トークン権限不足 (GITHUB_TOKEN vs PAT)

## 5. バージョン管理と更新戦略

### 5.1 branch 固定・タグ固定・SHA 固定の比較

### 5.2 semantic versioning と GitHub Actions の違い

### 5.3 reusable workflow 更新時のフロー

### 5.4 breaking change 対策と互換性の考え方

### 5.5 organization 全体での統一 CI/CD 戦略

## 6. 実戦運用：releases ブランチと rX.Y.Z タグの活用

### 6.1 なぜ stable 専用の releases ブランチが必要なのか

### 6.2 releases ブランチの管理ポリシー

### 6.3 rX.Y.Z タグ戦略

#### 1 prefix 'r' をつける理由

#### 2 r1.0.0 → r1.1.0 → r2.0.0 の更新モデル

### 6.4 caller workflows 側でのタグ参照

#### 1 uses: path@r1.1.0 の意味

#### 2 バージョン固定による安定性の確保

### 6.5 reusable workflow の更新フロー (実例)

### 6.6 SHA 固定との比較：実務でタグ固定が最適解となる理由

### 6.7 複数安定版の併存戦略 (r1 系列と r2 系列)

## 7. 運用ベストプラクティス

### 7.1 security hardening (permissions, credential 管理)

### 7.2 shared config の活用と上書き戦略

### 7.3 CI 高速化テクニック (ubuntu-slim, キャッシュ)

### 7.4 リポジトリ間の統一性を保つための工夫

### 7.5 大規模運用での注意点 (組織全体への適用)

## おわりに

## 参考資料

### Webサイト

- ワークフローを再利用する: <https://docs.github.com/ja/actions/how-tos/reuse-automations/reuse-workflows>
  Reusable Workflows に関する GitHub の公式ドキュメント

- GitHub Actions のセキュリティ: <https://docs.github.com/ja/actions/concepts/security>
  GitHub Actions に関する

- セキュリティで保護された使用に関するリファレンス: <https://docs.github.com/ja/actions/reference/security/secure-use>
  GitHub 公式ドキュメント: GitHub Actions をセキュアに作成、運用するためのプラクティス

- ghalint: <https://github.com/suzuki-shunsuke/ghalint>
  GitHub Actions がセキュアかどうかをチェックする Linter、ghalint の公式リポジトリ

- atsushifx/.github: <https://github.com/atsushifx/.github>
  Reusable workflows, caller workflow の実例がのっているリポジトリ
