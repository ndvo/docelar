---
description: Rails Code Style Review
agent: rails
---

Review Rails code for style and convention compliance.

## Check
- RuboCop Rails rules
- Naming conventions (models, controllers, views)
- File organization
- View templates (ERB best practices)
- Route conventions

## Run
```bash
bundle exec rubocop --rails
```

Fix any auto-correctable issues automatically.
Report remaining violations for manual review.
