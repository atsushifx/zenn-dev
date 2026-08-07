---
title: "Design Specification: ci-lint-articles Composite Action Migration"
based-on: requirements.md v1.0.7
status: Draft
version: 1.0.7
created: "2026-06-22"
---

<!-- textlint-disable
  ja-technical-writing/sentence-length
  -->
<!-- markdownlint-disable line-length -->

> **Normative Statement**
> This document defines behavioral contracts derived from requirements.
> Implementations MUST conform to this document.
> RFC 2119 keywords apply throughout.

## 1. Overview

### 1.1 Purpose

`ci-lint-articles.yaml` を composite actions (`ca-validate-environment`、`ca-get-changed-files`、`ca-setup-repo`) を呼び出す構成に全面置き換えする際の振る舞い仕様を定義する。
本仕様は「何をするか」を規定し、「どのように実装するか」は規定しない。

### 1.2 Scope

本仕様は以下の振る舞いを対象とする。

- push/pull_request/workflow_dispatch/workflow_call の各トリガーに対する lint ジョブの起動条件
- 変更ファイルの取得と SHA 解決ロジック
- lint 実行の前提条件と実行順序
- count==0 スキップ・削除済みファイルスキップの振る舞い
- 全 Action の SHA 固定制約

実装詳細 (YAML 構文、具体的な Action バージョン、シェルスクリプトの実装) は対象外とする。

---

## 2. Design Principles

### 2.1 Classification Philosophy

ワークフローは「composite actions の呼び出しシーケンス」として構成される。
lint ロジックはワークフロー内に直接埋め込まず、外部 action または既存スクリプトへ委譲する。

変更ファイルの有無と削除状態を評価してから lint を実行することで、不要な実行と誤検知を防ぐ。

### 2.2 Design Assumptions

- `ca-get-changed-files` は before-sha/after-sha が **両方とも** 空文字で、かつ `github.event_name` が `push` または `pull_request` の **場合に限り** 自動的に SHA を解決する。以下の 2 点に注意する
  - 片方だけ空文字だと `before-sha and after-sha must both be specified or both be empty` で失敗する
  - `push` / `pull_request` 以外のイベント（`workflow_call` 経由の `schedule` / `release` 等を含む）で空文字を渡すと `Unsupported event` で失敗する。そのため caller 側が自前で SHA を解決する必要がある (R-002e)
- `ca-get-changed-files` は before-sha がオールゼロ (初回 push・新規ブランチ) の場合、自動的に空ツリー SHA にフォールバックしてリポジトリ全ファイルとの差分を返す。caller 側での特別処理は不要
- `ca-setup-repo` (repo: `aglabo/agla-doc-tools`、ref: commit SHA 固定) は Node.js/pnpm のセットアップと `pnpm install` まで行う。別途インストールステップは不要
- `ca-get-changed-files` の `outputs.files` は改行区切りのファイルパスリストである
- `markdownlint-cli2` は `ca-setup-repo` によってセットアップされた環境で利用可能になる
- `outputs.files` のファイルパスリストは、lint 実行ステップ内でシェルスクリプトによりダブルクォートとスペース区切りで展開して lint ツールに渡す
- 対象 Markdown ファイルのパスには空白・改行・グロブ特殊文字 (`*`、`?`、`[`) を含まないことを前提とする。これらを含むパスの動作は保証しない
- textlint と markdownlint は fail-fast で実行する。fail-fast はツール単位とし、
  textlint または markdownlint が非ゼロで終了した場合、ジョブを即時停止する (後続のツール・ファイルは処理しない)
- エラーの詳細確認と修正はローカル環境で行うことを前提とする

### 2.3 External Design Summary

> **Source**: Phase D (ユーザー確認済み設計方針) および Phase E (外部設計ダイアログ) から導出。

#### Feature Decomposition

