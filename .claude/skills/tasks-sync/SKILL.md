---
name: tasks-sync
description: Reads tracker URLs (GitHub issues/PRs) from a task management markdown file, fetches each ticket's current state via gh, updates the matching status cell in place, and moves completed entries to archive.md with a closed date. Use when the user asks to sync tasks, refresh task statuses, archive completed tasks, run /sync-tasks, or mentions stale tasks.md / GitHub issue or PR state needing reconciliation.
---

# tasks-sync

## Purpose

Given a markdown task file that contains tracker (issue/PR) URLs, fetch the current state of each ticket and bring the in-file status descriptions up to date. Move finished items to an archive file.

## Design principles

- **Structure-agnostic**: do not depend on section names or column ordering. Treat the URL as the single source of truth
- **Provider-agnostic (OCP)**: dispatch per URL pattern. GitHub is the only supported provider today. New providers must be addable without changing existing handlers

## Supported URL patterns

### GitHub (current)
- `https://github.com/<owner>/<repo>/issues/<number>`
- `https://github.com/<owner>/<repo>/pull/<number>`

URLs outside the supported set are reported as "unsupported provider" in the final summary and skipped.

## Workflow

1. Resolve the target file: use `$1` if provided, otherwise `~/claude_default_workspace/tasks/tasks.md`
2. Read the file and extract every supported tracker URL. If one line contains multiple URLs, treat the entire line as one "entry" and fetch each URL within it
3. Fetch state for all extracted issues/PRs **in parallel** via `gh`:
   - issue: `gh issue view <n> --repo <owner>/<repo> --json number,state,closedAt,title`
   - PR: `gh pr view <n> --repo <owner>/<repo> --json number,state,isDraft,mergedAt,reviewDecision,title`
4. For each entry, derive the proposed status:
   - issue CLOSED → **complete (archive)**
   - related PR MERGED → **complete (archive)**
   - related PR `reviewDecision: APPROVED` and not yet merged → "review OK (awaiting merge)"
   - related PR open and unreviewed → "awaiting review (PR #N)"
   - issue OPEN with no related PR → leave as is
5. Diff the proposed status against the current text. Present only the entries that differ to the user, and ask for approval
6. Once approved:
   - Remove archive-bound rows from tasks.md and append them to `archive.md` in the same directory, adding a "完了日" (closed date) column formatted as `YYYY-MM-DD` from issue `closedAt` / PR `mergedAt`. Create archive.md if missing, mirroring the section layout of tasks.md
   - For the remaining diffs, use Edit to rewrite only the status cell on that line
7. If the directory is a git repository, stage the changed tasks.md / archive.md and create a single commit:
   - Subject: `sync: <updated> updated, <archived> archived` (omit zero counts)
   - Body: bulleted list of archived issue/PR numbers
   - Append `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` at the end
   - Skip the commit if nothing changed
8. Print a final summary:
   - Counts: updated / archived / unchanged
   - Unsupported-provider URL list (if any)
   - Failed `gh` call URL list (if any)
   - Created commit hash (if any)

## Cautions

- If a status cell is written as free-form prose and the right replacement is ambiguous, ask the user. Do not rewrite silently
- Lines with no URL are out of scope (treated as non-tracker tasks)
- Do not modify table column structure, headings, or related-document links
