#!/usr/bin/env bash
# Download MMLU-Pro dataset. Run once.
set -euo pipefail

mkdir -p data

echo "Downloading MMLU-Pro..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
ds = load_dataset('TIGER-Lab/MMLU-Pro', split='test')
samples = list(ds)
random.shuffle(samples)
samples = samples[:50]

out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in samples:
        options = row['options']
        answer_idx = row['answer_index']
        answer_letter = chr(65 + answer_idx) if isinstance(answer_idx, int) else row['answer']
        f.write(json.dumps({
            'question': row['question'],
            'options': options,
            'answer': answer_letter,
            'category': row.get('category', ''),
        }) + '\n')

print(f'Wrote {len(samples)} problems to {out}')
"

echo "Done. $(wc -l < data/test.jsonl) problems in data/test.jsonl"
