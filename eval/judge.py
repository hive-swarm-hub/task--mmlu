"""Evaluate agent.py on MMLU-Pro. Compares answer letters."""

import json
import subprocess
import sys


def main():
    with open(sys.argv[1]) as f:
        problems = [json.loads(line) for line in f]

    total = len(problems)
    correct = 0

    print(f"Evaluating {total} problems...", file=sys.stderr)

    for item in problems:
        try:
            result = subprocess.run(
                ["python3", "agent.py"],
                input=json.dumps(item), capture_output=True, text=True, timeout=60,
            )
            got = result.stdout.strip().upper()
        except (subprocess.TimeoutExpired, Exception):
            got = ""

        if got and got[0] == item["answer"][0]:
            correct += 1

    accuracy = correct / total
    print("---")
    print(f"accuracy:         {accuracy:.6f}")
    print(f"correct:          {correct}")
    print(f"total:            {total}")


if __name__ == "__main__":
    main()