| Unit                 | Responsibility                                    | REQ Coverage                    |
| -------------------- | ------------------------------------------------- | ------------------------------- |
| environment-validate | runner 環境と権限の事前検証                       | REQ-F-003                       |
| changed-files-detect | 変更 `*.md` ファイルのリストと件数の取得          | REQ-F-004, REQ-F-007            |
| repo-setup           | `agla-doc-tools` のセットアップ (lint ツール導入) | REQ-F-005                       |
| lint-execute         | 削除済み除外 + textlint / markdownlint 実行       | REQ-F-001, REQ-F-002, REQ-F-006 |

#### Unit Interaction Map

```text
[trigger: push / pull_request / workflow_dispatch / workflow_call]
        |
        v
+---------------------------+
| actions/checkout          |
| (fetch-depth: env,        |
|  default 0)               |
+---------------------------+
        |
        v
+---------------------------+
| environment-validate      |
| (ca-validate-environment) |
| actions-type: read        |
+---------------------------+
        |
        v
+---------------------------+
| SHA resolve               |
|  push / PR          -> before="", after="" (上流が解決) |
|  other + parent OK  -> before=parent, after=HEAD        |
|  other + no parent  -> shallow? error : warning+skip    |
|  git failure        -> error (exit non-zero)            |
+---------------------------+
        |
        v
+---------------------------+
| changed-files-detect      |
| (ca-get-changed-files)    |
| pattern: **/*.md          |
+---------------------------+
        |
        | outputs.files (newline-separated)
        | outputs.count (integer)
        v
+---------------------------+
| repo-setup                |
| (ca-setup-repo)           |
+---------------------------+
        |
        | textlint / markdownlint-cli2 available
        v
+---------------------------+
| lint-execute              |
|  count==0 -> skip+warning |
|  file deleted -> skip     |
|  else -> run linters      |
+---------------------------+
        |
        v
   [success / failure]
```

#### Data Flow Diagram

```text
[GitHub Event]
      |
      v
[actions/checkout fetch-depth:${FETCH_DEPTH} (default 0)]
      |
      v
[ca-validate-environment actions-type:read]
      |
      v
[Resolve before-sha / after-sha]
      |
      +-- push / PR              --> before="", after="" (上流が自動解決)
      +-- other + parent OK      --> before=parent, after=HEAD
      +-- other + no parent      --> [--is-shallow-repository?]
      |                                +-- false --> [warning log, skip=true, exit 0]
      |                                +-- true  --> [error log, exit non-zero]
      +-- git command failure    --> [error log, exit non-zero]
      |
      v
[ca-get-changed-files pattern:**/*.md]
      |
      v
[outputs.files, outputs.count]
      |
      v
[count == 0?] --yes--> [warning log, exit 0]
      |
      no
      v
[ca-setup-repo repo:agla-doc-tools]
      |
      v
[for each file in outputs.files]
      |
      +--[file deleted?] --yes--> ["deleted -> skip" log, continue]
      |
      no
      v
[textlint] --fail--> [exit non-zero]
      |
      ok
      v
[markdownlint-cli2] --fail--> [exit non-zero]
      |
      ok
      v
[exit 0]
```

### 2.4 Non-Goals

> **Derivation**: REQUIREMENTS の "Out of Scope" セクションから導出。

- reusable workflow (`ru-*`) の新規作成 (`ci-lint-articles.yaml` の `workflow_call` は `fetch-depth` パラメータの受け渡しのみを目的とし、汎用の再利用インターフェースとしては提供しない)
- 他のワークフローファイルの変更
- textlint・markdownlint の設定変更
- lint ルールの追加・変更

### 2.5 Behavioral Design Decisions

