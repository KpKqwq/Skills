---
name: git-checkpoint-commit
description: Create local rollback commits after Codex edits in a git repository. Use when the user wants every code change to be reversible, asks for automatic local git commits/checkpoints after edits, or is debugging/iterating and needs a safe point to return to after each Codex modification.
---

# Git Checkpoint Commit

Treat git checkpoints as part of the editing workflow.

## Workflow

1. Confirm the current repo root with `git rev-parse --show-toplevel` before editing if the repo is unclear.
2. Inspect `git status --short` before editing so you can avoid staging unrelated user changes.
3. Make the requested code changes normally.
4. After the edits are complete, create one local checkpoint commit that includes only the files you changed for this task.
5. Report the commit hash and subject in the final response so the user can roll back easily.

## Commit Rules

- Never use `git add -A` or `git commit -a` when the worktree is dirty.
- Stage only the files you intentionally changed for this task.
- Leave unrelated modified or untracked files untouched.
- Use a clear local-only message such as `codex checkpoint: <task>`.
- If there are no code changes, skip the commit and say so.
- If the repository is not a git repo, or committing would be unsafe, explain why before proceeding.

## Command

Use `scripts/checkpoint_commit.sh` to create the checkpoint commit.

Example:

```bash
/data/liukang/experinments_all/LRL/.codex/skills/git-checkpoint-commit/scripts/checkpoint_commit.sh \
  --repo /path/to/repo \
  --message "codex checkpoint: adjust opsd rollout config" \
  --files workspace/src/self_distill_hybrid/opsd_worker.py workspace/scripts/sft/train_opsd.sh
```

## Final Response

Include:

- whether a checkpoint commit was created
- the commit hash
- the commit subject
- a short note that unrelated local changes were left unstaged if that applied
