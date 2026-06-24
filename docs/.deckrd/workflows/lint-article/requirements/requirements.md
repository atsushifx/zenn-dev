---
title: "Requirements: ci-lint-articles Composite Action Migration"
module: "workflows/lint-article"
status: Draft
version: 1.0.6
created: "2026-06-22"
---

<!-- textlint-disable
  ja-technical-writing/sentence-length
  -->
<!-- markdownlint-disable line-length -->

> **Normative Statement**
> This document defines binding requirements.
> Implementations MUST conform to this document.
> RFC 2119 keywords apply to this document only.

## 1. Overview

### 1.1 Purpose

`ci-lint-articles.yaml` を ci-platform の composite actions (`ca-validate-environment`、`ca-get-changed-files`、`ca-setup-repo`) を使った実装に作り直す。
あわせて `push` トリガーを追加し、PR 時だけでなく main ブランチへの直接 push 時にも Markdown ドキュメントの lint が実行されるようにする。

### 1.2 Scope

- `ci-lint-articles.yaml` の全面的な置き換え
- `push: branches: [main], paths: ['**/*.md']` トリガーの追加
- `workflow_dispatch` トリガーの追加 (before-sha = `github.sha^1`、after-sha = `github.sha` で変更ファイルを取得)
- `ca-get-changed-files` の拡張 (SHA 指定済みの場合はそれを優先使用する動作を追加)
- `ca-validate-environment` / `ca-get-changed-files` / `ca-setup-repo` の採用
- `pnpm run lint:text` と `pnpm run lint:markdown` による lint 実行

**Out of Scope**:

- reusable workflow (`ru-*`) の作成
- 他のワークフローファイルの変更
- textlint・markdownlint の設定変更
- lint ルールの追加・変更

## 2. Context

- Target Environment: GitHub Actions (ubuntu-latest)
- Related Components: `aglabo/ci-platform` (composite actions 提供元) 、`configs/textlintrc.yaml`、`configs/.markdownlint.yaml`
- Assumptions:
  - `aglabo/ci-platform` の composite actions は安定しており、`ca-get-changed-files` は push / pull_request どちらのトリガーでも動作する
  - `ca-get-changed-files` は push イベントでは `github.event.before` (before-sha) と `github.sha` (after-sha) を、pull_request イベントでは PR の base SHA (before-sha) と head SHA (after-sha) を使って変更ファイルリストを出力する
  - `ca-get-changed-files` は before-sha がオールゼロ (初回 push・新規ブランチ作成時) の場合、自動的に空ツリー SHA にフォールバックしてリポジトリ全ファイルとの差分を返す。caller 側での特別処理は不要
  - `ca-setup-repo` は Node.js / pnpm のセットアップと `pnpm install` まで行うため、別途インストールステップは不要

### System Context Diagram

```text
[Developer]    --> +---------------------------+ --> [GitHub Actions Runner]
                   |   ci-lint-articles.yaml   |
[GitHub Push]  --> +---------------------------+ --> [textlint / markdownlint]
                            |         ^
                            v         |
               [aglabo/ci-platform composite actions]
```

## 3. Design Decisions (Summary)

| ID    | Decision                                                                                       | Linked Record |
| ----- | ---------------------------------------------------------------------------------------------- | ------------- |
| DR-01 | composite actions を直接呼び出す (reusable workflow なし)                                      | —             |
| DR-02 | ca-setup-repo で aglabo/ci-platform をセットアップする                                         | —             |
| DR-03 | push トリガーは main ブランチのみ対象とする                                                    | —             |
| DR-04 | ca-get-changed-files は SHA 指定済みの場合はそれを優先し、未指定時のみイベントから自動取得する | —             |
| DR-07 | 使用するすべての Action を commit SHA で固定する (サプライチェーンリスク対策)                  | —             |
| DR-05 | REQ-NF-001 を MUST に昇格、REQ-NF-003 を REQ-C-001 に統合                                      | —             |
| DR-06 | workflow_dispatch トリガーを REQ-F-007 として独立した要件に分離                                | —             |

## 4. Functional Requirements

### REQ-F-001: push トリガーでの lint 実行

- EARS Type: event-driven