| ID    | Decision                                                                                                                               | Rationale                                                                                                                                     | Affected Rules               | Status |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ------ |
| DD-01 | composite actions を step-level で直接呼び出す (job-level reusable workflow は使わない)                                                | lint ロジックの保守性を高め、共通基盤の恩恵を受けるため (DR-01)                                                                               | R-002a〜R-002d, R-003, R-004 | Active |
| DD-02 | `push` / `pull_request` は空文字で上流に委譲し、それ以外のイベントは `git rev-list --parents` で SHA を解決して `GITHUB_OUTPUT` へ出力 | `github.sha^1` expression は YAML では直接使用できない。また上流の自動解決は push/PR のみ対応のため、他イベントは caller が解決する必要がある | R-002                        | Active |
| DD-04 | ステップ間の SHA 受け渡しは `GITHUB_ENV` + `${{ env.X }}` ではなく `GITHUB_OUTPUT` + `${{ steps.<id>.outputs.<key> }}` を使う          | 実行時生成の env は静的解析で追えず VS Code の GitHub Actions 拡張が誤検知する。上流 `ca-get-changed-files` も outputs 方式                   | R-002, R-004                 | Active |
| DD-05 | 親コミットが見えない場合、`git rev-parse --is-shallow-repository` で初回コミットと shallow clone を切り分け、shallow は失敗させる      | shallow を初回コミットと誤認して skip すると lint が実行されないまま成功扱いになるため (fail-first)                                           | R-002b, R-002f               | Active |
| DD-03 | lint は `textlint --config configs/textlintrc.yaml` と `markdownlint-cli2 --config configs/.markdownlint-cli2.yaml` を直接呼び出す     | `pnpm run lint:markdown` は `XDG_CONFIG_HOME` に依存するため除外。`run-textlint.sh` ラッパーを経由しない                                      | R-005                        | Active |
| DD-04 | 削除済みファイルの除外は caller (ワークフロー) 側の責務とする                                                                          | `ca-get-changed-files` の責務範囲を超えないため (DR-04)                                                                                       | R-005                        | Active |
| DD-05 | 使用するすべての Action を commit SHA で固定する                                                                                       | サプライチェーンリスク対策 (DR-07)                                                                                                            | 全ルール                     | Active |

### 2.6 Related Decision Records

| DR-ID | Title                                                        | Phase | Impact on This Spec                               |
| ----- | ------------------------------------------------------------ | ----- | ------------------------------------------------- |
| DR-01 | composite actions を直接呼び出す                             | req   | step-level 呼び出し構成を規定 (DD-01 の根拠)      |
| DR-02 | ca-setup-repo で agla-doc-tools をセットアップする           | req   | repo-setup ユニットの対象リポジトリを確定         |
| DR-03 | push トリガーは main ブランチのみ対象                        | req   | R-001 のトリガー条件に影響                        |
| DR-04 | SHA 指定済みの場合は優先使用、未指定時はイベントから自動取得 | req   | changed-files-detect の SHA 解決ロジックを規定    |
| DR-07 | 使用するすべての Action を commit SHA で固定する             | req   | 全ステップの Action 参照方法を制約 (DD-05 の根拠) |

### 2.7 DD to DR Promotion Criteria

> **Purpose**: DD を正式な DR に昇格させるかどうかの判断基準。昇格はヒューマンジャッジメントによる。

**昇格を検討すべき条件**:

1. 複数の仕様・モジュールをまたぐ影響がある
2. 将来の設計選択を制約するアーキテクチャ上の決定である
3. 複数の有力な代替案が存在した
4. 外部関係者がレビューできるようにすべき決定である

現時点で DD-01〜DD-05 はすべてこの仕様内にローカルな決定であり、対応する DR (DR-01 等) がすでに存在するため昇格不要。

---

## 3. Behavioral Specification

### 3.1 Input Domain

- トリガー: `push` (main ブランチ、`paths: ['**/*.md']`) 、`pull_request` (main ブランチ、`paths: ['**/*.md']`) 、`workflow_dispatch`、`workflow_call`
- 入力パラメータ:

  | Name          | Type     | Required | Default | Applies to                            | Description                          |
  | ------------- | -------- | -------- | ------- | ------------------------------------- | ------------------------------------ |
  | `fetch-depth` | `string` | No       | `"0"`   | `workflow_dispatch` / `workflow_call` | checkout の fetch-depth (0 = 全履歴) |

