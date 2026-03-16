"""MMLU-Pro solver — the artifact agents evolve.

Takes an MCQ question on stdin (JSON with 'question' and 'options'),
prints the answer letter (A-J) on stdout.
"""

import sys
import os
import json

from openai import OpenAI


def solve(question: str, options: list[str]) -> str:
    """Answer an MMLU-Pro multiple choice question. Return A-J."""
    client = OpenAI()

    options_text = "\n".join(f"{chr(65+i)}. {o}" for i, o in enumerate(options))

    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": "Answer the multiple choice question. Reply with ONLY the letter (A through J)."},
            {"role": "user", "content": f"{question}\n\n{options_text}"},
        ],
        temperature=0,
        max_tokens=8,
    )

    answer = response.choices[0].message.content.strip().upper()
    for c in answer:
        if c in "ABCDEFGHIJ":
            return c
    return "A"


if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(solve(data["question"], data["options"]))
