---
name: tasks-log-progress
description: Appends a dated progress note to the detail file linked from a task row in tasks.md, and optionally updates the matching status cell. Use when the user reports progress on an existing task (e.g., "PR opened", "review approved", "deployed to staging", "Phase 0 started"), mentions a task ID like T6 with an update, or asks to log a note against an existing task entry.
---

# tasks-log-progress

## Purpose

Record progress against an existing task without forcing the user to hand-edit two files. Given a task identifier and a free-form note, write a dated bullet into the task's detail file and (optionally) refresh the status cell in tasks.md.

## Inputs

- **Task identifier**: row ID (e.g. `T6`) or tracker URL (e.g. `https://github.com/scg-nxw/to2go/issues/8275`). Required
- **Note**: free-form progress text. Required
- **Status override**: optional new status string for the tasks.md status cell. If omitted, leave the cell untouched

## Resolution

1. Resolve the tasks index file in this order:
   1. The path passed via a `--tasks-file <path>` argument, if present
   2. The value of `$CLAUDE_TASKS_FILE` if set
   3. Ask the user for the path. Do not fall back to a hardcoded default
2. Locate the row matching the identifier:
   - If the identifier looks like a row ID (regex `^T\d+$`), match the ID column
   - Otherwise match by exact URL substring against any URL in the row
3. From the matched row, extract the detail-file link from the "関連資料" / "詳細" column. Resolve it relative to the tasks.md directory
4. If no detail file is linked, ask the user whether to create one (default name: `<id>-progress.md`) or to log into a section appended to tasks.md instead

## Append rule

In the detail file:

1. Find an existing `## 進捗ログ` section. If absent, append one at the end of the file
2. Under that section, append a single bullet:
   ```
   - YYYY-MM-DD: <note>
   ```
   Use the current local date. Do not reformat or wrap the user's note text
3. Preserve all other content. Do not edit prior bullets

## Status cell update

- If the user passed a status override, use Edit to rewrite only the status cell of the matched row in tasks.md. Leave every other column alone
- If not, do not touch tasks.md

## Commit

If the tasks directory is a git repository:

1. Stage the modified files (detail file, and tasks.md if changed)
2. Commit with subject `progress(<id>): <first 60 chars of note>` followed by:
   ```

   Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
   ```
3. If nothing changed, skip the commit

## Cautions

- Never overwrite or delete existing bullets in `## 進捗ログ`
- If the identifier matches multiple rows, list them and ask the user to disambiguate. Do not guess
- Do not auto-derive a status update from the note text. The user passes a status override explicitly, or the cell stays put
- Lines or files outside the matched row are out of scope
