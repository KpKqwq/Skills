---
name: paper-to-repro-config
description: Extract experimental configuration from machine learning papers for reproduction. Use this skill whenever the user asks to extract experimental settings from ML papers, research papers, PDFs, or URLs - especially when they mention "reproduction config", "experimental setup", "hyperparameters", or want to understand what's needed to reproduce paper results. This skill handles URLs, PDF files, and pasted paper text.
---

# Paper to Reproduction Config

Extract the experimental configuration needed to reproduce results from a machine learning paper.

## Goal

Create a `repro_config.md` file that contains everything needed to implement and reproduce the main experimental results from an ML paper. The output should be practical for someone who wants to:
- Implement the method from scratch
- Re-run the experiments to verify claims
- Identify what's missing or ambiguous before attempting reproduction

## Input Sources

The paper can be provided in three ways:
1. **URL**: A link to the paper (arXiv, OpenReview, conference site, etc.)
2. **PDF file**: A local PDF file path
3. **Pasted text**: Paper content pasted directly into the conversation

First, determine which input type the user has provided and access the paper content accordingly:
- For URLs, use a web fetch tool to get the content
- For PDFs, use a PDF reader tool to extract text
- For pasted text, work directly with what was provided

## Analysis Process

### Step 1: Understand the Paper's Core Contribution

Before extracting details, understand what the paper is about:
- What is the main method or contribution?
- What are the key experimental claims being made?
- Which experiments are the "main" results that matter most?

This context helps you prioritize what details are critical for reproduction versus minor details that can vary.

### Step 2: Extract by Category

Go through the paper systematically and extract information into these categories. For each category, distinguish between:

- **[STATED]**: Directly stated in the paper (exact values, explicit descriptions)
- **[INFERRED]**: Not explicitly stated but reasonably inferred from context (e.g., "standard practice", "same as X", implied by context)
- **[MISSING]**: Not mentioned in the paper - this is a reproduction blocker
- **[AMBIGUOUS]**: Mentioned but unclear (conflicting info, multiple possible interpretations)
- **[EXTERNAL]**: Refers to external materials (supplementary materials, linked code, citation)

#### Model Architecture

- Model type, size, and structure
- Key architectural components and their configurations
- Number/dimensions of layers, attention heads, hidden sizes
- Any special architectural features or modifications

#### Training Setup

- **Optimizer**: Type, learning rate, momentum/weight decay, scheduler
- **Batch size**: Training and inference
- **Training duration**: Epochs, steps, tokens, or time
- **Hardware**: GPUs/TPUs used, memory requirements
- **Training tricks**: Warmup, gradient clipping, regularization techniques
- **Loss function**: What objective(s) are optimized

#### Data

- **Datasets**: Names, versions, splits (train/val/test)
- **Preprocessing**: Tokenization, normalization, augmentation
- **Data size**: Number of examples, tokens, or images
- **Data sources**: Download links, original sources

#### Evaluation

- **Metrics**: What's measured and how it's computed
- **Baselines**: What methods are compared against
- **Evaluation protocol**: How exactly is evaluation performed (e.g., few-shot prompts, test sets)

#### Implementation Details

- **Framework**: PyTorch, JAX, TensorFlow, etc.
- **Code availability**: Is there official code? Linked repository?
- **Random seeds**: Are seeds specified for reproducibility?

### Step 3: Structure and Save

Save all extracted information to `repro_config.md` with this exact structure:

```markdown
# Reproduction Config: [Paper Title]

## Paper Info
- **Title**: [full title]
- **Authors**: [authors]
- **Venue**: [conference/journal, year]
- **Source**: [URL or citation]

## Summary
[Brief 2-3 sentence description of the main method and what experiments reproduce]

---

## Model Architecture

### [STATED] Core Model
- Model type: [e.g., Transformer-based decoder]
- Parameters: [e.g., 7B]
- Architecture details: [key structural info]

### [INFERRED/MISSING/AMBIGUOUS/EXTERNAL]
[Additional architectural info with appropriate tags]

---

## Training Setup

### Optimizer
- [STATED] Type: [e.g., AdamW]
- [STATED] Learning rate: [e.g., 3e-4]
- [STATED] Weight decay: [e.g., 0.1]
- [INFERRED] Scheduler: [e.g., Cosine with 3% warmup - standard practice mentioned]

### Batch & Duration
- [STATED] Batch size: [training and inference]
- [STATED] Training steps: [or epochs/tokens]
- [MISSING] Hardware: [not specified - reproduction blocker]

### [Category]
[Continue with other training details...]

---

## Data

### [STATED] Datasets
- [Name]: [details]
- [Name]: [details]

### Preprocessing
- [STATED/INFERRED] Tokenization: [method]
- [EXTERNAL] Data filtering: [see supplementary material Section A]

---

## Evaluation

### [STATED] Metrics
- [Metric name]: [how computed]
- [Metric name]: [how computed]

### [STATED] Baselines
- [Baseline]: [version/details]

### Evaluation Protocol
[Describe exactly how evaluation is performed]

---

## Implementation & Code

- [STATED] Framework: [e.g., PyTorch 2.0]
- [EXTERNAL] Code: [GitHub link if available]
- [MISSING] Random seeds: [not specified]

---

## Known Issues / Blockers

List critical missing information that would prevent faithful reproduction:
1. [Hardware/compute requirements not specified]
2. [Data preprocessing details in supplementary materials only]
3. [etc.]

---

## Notes

[Any additional context that would help reproduction]
```

## Important Guidelines

1. **Be thorough but focused**: Capture what's needed to reproduce the main results, not every minor ablation study
2. **Tag everything**: Every piece of information should have a tag ([STATED], [INFERRED], [MISSING], [AMBIGUOUS], [EXTERNAL])
3. **Flag blockers prominently**: The "Known Issues / Blockers" section is critical - it tells users what they need to figure out before attempting reproduction
4. **Preserve numeric precision**: Keep exact numbers when stated (e.g., "0.0003" not "~3e-4")
5. **Link to externals**: If the paper references supplementary materials or code, note this clearly - the user will need to fetch those
6. **Handle "same as prior work"**: Many papers say "we use the same setup as X" - tag as [EXTERNAL] and note what X is
7. **Distinguish main vs. ablation**: Focus on the main experimental setup. Ablation studies are secondary.

## After Creating the Config

When you've created `repro_config.md`, briefly summarize for the user:
- What type of paper this was (e.g., "A 7B language model trained on web data")
- How complete the information was (e.g., "Most details stated, but hardware requirements missing")
- Any critical blockers they should know about

This helps the user quickly understand whether reproduction is feasible with the available information.
