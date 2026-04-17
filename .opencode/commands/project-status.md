---
description: Show current project status and suggest next action
agent: rails
---

# Current Project Status

Run these commands to understand where to start:

## 1. Check Plan Status
```bash
bin/dev-plan
```

Shows all plans with their completion status. Look for:
- Plans with "in_progress" status - these are actively being worked on
- Plans with high progress (90%+) - near completion

## 2. Find In-Progress Plan Tasks
```bash
bin/dev-plan <plan-name>
```

Example: `bin/dev-plan test-coverage` shows pending tasks in that plan.

## 3. Find Related Files
```bash
bin/dev-context <feature>
```

Example: `bin/dev-context health` finds all health-related files.

## Quick Start

The agent should:
1. Run `bin/dev-plan` to see current state
2. Pick an "in_progress" plan or start a new one
3. Use `bin/dev-spec <file>` when working on code
4. Run `bin/dev-commit` before making commits

## Session Tracking

Track progress during session:
```bash
bin/dev-session start     # At session start
bin/dev-session track    # After significant changes
bin/dev-session summary  # When asked "what did we do so far"
```