```text
GIVEN main ブランチへの push が発生し、変更ファイルに *.md が含まれる
  WHEN GitHub Actions の push イベントが発火する
THEN the system SHALL lint:text および lint:markdown を実行し、エラーがある場合はワークフローを失敗させる。
```

**Rationale**: PR 時だけでなく main への直接 push 時も lint を保証するため。

**Acceptance Criteria**:

| AC ID  | Scenario                                      |
| ------ | --------------------------------------------- |
| AC-001 | main への push で lint が実行される           |
| AC-002 | *.md 以外の変更のみでは lint がスキップされる |

### REQ-F-002: pull_request トリガーでの lint 実行 (既存動作の維持)

- EARS Type: event-driven

```text
GIVEN main ブランチへの pull_request が作成または更新され、変更ファイルに *.md が含まれる
  WHEN GitHub Actions の pull_request イベントが発火する
THEN the system SHALL lint:text および lint:markdown を実行し、エラーがある場合はワークフローを失敗させる。
```

**Rationale**: 既存の PR lint 動作を回帰させないため。

**Acceptance Criteria**:

| AC ID  | Scenario                                      |
| ------ | --------------------------------------------- |
| AC-003 | PR 作成時に lint が実行される                 |
| AC-004 | lint エラーがある場合 PR チェックが失敗になる |

### REQ-F-003: ca-validate-environment による環境検証

- EARS Type: event-driven

```text
GIVEN GitHub Actions ジョブが開始される
  WHEN lint ジョブの最初のステップが実行される
THEN the system SHALL ca-validate-environment を実行し、runner 環境と権限を検証する。
```

**Rationale**: 実行環境の事前検証によりデバッグを容易にするため。

**Acceptance Criteria**:

| AC ID  | Scenario                           |
| ------ | ---------------------------------- |
| AC-005 | 環境検証ステップが最初に実行される |

### REQ-F-004: ca-get-changed-files による変更ファイル取得

- EARS Type: event-driven

```text
GIVEN push、pull_request、または workflow_dispatch イベントが発生する
  WHEN 変更ファイルの取得ステップが実行される
THEN the system SHALL ca-get-changed-files を呼び出して変更された *.md ファイルのリストを取得し、後続のステップで利用可能にする。
```

**Notes**:

SHA 解決ルール (ca-get-changed-files の動作):

- before-sha / after-sha が指定済みの場合はそれを優先使用する
- 未指定の場合はイベント種別から自動取得する
  - push イベント: before-sha = `github.event.before`、after-sha = `github.sha`
  - pull_request イベント: before-sha = PR base SHA、after-sha = PR head SHA

caller 側の責務:

- workflow_dispatch 時は caller が before-sha = `github.sha^1`、after-sha = `github.sha` を渡す

**Rationale**: 変更されたファイルのみを lint することで実行時間を短縮し、無関係なファイルへの誤検知を防ぐため。

**Acceptance Criteria**:

| AC ID  | Scenario                                                              |
| ------ | --------------------------------------------------------------------- |
| AC-006 | 変更された *.md ファイルのみがリストアップされる                      |
| AC-007 | count == 0 の場合、lint ステップがスキップされ warning で正常終了する |

### REQ-F-005: ca-setup-repo による ci-platform セットアップ

- EARS Type: event-driven

```text
GIVEN lint ジョブが実行される
  WHEN 環境セットアップステップが実行される
THEN the system SHALL ca-setup-repo を使って aglabo/ci-platform リポジトリをチェックアウトし、ツールを PATH に追加する。
```

**Rationale**: ci-platform の composite actions と関連ツールを利用可能にするため。

**Acceptance Criteria**:

| AC ID  | Scenario                                                  |
| ------ | --------------------------------------------------------- |
| AC-008 | ca-setup-repo 実行後に ci-platform ツールが利用可能になる |

### REQ-F-006: pnpm による lint 実行

- EARS Type: event-driven

```text
GIVEN ca-get-changed-files の count が 1 以上である
  WHEN lint 実行ステップが動作する
THEN the system SHALL 変更ファイルリストから存在しないファイルを除外し、
  残ったファイルを対象に pnpm run lint:text および pnpm run lint:markdown を実行し、
  結果を GitHub Actions のログに出力する。
  削除済みファイルはスキップし「deleted → skip」をログに出力する。
```

