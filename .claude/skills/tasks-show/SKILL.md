---
name: tasks-show
description: Shows the current task list from a task management markdown file (default ~/claude_default_workspace/tasks/tasks.md) with per-section counts and a status summary, or drills into one task by ID (loads the linked detail file and fetches current GitHub issue/PR state via gh). Also surfaces orphaned detail files in the same directory that no row links to. Use when the user asks to see/show/list/summarize tasks, mentions a specific task ID (e.g., T6) to inspect, says "タスク見せて" / "タスク一覧" / "TODO 一覧" / "タスクの状態" / "現在のタスク" / "進捗確認" / "show tasks" / "list tasks" / "what's pending" / "what's in progress".
---

# tasks-show

## Purpose

Read the task management markdown file and present its contents in a digestible form. Read-only: this skill never writes to tasks.md, archive.md, or detail files.

## Inputs

- **target file**: optional first argument. Defaults to `~/claude_default_workspace/tasks/tasks.md` (or `$TASKS_FILE` if set)
- **selector**: optional second argument
  - omitted → **list mode**
  - matches `^T\d+$` → **detail mode** for that row ID

Tag/status filtering is intentionally out of scope until needed.

## List mode

1. Read the target file. Identify each section (heading + table) without depending on specific section names
2. For each table, print every data row as a compact bullet line, preserving:
   - ID
   - tracker URL (if a `#` column exists)
   - task title
   - tag(s) inline as code spans
   - the status cell verbatim (do not summarize or rewrite it)
3. Group bullets by section heading. Show per-section counts in the heading like `### 開発環境 (2)`
4. Append a **status summary** computed by bucketing each row's status cell with simple substring rules. Use these buckets in this exact order; classify each row into the first matching bucket:
   - `TODO` (matches "TODO")
   - `レビュー/承認待ち` (matches "レビュー" or "承認")
   - `他人待ち` (matches "待ち" but not classified above, or "deploy", "リリース", "コンプラ")
   - `進行中` (matches "Phase", "完了" appearing mid-string, "進行")
   - `完了` (matches a status starting with "完了" or "merged")
   - `その他` (fallback)

   Print as a small bullet list with counts. If a bucket is zero, omit it
5. Run **orphan detection** (see below) and append a notice if any orphans exist

## Detail mode

1. Locate the row whose ID column equals the selector. If no match, list all IDs and stop
2. Print a small key/value table for the row (ID, tracker URL, task, tags, status)
3. Resolve the detail link(s) from the "関連資料" or "詳細" column. For each linked path:
   - Resolve relative to the target file's directory
   - If the file exists, print its first 40 lines as a preview under a heading `### <filename>` with a note that it is truncated
   - If the file is missing, print a warning line
4. Fetch the live state of each tracker URL on the row in parallel via `gh`:
   - issue: `gh issue view <n> --repo <owner>/<repo> --json number,state,title,updatedAt`
   - PR: `gh pr view <n> --repo <owner>/<repo> --json number,state,isDraft,reviewDecision,mergedAt,title,updatedAt`
   - Print one line per URL with state and last update timestamp. If a call fails, print the URL with a `(gh failed)` marker; do not abort

## Orphan detection

1. List every `*.md` file in the target file's directory, excluding `tasks.md` and `archive.md`
2. Extract every relative-path link from tasks.md and archive.md (both files; archive references count)
3. Print as a notice any files in (1) that are not referenced from (2). Format:
   ```
   未追跡の詳細ファイル: foo.md, bar.md
   ```
4. If the count is zero, omit the notice entirely

## Output style

- Use the same terms as tasks.md does (e.g., 「ステータス」「関連資料」). Do not rename columns
- Do not editorialize on a row's status — copy the cell as written. Bucketing happens only in the summary
- Keep the whole output scannable. Long status cells stay on one line; do not wrap with `\n`
- This skill never modifies files. If the user asks for changes after viewing, hand off to [[tasks-sync]] or [[tasks-log-progress]]

## Cautions

- Section heading detection should accept any `##` heading. Do not hardcode section names
- A row may have multiple tracker URLs (e.g., issue + PR). Treat each URL as its own gh call in detail mode
- If the target file is not under a git repository, still run normally (no commit step in this skill anyway)
- Orphan detection is best-effort: a file referenced only from a CLAUDE.md or external doc may show up as orphan. Mention this in the notice if a user pushes back
