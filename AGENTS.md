# Agent Guidelines

## Commits

### Atomic, Hunk-Based Commits

**Always prefer small, focused commits.** Each commit should represent one logical change.

1. **One logical change per commit** - Don't mix features with fixes
2. **Ask before committing** - Always ask the user if they want to commit
3. **Review the diff** - Show `git diff` before committing
4. **Meaningful messages** - Explain WHY, not just WHAT

### Conventional Commits Format

```
<type>(<scope>): <description>

[optional body - explain WHY]

[optional footer - breaking changes, issues]
```

### Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Formatting, no code change
- `refactor` - Code restructuring
- `test` - Adding tests
- `chore` - Maintenance
- `ci` - CI/CD changes
- `perf` - Performance improvements

### Examples
```
feat(cards): add create and update specs
fix(payment): correct late scope test date
test(purchases): add feature specs for CRUD operations
ci(github): add parallel test workflow
```

### Commit Checklist
- [ ] Is this one logical change?
- [ ] Does it have a clear message?
- [ ] Did tests pass?
- [ ] Did you show the user the diff?

## Commit Planning

When working on multiple changes, plan commits before executing:

1. Run `git status` to see all changes
2. Run `git diff --stat` to understand scope
3. Group related changes into logical commits
4. Draft commit messages following conventional format
5. Ask user to approve the plan before committing

## Dependencies

**Avoid adding external dependencies.**

Before adding any gem, npm package, or library:
1. Check if Rails provides a built-in solution
2. Ask the user for approval
3. Explain why the dependency is needed

## Testing

- Use RSpec for Ruby/ Rails testing
- Use feature specs (Capybara) for UI testing
- Use model specs for business logic
- Use controller specs for API endpoints
- Run specs before committing: `bundle exec rspec`
- Avoid unnecessary mocks
- Avoid testing internal state
- Focus on testing observable behavior and outcomes
- Use parameterized tests

## Code Style

- Follow Rails conventions
- Use `_spec.rb` suffix for spec files
- Use `describe`/`it` blocks in RSpec
- Keep specs focused and atomic

## Code Quality and Best Practices

- Use SOLID
- Use TDD
- Prefer short methods
- Avoid testing implementation details
- Low coupling, high cohesion
- Follow design and plan
- Suggest plan improvements
- Domain Driven Design

## Work Session Flow

### Start of Session
1. Read plan document (`docs/*-plan.md`) if exists
2. Check git status to understand current state
3. Run failing specs to understand what's broken
4. Update session summary based on new discoveries

### During Session
- Keep track of what you're working on and what's been done
- Ask before continuing to new areas
- Mark tasks complete as you go

### End of Session
- Update plan document if needed (add completed items, remove done)
- Summarize work done for next session

## Stop Points

**Ask for clarification when:**
- Uncertain about next step or direction
- Task is complete vs. waiting for user input
- Multiple approaches available
- User says "what did we do so far?"

**Continue independently when:**
- Next step is clear from prior discussion
- Fix is straightforward and tests guide the way
- Following an established plan

| Agent | Focus |
|-------|-------|
| `hotwire` | Turbo, Stimulus, real-time features |
| `developer-experience` | Tests, tooling, developer productivity |
| `rails` | Ruby on Rails, system design, backend |
| `rails-performance` | Query optimization, caching |
| `design` | CSS, layouts |
| `accessibility` | WCAG compliance, screen readers, ARIA, a11y testing |
| `project-owner` | Planning, prioritization |
| `devops` | CI/CD, deployment, automation |
| `qa` | Test quality, code quality, accessibility |
| `health` | Medical appointments, patient health records, conditions, exams |