- ステップ実行順序 (この順序で実行しなければならない。順序の変更は禁止する):
  1. `actions/checkout` (fetch-depth: ジョブレベル `env.FETCH_DEPTH`)
  2. `ca-validate-environment` (actions-type: read)
  3. SHA 解決 (トリガー種別に応じて before-sha/after-sha を決定)
  4. `ca-get-changed-files` (pattern: `**/*.md`)
  5. `ca-setup-repo` (repo: `aglabo/agla-doc-tools`、ref: commit SHA 固定)
  6. lint 実行
- 前提条件:
  - `fetch-depth` はジョブレベルの `env.FETCH_DEPTH` に一度だけ解決し、`actions/checkout` はその env を参照しなければならない (MUST) 。`with:` に `inputs` を直接展開してはならない
  - `env.FETCH_DEPTH` は `${{ inputs.fetch-depth || '0' }}` で解決しなければならない (MUST) 。`inputs` コンテキストは `push` / `pull_request` では未定義であり、トリガー配下の `default` は適用されないため、`|| '0'` フォールバックを省略すると空文字となり全履歴が取得されない
  - `fetch-depth` 未指定時は `0` (全履歴) に解決されなければならない (MUST)
  - `ca-validate-environment` は `actions/checkout` の直後、他のいかなるステップより前に実行しなければならない (MUST)
  - `ca-setup-repo` の `ref` は commit SHA で固定しなければならない (MUST) 。ブランチ名・可変タグの使用は禁止する
  - すべての Action が commit SHA で固定されていること

### 3.2 Output Semantics

- 成功 (exit 0):
  - lint エラーなし
  - 変更ファイルが 0 件 (スキップ + warning ログ)
- 失敗 (exit non-zero):
  - textlint または markdownlint がエラーを検出
  - `ca-validate-environment` が環境検証に失敗
  - `ca-get-changed-files` が SHA 解決に失敗

---

## 4. Decision Rules

<!--
Rule ID format: R-NNN (sequential, stable)
Rule IDs are referenced in Traceability and Edge Cases.
-->

評価はこの順序で実行しなければならない。順序の変更は禁止する。

### R-001: トリガー条件評価

| Rule ID | Step | Condition                                                              | Outcome                 |
| ------- | ---: | ---------------------------------------------------------------------- | ----------------------- |
| R-001a  |    1 | `push` イベント、かつ対象ブランチが `main`、かつ `*.md` を含む         | lint ジョブを起動する   |
| R-001b  |    2 | `pull_request` イベント、かつ対象ブランチが `main`、かつ `*.md` を含む | lint ジョブを起動する   |
| R-001c  |    3 | `workflow_dispatch` イベント                                           | lint ジョブを起動する   |
| R-001d  |    4 | 上記以外 (`*.md` を含まない push / PR など)                            | lint ジョブは起動しない |

### R-002: SHA 解決ルール

分岐は `push` / `pull_request` に該当するイベントかどうかで決まる。判定順は R-002d → R-002a/b/c/f とする。

| Rule ID | Step | Condition                                                                                                    | Outcome                                                                                         |
| ------- | ---: | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| R-002d  |    1 | `push` または `pull_request` イベント                                                                        | `before_sha` / `after_sha` の両方を空文字で出力 (`ca-get-changed-files` が自動解決)             |
| R-002a  |    2 | 上記以外のイベント、かつ `git rev-list --parents -n 1 HEAD` が親を返す                                       | 第2フィールド (親) を `before_sha`、第1フィールド (HEAD) を `after_sha` として GITHUB_OUTPUT へ |
| R-002b  |    3 | 上記以外のイベント、親が存在せず、かつ `git rev-parse --is-shallow-repository` が `false` (真の初回コミット) | warning ログを出力して `skip=true` を出力し exit 0                                              |
| R-002f  |    4 | 上記以外のイベント、親が存在せず、かつ `--is-shallow-repository` が `true` (shallow clone)                   | error ログを出力してジョブを失敗させる (exit non-zero)。黙ってスキップしない                    |
| R-002c  |    5 | `git` コマンドがその他の理由で失敗する                                                                       | エラーログを出力してジョブを失敗させる (exit non-zero)                                          |
| R-002e  |    — | `workflow_call` 経由で `schedule` / `release` 等から呼ばれた場合                                             | R-002a/b/f と同じ自前解決経路を通る。空文字を渡すと上流が `Unsupported event` で失敗するため    |

