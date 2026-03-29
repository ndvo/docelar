# Agent Guidelines

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/) pattern:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
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
| `design` | CSS, layouts, accessibility |
| `project-owner` | Planning, prioritization |
| `devops` | CI/CD, deployment, automation |
| `qa` | Test quality, code quality, accessibility |
