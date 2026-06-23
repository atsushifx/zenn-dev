---
title: "Implementation Tasks: ci-lint-articles Composite Action Migration"
module: "workflows/lint-article"
status: Active
created: "2026-06-23"
source: specifications.md
---

<!-- textlint-disable
  ja-technical-writing/sentence-length
  -->
<!-- markdownlint-disable no-duplicate-heading -->

## Task Summary

| Test Target            | Scenarios | Cases | Status      |
| ---------------------- | --------- | ----- | ----------- |
| T-01: トリガー条件     | 3         | 4     | in progress |
| T-02: SHA 解決         | 3         | 4     | in progress |
| T-03: 変更ファイル取得 | 2         | 5     | in progress |
| T-04: lint 実行        | 4         | 8     | in progress |

---

## T-01: トリガー条件 (R-001)

### [正常] Normal Cases

#### T-01-01: push トリガー起動

- [ ] **T-01-01-01**: main ブランチへの *.md push で lint ジョブが起動する
  - Target: `ci-lint-articles.yaml` の `on.push` 定義
  - Scenario: Given main ブランチに `*.md` を含む push がある、When GitHub Actions の push イベントが発火する
  - Expected: Then YAML に `on.push.branches: [main]` かつ `on.push.paths: ['**/*.md']` が定義されていなければならない (MUST)

- [ ] **T-01-01-02**: main ブランチへの非 Markdown push で lint ジョブが起動しない
  - Target: `ci-lint-articles.yaml` の `on.push.paths` フィルター
  - Scenario: Given main ブランチに `*.md` を含まない push がある、When GitHub Actions の push イベントが発火する
  - Expected: Then `on.push.paths: ['**/*.md']` フィルターが定義されており、非 Markdown push ではジョブが起動しないこと (MUST)

#### T-01-02: pull_request トリガー起動

- [ ] **T-01-02-01**: main 向け PR に *.md 変更があれば lint ジョブが起動する
  - Target: `ci-lint-articles.yaml` の `on.pull_request` 定義
  - Scenario: Given main ブランチへの pull_request に `*.md` 変更が含まれる、When pull_request イベントが発火する
  - Expected: Then YAML に `on.pull_request.branches: [main]` かつ `on.pull_request.paths: ['**/*.md']` が定義されていなければならない (MUST)

#### T-01-03: workflow_dispatch トリガー起動

- [ ] **T-01-03-01**: workflow_dispatch で lint ジョブが起動する
  - Target: `ci-lint-articles.yaml` の `on.workflow_dispatch` 定義
  - Scenario: Given 任意のブランチから手動実行する、When `workflow_dispatch` イベントが発火する
  - Expected: Then YAML に `on.workflow_dispatch:` が定義されていなければならない (MUST)

---

## T-02: SHA 解決 (R-002)

### [正常] Normal Cases

#### T-02-01: workflow_dispatch で親コミットあり

- [ ] **T-02-01-01**: workflow_dispatch で HEAD^1 が取得でき GITHUB_ENV に書き込まれる
  - Target: `resolve-sha` ステップのシェルスクリプト
  - Scenario: Given `workflow_dispatch` イベント、かつ `git rev-list --parents -n 1 HEAD` が 2 フィールド以上を返す (親あり)
  - Expected: Then `BEFORE_SHA=<HEAD^1>`, `AFTER_SHA=<HEAD>` が `GITHUB_ENV` に書き込まれ、
    `skip=false` が `GITHUB_OUTPUT` に書き込まれなければならない (MUST) 。
    また `changed-files` ステップの `with.before-sha: ${{ env.BEFORE_SHA }}` / `with.after-sha: ${{ env.AFTER_SHA }}` が
    YAML に定義されていなければならない (MUST)

#### T-02-02: push / pull_request では空文字 SHA を設定

- [ ] **T-02-02-01**: push / PR 時は BEFORE_SHA / AFTER_SHA が空文字で GITHUB_ENV に書き込まれる
  - Target: `resolve-sha` ステップのシェルスクリプト
  - Scenario: Given `push` または `pull_request` イベント
  - Expected: Then `BEFORE_SHA=""`, `AFTER_SHA=""` が `GITHUB_ENV` に書き込まれ、`skip=false` が `GITHUB_OUTPUT` に書き込まれなければならない (MUST)

### [異常] Error Cases

#### T-02-03: workflow_dispatch で git コマンド失敗

- [ ] **T-02-03-01**: git rev-list がその他エラーで失敗した場合、ジョブが失敗する
  - Target: `resolve-sha` ステップのシェルスクリプト
  - Scenario: Given `workflow_dispatch` イベント、かつ `git rev-list` が非ゼロ終了する
  - Expected: Then ジョブが exit non-zero で失敗する