```text
GIVEN ca-get-changed-files の count が 0 である
  WHEN lint 実行ステップが評価される
THEN the system SHALL lint ステップをスキップし、warning メッセージをログに出力して正常終了する。
```

**Rationale**: 既存の lint スクリプトを再利用し、実行方法の一貫性を保つため。変更ファイルがない場合は lint 不要であり、warning で通知して成功扱いとする。削除済みファイルの存在チェックは caller 側の責務とし、`ca-get-changed-files` の責務範囲を超えない設計とする。

**Acceptance Criteria**:

| AC ID  | Scenario                                                           |
| ------ | ------------------------------------------------------------------ |
| AC-009 | textlint と markdownlint が両方実行される                          |
| AC-010 | lint エラー時にワークフローが非ゼロで終了する                      |
| AC-013 | count == 0 の場合、lint がスキップされ warning ログが出力される    |
| AC-014 | 削除済みファイルはスキップされ「deleted → skip」がログに出力される |

### REQ-F-007: workflow_dispatch トリガーでの lint 実行

- EARS Type: event-driven

```text
GIVEN workflow_dispatch イベントが発生する
  WHEN lint ジョブが起動する
THEN the system SHALL before-sha に github.sha^1 を、after-sha に github.sha を設定して
  ca-get-changed-files に渡し、変更された *.md ファイルをリストアップして lint を実行する。
```

**Rationale**: 手動実行時も最新コミットで変更されたファイルを、lint の対象にするため。

**Acceptance Criteria**:

| AC ID  | Scenario                                                             |
| ------ | -------------------------------------------------------------------- |
| AC-011 | workflow_dispatch 実行時に lint が起動する                           |
| AC-012 | workflow_dispatch 時は github.sha^1 と github.sha の差分が対象になる |

## 5. Non-Functional Requirements

### REQ-NF-001: Maintainability

ワークフローファイルは composite actions の呼び出しを中心に構成しなければならない (MUST) 。lint ロジックをワークフロー内に直接埋め込んではならない。

### REQ-NF-002: Reusability

ci-platform の composite actions は外部リポジトリ (`aglabo/ci-platform`) から参照しなければならない (MUST) 。ワークフロー内にコピーしてはならない。

## 6. Constraints

### REQ-C-001: fetch-depth 制約

`ca-get-changed-files` は git の履歴全体を必要とするため、`actions/checkout` の `fetch-depth` は `0` に設定しなければならない。

### REQ-C-002: push トリガー対象ブランチ

push トリガーは `main` ブランチのみを対象とする。feature ブランチへの push では lint は実行しない。

### REQ-C-003: paths フィルター

push / pull_request トリガーともに `paths: ['**/*.md']` フィルターを設定し、Markdown 以外の変更では lint ジョブを起動しない。

### REQ-C-004: 使用するすべての Action の SHA 固定

ワークフローで使用するすべての Action (`actions/checkout`、`ca-validate-environment`、`ca-get-changed-files`、`ca-setup-repo` を含む) は commit SHA で固定しなければならない。ブランチ名や可変タグの使用は禁止する。

### REQ-C-005: 実装順序

`ci-lint-articles.yaml` の実装に先立ち、`ca-get-changed-files` の SHA 指定優先動作 (DR-04) を先に実装しなければならない。

## 7. User Stories

| Story ID | Role      | Goal                                                     | Reason                                       | Related Requirements |
| -------- | --------- | -------------------------------------------------------- | -------------------------------------------- | -------------------- |
| US-001   | 開発者    | main に push した際に自動で lint されたい                | PR を経由しない変更でも品質を保証するため    | REQ-F-001, REQ-F-004 |
| US-002   | 開発者    | PR 作成時に lint が実行されることを確認したい            | 既存の開発フローを維持するため               | REQ-F-002, REQ-F-004 |
| US-003   | 開発者    | 変更したファイルだけが lint されてほしい                 | 実行時間を短縮し、無関係なエラーを避けるため | REQ-F-004            |
| US-004   | CI 管理者 | composite actions を使ったシンプルなワークフローにしたい | 保守性を高め、共通基盤の恩恵を受けるため     | REQ-F-003, REQ-F-005 |
| US-005   | CI 管理者 | lint ツールのセットアップを ci-platform に統一したい     | セットアップロジックの重複をなくすため       | REQ-F-005            |

