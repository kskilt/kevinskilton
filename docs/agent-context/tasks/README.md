# Task records

Temporary, ephemeral notes for a single in-flight task — not durable documentation. Create one only when it materially improves a locator → implementer handoff (e.g. investigation spans multiple sessions, or the scope is large enough that re-deriving it later would be wasteful).

Most tasks should **not** create one — the locator's handoff, held in the conversation, is enough on its own.

## Creating one

Run `bin/agent-context new-task "Title"`.

## At task completion

State explicitly whether the record should be:

- **deleted** — task complete, no lasting value (the default),
- **reset** — task abandoned or restarted,
- **retained** — promoted to a decision record, or still needed for a follow-up.