### [エッジケース] Edge Cases

#### T-02-04: workflow_dispatch で初回コミット (親なし)

- [ ] **T-02-04-01**: 初回コミット (parent 数 == 0) の場合、warning を出力して後続ステップをスキップする
  - Target: `resolve-sha` ステップのシェルスクリプト
  - Scenario: Given `workflow_dispatch` イベント、かつ `git rev-list --parents -n 1 HEAD` が 1 フィールド (親なし) を返す
  - Expected: Then `skip=true` が `GITHUB_OUTPUT` に書き込まれ、warning ログが出力され、exit 0 となる。
    後続の `changed-files` / `setup-repo` / `lint` ステップは `if: steps.resolve-sha.outputs.skip != 'true'` により実行されない

---

## T-03: 変更ファイル取得 (R-003 / R-004)

### [正常] Normal Cases

#### T-03-01: 環境検証ステップの配置順序

- [ ] **T-03-01-01**: `ca-validate-environment` が `checkout` の直後・他ステップより前に配置されている
  - Target: `ci-lint-articles.yaml` のステップ順序
  - Scenario: Given ワークフローが起動する、When ステップ定義を確認する
  - Expected: Then `validate-env` ステップが YAML のステップリスト上で `checkout` の直後 (2 番目) に定義されていなければならない (MUST) 。
    `resolve-sha` より前に配置されていること。また `checkout` の `fetch-depth: 0` が定義されていなければならない (MUST)

#### T-03-02: ca-get-changed-files で変更 *.md を取得

- [ ] **T-03-02-01**: changed-files ステップが BEFORE_SHA / AFTER_SHA を渡して実行される
  - Target: `changed-files` ステップの with パラメータ
  - Scenario: Given `resolve-sha` が完了し `GITHUB_ENV` に SHA が設定済み、When `changed-files` ステップが実行される
  - Expected: Then `ca-get-changed-files` に `pattern: '**/*.md'`、`before-sha: ${{ env.BEFORE_SHA }}`、
    `after-sha: ${{ env.AFTER_SHA }}` が渡されなければならない (MUST)

- [ ] **T-03-02-02**: skip=true の場合、changed-files ステップが実行されない
  - Target: `changed-files` ステップの `if:` 条件
  - Scenario: Given `resolve-sha` が `skip=true` を出力した、When `changed-files` ステップが評価される
  - Expected: Then `if: steps.resolve-sha.outputs.skip != 'true'` 条件が YAML の `changed-files` ステップに定義されており、
    `skip=true` 時にステップが実行されないこと (MUST)

#### T-03-02-03: ca-get-changed-files が失敗した場合、ジョブが失敗する

- [ ] **T-03-02-03**: `ca-get-changed-files` が非ゼロで終了した場合、ジョブが即時失敗する
  - Target: `changed-files` ステップ（composite action の失敗伝播）
  - Scenario: Given `ca-get-changed-files` が内部エラー等で非ゼロ終了する
  - Expected: Then GitHub Actions のデフォルト動作（`continue-on-error: false`）によりジョブが即時失敗する。
    `continue-on-error: true` が設定されていないこと (MUST)

### [エッジケース] Edge Cases

#### T-03-03: before-sha オールゼロ (初回 push)

- [ ] **T-03-03-01**: before-sha がオールゼロの場合、ca-get-changed-files が空ツリーとの差分にフォールバックする
  - Target: `ca-get-changed-files` の動作 (自作 composite action の契約)
  - Scenario: Given push イベント、かつ before-sha がオールゼロ (新規リポジトリへの最初の push)
  - Expected: Then `ca-get-changed-files` が自動的に空ツリー SHA にフォールバックし、リポジトリ全 `*.md` ファイルが `outputs.files` に含まれる

---

## T-04: lint 実行 (R-005)

### [正常] Normal Cases

#### T-04-00: ファイルリスト変換

- [ ] **T-04-00-01**: 改行区切りの outputs.files をスペース区切りに変換して lint ツールに一括渡しする
  - Target: `lint` ステップのシェルスクリプト（変換ロジック）
  - Scenario: Given `CHANGED_FILES` に改行区切りのファイルパスリストが格納されている
  - Expected: Then `printf '%s\n' "$CHANGED_FILES" | tr '\n' ' '` 等で変換し、
    削除済みファイルを除外したスペース区切りファイルリストを構築した上で、`textlint --config configs/textlintrc.yaml $FILES`
    および `markdownlint-cli2 --config configs/.markdownlint-cli2.yaml $FILES` に一括渡しすること (MUST)

#### T-04-01: 変更ファイルが存在する場合の lint 実行