## 8. Acceptance Criteria

```gherkin
# AC-001: main への push で lint が実行される
# Requirement: REQ-F-001
Scenario: main への *.md push で lint が起動する
  Given main ブランチに *.md ファイルを含む push がある
  When  GitHub Actions の push イベントが発火する
  Then  ci-lint-articles ワークフローが起動し lint が実行される

# AC-002: *.md 以外の変更では lint がスキップされる
# Requirement: REQ-F-001
Scenario: 非 Markdown push では lint がスキップされる
  Given main ブランチに *.md を含まない push がある
  When  GitHub Actions の push イベントが発火する
  Then  ci-lint-articles ワークフローは起動しない (paths フィルターにより)

# AC-003: PR 作成時に lint が実行される
# Requirement: REQ-F-002
Scenario: PR 作成時に lint が起動する
  Given main ブランチへの pull_request が作成された
  When  GitHub Actions の pull_request イベントが発火する
  Then  ci-lint-articles ワークフローが起動し lint が実行される

# AC-006: 変更された *.md ファイルのみがリストアップされる
# Requirement: REQ-F-004
Scenario: ca-get-changed-files が差分ファイルを正しく返す
  Given push、pull_request、または workflow_dispatch イベントが発生した
  When  ca-get-changed-files ステップが実行される
  Then  変更された *.md ファイルのパスのみが出力される

# AC-010: lint エラー時にワークフローが失敗する
# Requirement: REQ-F-006
Scenario: lint エラーでワークフローが失敗する
  Given 変更された *.md ファイルに lint エラーが含まれる
  When  pnpm run lint:text または lint:markdown が実行される
  Then  ワークフローが非ゼロ終了コードで失敗する
```

## 9. Open Questions

| Question                       | Type | Impact Area | Owner |
| ------------------------------ | ---- | ----------- | ----- |
| (未解決の Open Questions なし) | —    | —           | —     |

## 10. Traceability

| REQ ID     | AC IDs                         | Type           |
| ---------- | ------------------------------ | -------------- |
| REQ-F-001  | AC-001, AC-002                 | Functional     |
| REQ-F-002  | AC-003, AC-004                 | Functional     |
| REQ-F-003  | AC-005                         | Functional     |
| REQ-F-004  | AC-006, AC-007                 | Functional     |
| REQ-F-005  | AC-008                         | Functional     |
| REQ-F-006  | AC-009, AC-010, AC-013, AC-014 | Functional     |
| REQ-F-007  | AC-011, AC-012                 | Functional     |
| REQ-NF-001 | N/A                            | Non-Functional |
| REQ-NF-002 | N/A                            | Non-Functional |
| REQ-C-001  | N/A                            | Constraint     |
| REQ-C-002  | N/A                            | Constraint     |
| REQ-C-003  | N/A                            | Constraint     |
| REQ-C-004  | N/A                            | Constraint     |
| REQ-C-005  | N/A                            | Constraint     |

## 11. Change History

| Date       | Version | Description                                                                                                       |
| ---------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| 2026-06-22 | 1.0.0   | Initial release                                                                                                   |
| 2026-06-22 | 1.0.1   | harden review: REQ-NF-001 を MUST 昇格、REQ-NF-003 削除 (REQ-C-001 統合) 、REQ-F-007 追加 (DR-05、DR-06)          |
| 2026-06-22 | 1.0.2   | fix review: 要件順序を番号順に整理、MUST 記述スタイル統一、REQ-F-004 Notes 分離、AC-006 に workflow_dispatch 追加 |
| 2026-06-22 | 1.0.3   | REQ-F-006 に count == 0 スキップ動作を追加 (warning で正常終了) 、AC-007/AC-013 追加                              |
| 2026-06-22 | 1.0.4   | REQ-C-004 をすべての Action の SHA 固定に拡張 (DR-07 追加)                                                        |
| 2026-06-22 | 1.0.5   | REQ-F-006 に削除済みファイルの caller 側スキップ処理を追加 (AC-014 追加)                                          |
| 2026-06-22 | 1.0.6   | Assumptions に初回 push 時の空ツリー SHA フォールバック動作を明記 (ca-get-changed-files が自動処理)               |
