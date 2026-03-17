#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MMLU-Pro..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib
ds = load_dataset('TIGER-Lab/MMLU-Pro', split='test')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "options": row["options"]}) + '\n')
print(f'Wrote {len(ds)} problems to {out}')
PY
echo "Done."
