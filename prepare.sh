#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MMLU-Pro..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)

dev = list(load_dataset('TIGER-Lab/MMLU-Pro', split='validation'))
random.shuffle(dev)
dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in dev[:150]:
        f.write(json.dumps({'question': row['question'], 'answer': row['answer'], 'options': row['options']}) + '
')

test = list(load_dataset('TIGER-Lab/MMLU-Pro', split='test'))
random.shuffle(test)
test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in test[:150]:
        f.write(json.dumps({'question': row['question'], 'answer': row['answer'], 'options': row['options']}) + '
')

print(f'Dev:  150 problems -> {dev_out}')
print(f'Test: 150 problems -> {test_out}')
"
echo "Done."
