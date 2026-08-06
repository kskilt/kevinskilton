# Decision records

Architecture Decision Records (ADRs) for durable, non-obvious decisions in this repo — the kind that would otherwise get re-litigated or silently violated by a future change.

## When to write one

Write an ADR only when a decision is:

- **durable** — it will still matter in 6+ months, and
- **non-obvious** — a future contributor, human or agent, could reasonably do the opposite without realizing it conflicts with a prior call.

Do not write one for a routine implementation choice, a local bug fix, or anything a reader could derive by just reading the code.

## Creating one

Run `bin/agent-context new-decision "Title"` — it numbers the file, fills in the template, and adds an entry to `../INDEX.md`. Then fill in the Context/Decision/Consequences sections by hand.
