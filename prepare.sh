#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MMLU-Pro..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib, random
random.seed(42)
val = list(load_dataset('TIGER-Lab/MMLU-Pro', split='validation'))
random.shuffle(val)
with pathlib.Path('data/train.jsonl').open('w') as f:
    for row in val[:100]:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "options": row["options"]}) + '\n')
test = list(load_dataset('TIGER-Lab/MMLU-Pro', split='test'))
random.shuffle(test)
with pathlib.Path('data/test.jsonl').open('w') as f:
    for row in test[:150]:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "options": row["options"]}) + '\n')
print('Train: 100, Test: 150')
PY
echo "Done."
