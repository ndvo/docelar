# Agent Developer Experience Plan

Tools and improvements to make the agent work easier and faster.

## Current Problems

1. **Session tracking** - No automatic way to summarize what was done in a session
2. **Spec running** - Running full suite or manually specifying files is slow
3. **Context retrieval** - Hard to find all files related to a feature across codebase
4. **Plan documents** - Agent doesn't automatically read plan at session start
5. **Guard monitoring** - Agent can't watch continuous output in real-time

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

## Implementation Status

| Tool | Status | File |
|------|--------|------|
| Smart Spec Runner | ✅ Complete | bin/dev-spec |
| Context Retriever | ✅ Complete | bin/dev-context |
| Commit Planner | ✅ Complete | bin/dev-commit |
| Session Tracker | ⏳ Pending | - |
| Plan Document Reader | ⏳ Pending | - |

---

## Implementation Priority

| Tool | Priority | Notes |
|------|----------|-------|
| Smart Spec Runner | High | Most frequently needed |
| Context Retriever | High | Helps navigate codebase |
| Commit Planner | Medium | Nice to have for commits |
| Session Tracker | Medium | Useful for long sessions |
| Plan Document Reader | Low | Could be manual |

## Design Principles

1. **Simple CLI tools** - Prefer single-purpose tools over complex frameworks
2. **Work with existing tools** - Use git, rspec, grep - don't reinvent
3. **Fast feedback** - Tools should complete in < 2 seconds
4. **Composable** - Tools should work well together
