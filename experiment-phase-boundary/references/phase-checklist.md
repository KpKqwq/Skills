# Phase Checklist

Use this checklist when an experiment can be derailed by prompt or dataset drift.

## Data Prep Contract

- source dataset path
- source columns actually used
- prompt renderer or literal template text
- filtering / truncation rules
- train/val/test split rule
- output artifact path
- sample rows inspected
- contamination or legacy-format risks

## Train Contract

- train script/module
- config file
- effective dataset path from logs/config
- model/checkpoint init path
- teacher source path
- student generation prompt field
- teacher scoring/logit prompt field
- output checkpoint dir

## Infer/Eval Contract

- eval script/module
- checkpoint or model path
- dataset path and slice
- prompt mode / renderer
- max tokens / sampling settings
- output json/jsonl/summary paths
- baseline comparator path

## Fast Audit Questions

Ask these before trusting a result:

1. Is the eval prompt the same as train generation prompt?
2. Is the teacher prompt the same object used during training, or only a proxy?
3. Did data prep already contain legacy instructions or duplicated suffixes?
4. Did we rebuild any artifact after changing template assumptions?
5. Are we comparing runs that differ in more than one axis?