R-002f の根拠: 親フィールドが 1 つしかない状態は「真の初回コミット」と「shallow clone で親が未 fetch」の 2 通りがある。`fetch-depth` は `workflow_call` の caller が `"1"` を渡せるため後者は現実に起こりうる。これを初回コミットと誤認して skip すると、リントが実行されないまま成功扱いになる。

R-002f の適用範囲: この判定が働くのは caller 側で SHA を解決する非 push/PR 経路に限られる。`push` / `pull_request` (`workflow_call` の親が push の場合を含む) では空文字を渡すため上流が SHA を解決する。この経路で shallow により base へ到達できない場合、上流の `git diff` が `fatal: bad object` を出力し終了コード 128 で失敗する。メッセージの明快さは R-002f に劣るものの、いずれの経路でもリントを黙ってスキップすることはない。

### R-003: 環境検証

| Rule ID | Step | Condition                                                   | Outcome                                                                    |
| ------- | ---: | ----------------------------------------------------------- | -------------------------------------------------------------------------- |
| R-003   |    1 | `actions/checkout` の直後、かつ他のいかなるステップより前に | `ca-validate-environment` を実行する。失敗した場合はジョブを即時失敗させる |

### R-004: 変更ファイル取得

| Rule ID | Step | Condition                                      | Outcome                                                                               |
| ------- | ---: | ---------------------------------------------- | ------------------------------------------------------------------------------------- |
| R-004a  |    1 | R-002 で解決した before-sha / after-sha を使用 | `ca-get-changed-files` に `pattern: '**/*.md'` を渡して実行する                       |
| R-004b  |    2 | `ca-get-changed-files` 正常完了                | `outputs.files` (改行区切りパス) と `outputs.count` (整数) が確定する                 |
| R-004c  |    3 | before-sha がオールゼロ (初回 push)            | `ca-get-changed-files` が自動的に空ツリー SHA にフォールバック。caller 側の処理は不要 |

### R-005: lint 実行

| Rule ID | Step | Condition                                   | Outcome                                                                             |
| ------- | ---: | ------------------------------------------- | ----------------------------------------------------------------------------------- |
| R-005a  |    1 | `outputs.count` が 0                        | lint ステップをスキップし、warning メッセージをログに出力して exit 0                |
| R-005b  |    2 | `outputs.count` が 1 以上                   | `outputs.files` の各ファイルに対して R-005c〜R-005f を適用する                      |
| R-005c  |    3 | ファイルがファイルシステム上に存在しない    | "deleted → skip" をログに出力してそのファイルをスキップする                         |
| R-005d  |    4 | ファイルが存在する                          | textlint ツールをファイルに対して実行する                                           |
| R-005e  |    5 | R-005d が成功 (exit 0)                      | markdownlint ツールをリポジトリ内設定ファイルを使用してファイルに対して実行する     |
| R-005f  |    6 | textlint または markdownlint が非ゼロで終了 | 後続の lint ステップ (markdownlint 等) を実行せずジョブを即時失敗させる (fail-fast) |

<!-- impl-note: R-005d は `textlint --config configs/textlintrc.yaml $FILES` で一括実行する -->
<!-- impl-note: R-005e は `markdownlint-cli2 --config configs/.markdownlint-cli2.yaml $FILES` で一括実行する -->
<!-- impl-note: R-005b の outputs.files は改行区切りを削除済みファイル除外後にスペース区切りに変換して $FILES として lint ツールに一括渡しする -->
<!-- impl-note: fail-fast のため textlint が失敗した時点で後続の lint ステップ (markdownlint) は実行しない -->

