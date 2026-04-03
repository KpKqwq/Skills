#!/usr/bin/env bash
set -euo pipefail

repo=""
message=""
declare -a files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="$2"
      shift 2
      ;;
    --message)
      message="$2"
      shift 2
      ;;
    --files)
      shift
      while [[ $# -gt 0 ]]; do
        files+=("$1")
        shift
      done
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$repo" || -z "$message" || ${#files[@]} -eq 0 ]]; then
  echo "Usage: $0 --repo <repo> --message <message> --files <file1> [file2 ...]" >&2
  exit 2
fi

if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository: $repo" >&2
  exit 2
fi

# Stage only the requested paths so unrelated local work stays untouched.
git -C "$repo" add -- "${files[@]}"

if git -C "$repo" diff --cached --quiet -- "${files[@]}"; then
  echo "No staged changes for requested files; skipping commit."
  exit 0
fi

git -C "$repo" commit -m "$message" >/dev/null

commit_hash=$(git -C "$repo" rev-parse --short HEAD)
commit_subject=$(git -C "$repo" log -1 --pretty=%s)

echo "Created commit $commit_hash $commit_subject"