- [ ] **T-04-01-01**: 存在するファイルに textlint が一括実行される
  - Target: `lint` ステップのシェルスクリプト (R-005d)
  - Scenario: Given `outputs.count` が 1 以上で、対象ファイルがファイルシステム上に存在する
  - Expected: Then T-04-00-01 で構築したスペース区切りファイルリストを引数として `textlint --config configs/textlintrc.yaml $FILES` が
    シェルスクリプト内に定義されていなければならない (MUST)

- [ ] **T-04-01-02**: textlint 成功後に markdownlint が一括実行される
  - Target: `lint` ステップのシェルスクリプト (R-005e)
  - Scenario: Given textlint が exit 0 で完了した
  - Expected: Then T-04-00-01 で構築したスペース区切りファイルリストを引数として
    `markdownlint --config configs/.markdownlint-cli2.yaml $FILES` がシェルスクリプト内に定義されていなければならない (MUST)

### [異常] Error Cases

#### T-04-02: lint エラーで即時失敗 (fail-fast)

- [ ] **T-04-02-01**: textlint が非ゼロで終了した場合、markdownlint を実行せずジョブが失敗する
  - Target: `lint` ステップのシェルスクリプト (R-005f)
  - Scenario: Given `textlint --config configs/textlintrc.yaml "$file"` が非ゼロで終了する
  - Expected: Then `bash -eo pipefail` で textlint が非ゼロ終了した時点でシェルスクリプトが停止し、`markdownlint` の呼び出し行に到達しないこと (MUST) 。
    ジョブが exit non-zero で終了しなければならない (MUST)

- [ ] **T-04-02-02**: CHANGED_COUNT が非数値の場合、ジョブが失敗する
  - Target: `lint` ステップの CHANGED_COUNT 数値検証
  - Scenario: Given `steps.changed-files.outputs.count` が空または数値以外の文字列
  - Expected: Then `[[ "$CHANGED_COUNT" =~ ^[0-9]+$ ]]` の検証が失敗し、ジョブが exit non-zero で終了する

### [エッジケース] Edge Cases

#### T-04-03: スキップシナリオ

- [ ] **T-04-03-01**: outputs.count が 0 の場合、lint をスキップして warning を出力し exit 0 になる
  - Target: `lint` ステップのシェルスクリプト (R-005a)
  - Scenario: Given `CHANGED_COUNT` が `"0"`
  - Expected: Then warning メッセージがログに出力され、lint を実行せず exit 0 で完了する

- [ ] **T-04-03-02**: 削除済みファイルを "deleted -> skip" でスキップする
  - Target: `lint` ステップのシェルスクリプト (R-005c)
  - Scenario: Given `outputs.files` に含まれるファイルがファイルシステム上に存在しない (削除済み)
  - Expected: Then `"deleted -> skip"` がログに出力され、そのファイルへの lint は実行されず次のファイルに進む (exit 0)

- [ ] **T-04-03-03**: 全ファイルが削除済みの場合でも exit 0 になる
  - Target: `lint` ステップのシェルスクリプト (R-005b / R-005c)
  - Scenario: Given `CHANGED_COUNT` が 1 以上、かつ `outputs.files` に含まれる全ファイルがファイルシステム上に存在しない
  - Expected: Then 全ファイルが `"deleted -> skip"` でスキップされ、lint を一切実行せず exit 0 で完了する

---

## Traceability

| Task ID    | Spec Rule      | Requirement |
| ---------- | -------------- | ----------- |
| T-01-01-01 | R-001a         | REQ-F-001   |
| T-01-01-02 | R-001d         | REQ-C-003   |
| T-01-02-01 | R-001b         | REQ-F-002   |
| T-01-03-01 | R-001c         | REQ-F-007   |
| T-02-01-01 | R-002a         | REQ-F-004   |
| T-02-02-01 | R-002d         | REQ-F-004   |
| T-02-03-01 | R-002c         | REQ-F-007   |
| T-02-04-01 | R-002b         | REQ-F-007   |
| T-03-01-01 | R-003          | REQ-F-003   |
| T-03-02-01 | R-004a, R-004b | REQ-F-004   |
| T-03-02-02 | R-002b (skip)  | REQ-F-007   |
| T-03-02-03 | R-004a         | REQ-F-004   |
| T-03-03-01 | R-004c         | REQ-F-004   |
| T-04-00-01 | R-005b         | REQ-F-006   |
| T-04-01-01 | R-004b, R-005d | REQ-F-006   |
| T-04-01-02 | R-004b, R-005e | REQ-F-006   |
| T-04-02-01 | R-005f         | REQ-F-006   |
| T-04-02-02 | R-005b (guard) | REQ-F-006   |
| T-04-03-01 | R-005a         | REQ-F-006   |
| T-04-03-02 | R-005c         | REQ-F-006   |
| T-04-03-03 | R-005b, R-005c | REQ-F-006   |
