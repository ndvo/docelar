---
description: Rails Best Practice and Standards Review
agent: rails
---

Perform a comprehensive Rails review following best practices and coding standards.

## Scope
1. **Code Quality**
   - Check for N+1 queries in controllers and models
   - Verify proper use of scopes and associations
   - Check for missing database indexes on foreign keys
   - Look for repeated code patterns that could be extracted

2. **Security**
   - Verify strong parameters are properly used
   - Check for SQL injection vulnerabilities
   - Ensure proper authorization checks
   - Verify no secrets/credentials in code

3. **Performance**
   - Look for missing eager loading (includes)
   - Check for inefficient queries in loops
   - Verify caching strategies where appropriate

4. **Rails Conventions**
   - Verify RESTful routing
   - Check for fat controllers / thin models
   - Ensure proper use of callbacks
   - Verify naming conventions (pluralized controllers, snake_case methods)

5. **Testing**
   - Check test coverage for controllers
   - Verify model validations are tested
   - Look for missing edge case tests

## Output Format
Provide a prioritized list of findings with:
- File path and line number
- Issue description
- Severity (High/Medium/Low)
- Suggested fix

Focus on the most impactful issues first.
