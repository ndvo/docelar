---
description: Use Doce Lar CLI tools for development workflow
agent: rails
---

# Doce Lar Agent CLI Tools

Use these CLI tools to accelerate development.

## Essential Tools

### 1. Run Related Specs
```bash
bin/dev-spec app/models/dog.rb        # Runs spec/models/dog_spec.rb
bin/dev-spec app/controllers/payments_controller.rb  # Runs spec/requests/payments_spec.rb
bin/dev-spec app/views/dogs/show.html.erb  # Runs spec/features/dogs_spec.rb
```

### 2. Find All Files for a Feature
```bash
bin/dev-context patient   # Lists all patient-related files
bin/dev-context payment  # Lists all payment-related files
```

### 3. Check Plan Status
```bash
bin/dev-plan              # List all plans with status
bin/dev-plan test-coverage # Show specific plan progress
```

### 4. Session Tracking
```bash
bin/dev-session start     # Start tracking
bin/dev-session summary  # Show what was done
bin/dev-session track    # Track current changes
```

### 5. Commit Planning
```bash
bin/dev-commit  # Analyze staged/unstaged and suggest commits
```

### 6. Guard Monitoring
```bash
bin/dev-guard start   # Start guard with logging
bin/dev-guard log    # Watch real-time output
bin/dev-guard status # Check if running
bin/dev-guard stop   # Stop guard
```

### 7. Code Quality
```bash
bin/dev-quality check    # Run all code quality checks
bin/dev-quality lint    # Quick syntax check
bin/dev-quality rails   # Rails best practices
```

### 8. Verify Pages
```bash
bin/dev-curl /patients    # Check if page loads (requires server)
bin/dev-curl /dogs/new
bin/dev-curl list         # Show available routes
```

### 9. Rails Shortcuts
```bash
bin/dev-rails console   # Open console (alias: c)
bin/dev-rails routes   # List routes (alias: r)
bin/dev-rails g model Dog name  # Generate model
bin/dev-rails migrate  # Run migrations
bin/dev-rails test     # Run tests
bin/dev-rails log     # Tail log
```

## Workflow Recommendations

1. **Before starting work**: Run `bin/dev-plan` to see current plans
2. **When working on a file**: Use `bin/dev-spec <file>` to run related tests
3. **Finding related code**: Use `bin/dev-context <feature>`
4. **During development**: Use `bin/dev-guard start` + `bin/dev-guard log`
5. **After making changes**: Use `bin/dev-curl <path>` to verify page loads
6. **Before committing**: Run `bin/dev-quality check` then `bin/dev-commit`
7. **At session end**: Run `bin/dev-session summary`

## After Saying "Done"

**Always verify the feature works** before telling the user it's done:
1. Run `bin/dev-curl <path>` to check the page loads without errors
2. Or start server and check manually

Example workflow after implementing a feature:
```bash
bin/dev-curl /patients    # Verify patients page loads
# If 200 - all good
# If 500 - there's an error to fix

## Test Commands

- Full test suite: `bundle exec rspec`
- Single spec: `bin/dev-spec <file>`
- Watch mode: `bin/dev-guard start` then `bin/dev-guard log`