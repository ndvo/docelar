# Agent Developer Experience Plan

Tools and improvements to make the agent work easier and faster.

## Current Problems

~~1. **Session tracking** - No automatic way to summarize what was done in a session~~
~~2. **Spec running** - Running full suite or manually specifying files is slow~~
~~3. **Context retrieval** - Hard to find all files related to a feature across codebase~~
~~4. **Plan documents** - Agent doesn't automatically read plan at session start~~
~~5. **Guard monitoring** - Agent can't watch continuous output in real-time~~
6. **Code quality** - No unified lint/typecheck command
7. **Database resets** - No quick way to reset test database

## Proposed Tools

### 1. Session Tracker

Auto-generate summary of changes made in current session.

**Features:**
- Track files modified (git status)
- Track specs run and results
- Track decisions made
- Generate "what did we do so far?" summary

**Implementation:**
- Could use git hooks to track file changes
- Simple CLI tool to output session summary

### 2. Smart Spec Runner

Given a file path, run related specs.

**Features:**
- Input: file path (e.g., `app/models/dog.rb`)
- Output: run relevant specs automatically
- Detect if model spec, controller spec, feature spec exists
- Run just those specs

**Examples:**
```
$ smart-spec app/models/dog.rb
→ runs spec/models/dog_spec.rb

$ smart-spec app/views/dogs/show.html.erb
→ runs spec/features/dogs_spec.rb (or similar)
```

### 3. Commit Planner

Analyze staged/unstaged changes and suggest logical commit groupings.

**Features:**
- Run `git diff --stat` on staged/unstaged
- Group by file type (models, views, controllers, specs)
- Suggest conventional commit messages
- Interactive: show plan, ask user to approve

**Implementation:**
- Simple Ruby CLI that analyzes file paths
- Groups by conventional commit types

### 4. Context Retriever

Given a feature name, find all relevant files.

**Features:**
- Input: feature name (e.g., "patient management")
- Output: list of relevant files
- Search models, views, controllers, specs
- Could use code search or naming conventions

**Examples:**
```
$ context patient
→ app/models/patient.rb
→ app/controllers/patients_controller.rb
→ app/views/patients/
→ spec/features/patient_management_spec.rb
```

### 5. Plan Document Reader

At session start, parse plan document and suggest first action.

**Features:**
- Detect plan files in `docs/*-plan.md`
- Read plan and extract pending tasks
- Suggest next step based on plan state

**Implementation:**
- Could be part of session initialization
- Read plan, show "in progress" and "pending" items

## Implemented Tools

### 1. Session Tracker (`bin/dev-session`)

```bash
bin/dev-session start        # Start tracking a new session
bin/dev-session track        # Track current file changes
bin/dev-session summary      # Show what was done in session
bin/dev-session spec "5 examples, 0 failures"  # Track spec results
bin/dev-session commit abc123  # Track a commit
```

### 2. Smart Spec Runner (`bin/dev-spec`)

```bash
bin/dev-spec app/models/dog.rb          # → runs spec/models/dog_spec.rb
bin/dev-spec app/controllers/dogs_controller.rb  # → runs spec/requests/dogs_spec.rb
bin/dev-spec app/views/dogs/show.html.erb  # → runs spec/features/dogs_spec.rb
```

### 3. Context Retriever (`bin/dev-context`)

```bash
bin/dev-context patient   # Find all patient-related files
bin/dev-context dog       # Find all dog-related files
bin/dev-context payment   # Find all payment-related files
```

### 4. Commit Planner (`bin/dev-commit`)

```bash
bin/dev-commit  # Shows staged/unstaged changes and suggests commit groupings
```

### 5. Guard Monitor (`bin/dev-guard`)

```bash
dev:guard start   # Start guard with log output
dev:guard log    # Tail guard log in real-time
dev:guard stop   # Stop guard
dev:guard status # Check if guard is running
dev:guard run spec/models/dog_spec.rb  # Run single spec
```

---

## Proposed New Tools

~~### 6. Guard Monitor~~ ✅ Complete
~~### 7. Code Quality Runner~~ ✅ Complete

### 8. Database Reset

Quick reset for test database.

### 9. Web Page Checker

Verify pages load without errors after changes.

**Features:**
- Input: URL or path (e.g., `/patients`, `/dogs/1`)
- Check if page returns 200, no errors
- Useful for catching errors before telling user "it's done"

**Examples:**
```
dev:curl /patients          # Check patients index
dev:curl /dogs/new          # Check new dog form
dev:curl /health_hub/1      # Check health hub
```

### 10. Rails Shortcuts

Quick Rails commands.

**Commands:**
- `dev:rails console` - Open console
- `dev:rails routes` - List routes
- `dev:rails gen model Foo` - Generate model
- `dev:rails migrate` - Run migrations

---

## Implementation Status

| Tool | Status | File |
|------|--------|------|
| Smart Spec Runner | ✅ Complete | bin/dev-spec |
| Context Retriever | ✅ Complete | bin/dev-context |
| Commit Planner | ✅ Complete | bin/dev-commit |
| Session Tracker | ✅ Complete | bin/dev-session |
| Plan Document Reader | ✅ Complete | bin/dev-plan |
| Guard Monitor | ✅ Complete | bin/dev-guard |
| Code Quality Runner | ✅ Complete | bin/dev-quality |
| Web Page Checker | ✅ Complete | bin/dev-curl |
| Database Reset | ⏳ Pending | - |
| Rails Shortcuts | ⏳ Pending | - |

## Design Principles

1. **Simple CLI tools** - Prefer single-purpose tools over complex frameworks
2. **Work with existing tools** - Use git, rspec, grep - don't reinvent
3. **Fast feedback** - Tools should complete in < 2 seconds
4. **Composable** - Tools should work well together
