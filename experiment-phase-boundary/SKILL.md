---
name: experiment-phase-boundary
description: Enforce strict separation between dataset construction, training, and inference/evaluation in ML experiments. Use when Codex is preparing data, launching training, running inference, reproducing results, or auditing an experiment and there is risk of mixing prompts, datasets, templates, checkpoints, or evaluation settings across phases.
---

# Experiment Phase Boundary

Treat every experiment as three distinct phases:
- data prep
- train
- infer/eval

Never silently cross phase boundaries. Before running training or inference, identify and restate the exact input artifacts for that phase.

## Core Rules

- Freeze phase inputs. Name the exact dataset, prompt template, checkpoint, config, and output path before execution.
- Do not reuse a dataset or prompt source from another experiment family without explicit confirmation.
- Do not modify data-prep code while validating training or inference behavior. Stop and surface the mismatch first.
- Do not report experimental conclusions until the phase contract is written down and checked against the actual files.
- When a user says an earlier experiment matters, inspect the actual training logs/configs instead of assuming the intended setup was used.

## Phase Contract

For each phase, write a short contract in the reply before running anything substantial:

- `Goal`: what this phase is trying to produce
- `Inputs`: concrete files, tables, checkpoints, templates
- `Codepath`: exact script/module to run
- `Outputs`: exact output files/dirs expected
- `Non-goals`: what must not change in this phase

If any of these are unclear, inspect files first. Ask only if local evidence cannot resolve it.

## Data Prep

Use this phase for dataset extraction, prompt construction, prefix building, filtering, and splits.

- Inspect source fields and a few real rows before deriving a new dataset.
- Record prompt/template text exactly, not approximately.
- Save derived artifacts to a new path; do not overwrite canonical inputs.
- Emit a compact audit note: row count, source path, prompt format, filters, and known contamination risks.
- If training/inference later uses a different prompt wrapper than data prep, call that out as a mismatch immediately.

Read `references/phase-checklist.md` when building or auditing a dataset contract.

## Train

Use this phase for launching or resuming optimization only.

- Confirm the train dataset path from logs/config, not memory.
- Confirm whether generation uses `sft_prompt`, `sd_prompt`, packed prompts, fixed prefixes, or another field.
- Separate teacher construction from student training in the explanation.
- Treat checkpoint evaluation requests as inference/eval, not training.
- If the user asks to "just continue training," still restate dataset path, teacher source, and prompt mode first.

## Infer/Eval

Use this phase for baseline checks, checkpoint comparisons, ablations, and teacher/student evaluation.

- State whether the prompt path matches training generation, training teacher scoring, or neither.
- Compare baseline and experimental runs with the same dataset slice and prompt renderer unless the point is prompt ablation.
- Save outputs and summaries separately from data-prep artifacts.
- When results look wrong, inspect one concrete rendered prompt and one concrete output before changing coefficients or hyperparameters.

## Mismatch Handling

If you detect a mismatch, stop the experimental chain and report it plainly:

```text
Mismatch found.
- Expected: <artifact/template/path>
- Actual: <artifact/template/path>
- Impact: <why this invalidates or weakens the conclusion>
- Safe next step: <audit / rebuild / rerun specific phase>
```

Do not paper over mismatches with "close enough".

## Experiment Summaries

When summarizing, separate facts from interpretation:
- `Verified`: directly confirmed from code, logs, or artifacts
- `Inferred`: likely but not fully confirmed
- `Invalidated`: prior assumption disproved by files

Prefer a short artifact ledger over a long narrative.