---

## 5. Edge Cases

| Input / Condition                                            | 振る舞い                                                     | REQ           | Rationale                                                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | -------------------------------------------------------------------------------------------- |
| 初回 push (before-sha がオールゼロ)                          | `ca-get-changed-files` が空ツリーとの diff にフォールバック  | REQ-F-004     | caller 側処理不要。リポジトリ全ファイルが対象になる                                          |
| `outputs.count` が 0                                         | lint をスキップし warning ログを出力して exit 0              | REQ-F-006     | 変更ファイルなし = lint 不要。エラーにしない                                                 |
| 変更ファイルに削除済みファイルが含まれる                     | 存在チェックで除外し "deleted → skip" をログに出力           | REQ-F-006     | 存在しないファイルを lint ツールに渡すとエラーになるため                                     |
| `*.md` 以外の変更のみを含む push / PR                        | lint ジョブ自体が起動しない (paths フィルター)               | REQ-F-001/002 | GitHub Actions の `paths` フィルターで制御                                                   |
| workflow_dispatch で main ブランチ以外から実行               | lint ジョブは起動する (workflow_dispatch は branch 制約なし) | REQ-F-007     | 手動実行はどのブランチからでも可能                                                           |
| 非 push/PR イベントで親コミットが存在しない (最初のコミット) | warning ログを出力して lint をスキップし exit 0              | REQ-F-007     | 比較対象がないため lint 不要。エラーにしない                                                 |
| shallow clone で親が未 fetch (非 push/PR、fetch-depth: 1 等) | error ログを出力してジョブを失敗させる (exit non-zero)       | REQ-F-007     | 初回コミットと誤認して skip するとリントが黙って実行されないまま成功扱いになるため           |
| shallow clone で base に到達不可 (push / PR)                 | 上流の `git diff` が `fatal: bad object` で失敗 (exit 128)   | REQ-F-004     | 空文字を渡す経路のため caller 側の判定は働かない。ただし失敗するのでスキップ扱いにはならない |
| `workflow_call` 経由で schedule / release 等から呼ばれる     | caller 側 (resolve-sha) が自前で SHA を解決する              | REQ-F-007     | 空文字を渡すと上流が `Unsupported event` で失敗するため                                      |
| 変更ファイルがすべて削除済み (count > 0 だが全件スキップ)    | 全ファイルを "deleted → skip" でスキップし exit 0            | REQ-F-006     | lint 対象ファイルが残らない = lint 不要。エラーにしない                                      |
| textlint はエラーあり                                        | textlint 失敗で即終了 (後続の lint ステップを実行しない)     | REQ-F-006     | fail-fast はツール単位。エラー詳細はローカルで確認                                           |

---

## 6. Requirements Traceability

| Requirement ID | Spec Rule(s)                   | Notes                                                        |
| -------------- | ------------------------------ | ------------------------------------------------------------ |
| REQ-F-001      | R-001a, R-005d, R-005e         | push トリガー + lint 実行                                    |
| REQ-F-002      | R-001b, R-005d, R-005e         | pull_request トリガー + lint 実行                            |
| REQ-F-003      | R-003                          | ca-validate-environment を最初のステップで実行               |
| REQ-F-004      | R-002, R-004                   | SHA 解決 + ca-get-changed-files 実行                         |
| REQ-F-005      | Section 2.2 Assumptions        | ca-setup-repo による agla-doc-tools セットアップ             |
| REQ-F-006      | R-005a〜R-005f                 | count==0 スキップ、削除済みスキップ、lint 実行               |
| REQ-F-007      | R-001c, R-002a, R-002b, R-002c | workflow_dispatch トリガー + SHA 解決 (スキップ・エラー含む) |
| REQ-NF-001     | Section 2.1                    | composite actions 呼び出し中心の構成                         |
| REQ-NF-002     | Section 2.2 Assumptions        | 外部リポジトリからの composite actions 参照                  |
| REQ-C-001      | Section 3.1 入力パラメータ     | fetch-depth はデフォルト 0、パラメータで上書き可             |
| REQ-C-002      | R-001a                         | push トリガーは main ブランチのみ                            |
| REQ-C-003      | R-001a, R-001b                 | paths フィルター `**/*.md`                                   |
| REQ-C-004      | Section 3.1 Input Domain       | 全 Action を commit SHA で固定                               |
| REQ-C-005      | Section 7 Open Questions       | ca-get-changed-files の SHA 優先動作を先に実装要             |

