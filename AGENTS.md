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

## Code Style

- Follow Rails conventions
- Use `_spec.rb` suffix for spec files
- Use `describe`/`it` blocks in RSpec
- Keep specs focused and atomic

## Available Agents

| Agent | Focus |
|-------|-------|
| `hotwire` | Turbo, Stimulus, real-time features |
| `developer-experience` | Tests, tooling, developer productivity |
| `rails-performance` | Query optimization, caching |
| `design` | CSS, layouts |
| `accessibility` | WCAG compliance, screen readers, ARIA, a11y testing |
| `project-owner` | Planning, prioritization |
| `devops` | CI/CD, deployment, automation |
| `qa` | Test quality, code quality, accessibility |
