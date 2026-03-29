# Agent Tool Suggestions

## Engineering Team

### `rails`
- **RuboCop**: `rubocop-rails` - Rails-specific cops
- **Pre-commit**: None specific

### `hotwire`
- **RuboCop**: `rubocop-hotwire` or custom cops for Turbo/Stimulus patterns

### `rails-performance`
- **RuboCop**: `rubocop-performance` - Performance anti-patterns
- **Pre-commit**: `bundle-audit` - Check for vulnerable gems

### `developer-experience`
- **RuboCop**: `rubocop-rspec` - RSpec best practices
- **Pre-commit**: 
  - `standardrb` - Opinionated Ruby style
  - `lefthook` or `overcommit` - Git hooks manager
- **Pre-push**: `bundle exec rspec --fail-fast` - Run tests before push

### `devops`
- **Pre-commit**: 
  - `trufflehog` - Secrets scanning
  - `dockerlint` - Dockerfile linting
- **Pre-push**: Container security scan

---

## Security Team

### `security-backend`
- **RuboCop**: 
  - `rubocop-security-rails` - Security anti-patterns
  - `brakeman` - Static security analysis
- **Pre-commit**:
  - `bundler-audit` - Check vulnerable gems
  - `trufflehog` - Detect secrets in code
- **Pre-push**: `brakeman --no-pager -w1` - Security scan

### `security-frontend`
- **Pre-commit**:
  - `npm audit` / `yarn audit` - Node vulnerability scanning
- **Pre-push**: CSP validator

---

## Quality Team

### `qa`
- **RuboCop**: `rubocop-rspec` - Test best practices

### `qa-backend`
- **RuboCop**: 
  - `rubocop-rspec` - RSpec patterns
  - `rspec-benchmark` - Performance benchmarking

### `qa-frontend`
- **Pre-commit**:
  - `axe-core-cli` - Accessibility checks
  - `prettier` / `eslint` - JavaScript linting
- **Pre-push**: Visual regression checks

---

## UX/Design Team

### `design`
- **Pre-commit**: `stylelint` - CSS/SCSS linting
- **Pre-push**: None specific

### `accessibility`
- **Pre-commit**:
  - `axe-core-cli` - WCAG compliance
  - `pa11y` - Accessibility testing
- **Pre-push**: Accessibility audit

---

## Recommended Tool Stack

### RuboCop Extensions
```ruby
# .rubocop.yml
require:
  - rubocop-rails
  - rubocop-rspec
  - rubocop-performance
  - rubocop-security-rails  # When available
```

### Pre-commit (Lefthook)
```yaml
# .lefthook.yml
pre-commit:
  parallel: true
  commands:
    rubocop:
      run: bundle exec rubocop --parallel
    brakeman:
      run: bundle exec brakeman --no-pager -w1
    bundler-audit:
      run: bundle exec bundle-audit check --update
    eslint:
      run: npx eslint app/javascript
    stylelint:
      run: npx stylelint "app/**/*.css"
    axe:
      run: npx @axe-core/cli http://localhost:3000

pre-push:
  commands:
    rspec:
      run: bundle exec rspec --fail-fast --format progress
    security-check:
      run: bundle exec brakeman --no-pager -w2
```

### Bundler Audit
```bash
gem install bundler-audit
gem install brakeman
gem install rubocop rubocop-rails rubocop-rspec rubocop-performance
```

---

## Implementation Plan

### Phase 1: Essential (High Impact)
- [ ] `rubocop` + `rubocop-rails` + `rubocop-rspec`
- [ ] `bundler-audit`
- [ ] `brakeman`
- [ ] `lefthook` setup

### Phase 2: Security
- [ ] `trufflehog` for secrets scanning
- [ ] `rubocop-security-rails`

### Phase 3: Frontend
- [ ] `eslint` + `stylelint`
- [ ] `axe-core-cli`

### Phase 4: Quality
- [ ] `rspec-benchmark`
- [ ] Visual regression tools
- [ ] `pa11y`

---

## Quick Setup

```bash
# Install gems
bundle add --group development test rubocop rubocop-rails rubocop-rspec rubocop-performance bundler-audit brakeman

# Install lefthook
gem install lefthook
lefthook install

# Create config
cat > .lefthook.yml << 'EOF'
pre-commit:
  commands:
    rubocop:
      run: bundle exec rubocop --parallel
    bundler-audit:
      run: bundle exec bundle-audit check --update
EOF
```