---

## 7. Open Questions

> **Status**: INCOMPLETE (REQ-C-005 の前提条件が未解決)

| # | Question                                                                                                       | Source    | Impact                                                                                                      |
| - | -------------------------------------------------------------------------------------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------- |
| 1 | `ca-get-changed-files` の SHA 指定優先動作 (DR-04) が `aglabo/ci-platform` に実装済みか                        | REQ-C-005 | 未実装の場合、`ci-lint-articles.yaml` の実装前に ci-platform 側の対応が必要                                 |
| 2 | ~~`ca-validate-environment`、`ca-get-changed-files`、`ca-setup-repo` の step-level 呼び出し用 SHA~~ (解決済み) | REQ-C-004 | 解決済み。3 Action とも `aglabo/ci-platform` v0.3.3 (`9cc4b15bf10854ecc0fc2ea0a419d96566ea8bde`) に固定した |

---

## 8. Change History

| Date       | Version | Description                                                                                                                                                                                                                                        |
| ---------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-06-22 | 1.0.0   | Initial specification                                                                                                                                                                                                                              |
| 2026-06-22 | 1.0.1   | Codex review 対応: HEAD^1 なし時の warning スキップ追加 (R-002b) 、fail-fast 明記 (R-005e/f) 、パス展開安全性を Assumptions に追記                                                                                                                 |
| 2026-06-22 | 1.0.2   | explore review 対応: ステップ実行順序を Section 3.1 に明記、R-002c (git rev-parse その他エラー → exit non-zero) 追加、図を更新、REQ-F-007 トレーサビリティに R-002b/c 追記                                                                         |
| 2026-06-22 | 1.0.3   | harden review 対応: ca-setup-tool → ca-setup-repo に統一、ステップ順序 MUST 化、fetch-depth MUST 追記、ca-setup-repo の ref commit SHA 固定 MUST 追記、R-005f を「後続の lint ステップを実行しない」に明確化                                       |
| 2026-06-22 | 1.0.4   | fix review 対応: フロントマター version 修正、DD-01 Affected Rules 修正、R-003 条件文を Section 3.1 に統一、REQ-C-001 参照修正、R-005b 参照範囲を R-005c〜R-005f に修正                                                                            |
| 2026-06-22 | 1.0.5   | Codex review 対応: ファイルパス特殊文字制約を Assumptions に追記、fail-fast をツール単位と明記、全削除済みシナリオを Edge Cases に追加                                                                                                             |
| 2026-08-07 | 1.0.6   | fetch-depth をパラメータ化: Section 3.1 に入力パラメータ表と env.FETCH_DEPTH 経由の解決を追加、fetch-depth MUST をデフォルト 0 に緩和、図を更新                                                                                                    |
| 2026-08-07 | 1.0.7   | R-002 を全面改訂: 分岐を push/PR か否かに反転、SHA 受け渡しを GITHUB_OUTPUT へ移行 (DD-04) 、workflow_call 由来の非 push/PR イベントに対応 (R-002e) 、shallow clone を初回コミットと誤認しない判定を追加 (R-002f / DD-05) 、図と Edge Cases を更新 |
