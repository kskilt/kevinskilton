# kevinskilton

Personal blog/site. Rails 8.1.3, deployed via Kamal to Fly.io.

## Stack conventions

- **Views/CSS:** Tailwind utility classes, not custom CSS.
- **JS:** Stimulus controllers under `app/javascript/controllers/`, wired through importmap (`config/importmap.rb`) — there is no JS bundler.
- **DB:** schema convention is `db/schema.rb`, not `structure.sql`.
- **Structure:** flat and small — `app/{models,controllers,views,jobs,mailers,helpers}`. There is no `lib/` domain layer, no authorization/policy gem, and no `CODEOWNERS` file. Don't assume any of these exist.
- **Tests:** RSpec, spec-mirrors-implementation (`app/models/foo.rb` ↔ `spec/models/foo_spec.rb`, etc.), factories in `spec/factories`.

## Running things

No Docker — everything runs directly from `bin/`:

- `bin/rspec` — tests
- `bin/rubocop` — lint
- `bin/brakeman` — security static analysis
- `bin/bundler-audit`, `bin/importmap audit` — dependency vulnerability scans

Run targeted checks for changed files, not the full suite, unless asked otherwise.

## Agent workflow

For non-trivial changes, use the locate → implement → validate pattern instead of doing broad exploration directly in the main conversation:

1. **`rails-locator`** — read-only investigation of one bounded question. Returns a structured handoff (current behavior, relevant files/tests, constraints, likely scope, risks, open questions). Never edits files.
2. **`scoped-implementer`** — implements from the task, acceptance criteria, and the locator's handoff, without repeating broad discovery. Runs targeted checks. Never commits.
3. **`diff-validator`** — independent read-only review of the resulting diff against the task and acceptance criteria. Never edits files.

Skip an agent when the task is trivial enough that using one would just be overhead — e.g. a one-file, low-risk change doesn't need the full pipeline. Agent definitions live in `.claude/agents/`.

## `docs/agent-context/`

- `INDEX.md` — index of decision and active task records. Consult it before broad investigation when a question looks like it might overlap prior work.
- `decisions/` — ADRs for durable, non-obvious architectural decisions only. Not for routine implementation choices or local bug fixes. See `decisions/README.md`.
- `tasks/` — ephemeral per-task notes, created only when they materially help a multi-session handoff. See `tasks/README.md`.

Create new entries with `bin/agent-context new-decision "Title"` or `bin/agent-context new-task "Title"` — it numbers files and updates the index consistently. `bin/agent-context list` prints the current index.

## Git

Never commit or push unless explicitly asked.
