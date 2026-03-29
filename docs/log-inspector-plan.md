# Log Inspector Plan

## Problem Statement

Developers waste significant time manually scanning Rails log files to:
- Find errors and exceptions buried in thousands of lines
- Identify slow database queries impacting performance  
- Correlate request paths with specific errors
- Extract meaningful metrics from unstructured log data

The standard `tail -f` and grep workflows are inefficient for modern debugging.

## Solution Overview

A Rails 8 log inspection tool providing:
- CLI rake tasks for local development
- Web interface for team collaboration
- Pattern-based log analysis and highlighting
- Query performance aggregation
- Structured output for further processing

## Features List

### Core Features
1. **Error Detection** - Highlight exceptions, 5xx errors, uncaught errors
2. **Slow Query Detection** - Flag queries exceeding configurable threshold (default: 100ms)
3. **Request Correlation** - Link errors to corresponding requests by request ID
4. **Time-based Filtering** - Filter by date/time ranges
5. **Pattern Matching** - Search with regex support

### Performance Metrics
6. **Query Aggregation** - Group and count repeated queries
7. **Response Time Stats** - Min/max/avg/duration p95/p99
8. **Slowest Requests** - Rank requests by total duration

### UI/UX Features
9. **Color-coded Output** - Terminal colors for errors, warnings, slow items
10. **JSON Export** - Structured output for integration
11. **Web Dashboard** - Rails route with filtering and search

## Implementation Approach

### 1. Rake Tasks (Primary)
- `rails logs:analyze[environment]` - Full log analysis
- `rails logs:errors[environment]` - Error-only view
- `rails logs:slow_queries[threshold]` - Query performance
- `rails logs:tail[environment]` - Live tail with highlighting

### 2. Log Parser Module
- Parse standard Rails logger format
- Extract: timestamp, level, request info, duration, SQL, errors
- Handle multi-line exception traces

### 3. Web Controller
- GET `/dev/logs` - Dashboard view
- Filter params: level, path, min_duration, since
- Pagination for large log sets

### 4. Configuration
- `config/initializers/log_inspector.rb` - Threshold settings

## File Structure

```
lib/
├── log_inspector/
│   ├── parser.rb           # Log line parsing
│   ├── analyzer.rb         # Metrics aggregation
│   ├── formatters/
│   │   ├── cli.rb          # Terminal output
│   │   └── json.rb         # JSON export
│   └── VERSION.rb
├── tasks/
│   └── log_inspector.rake  # Rake tasks
app/
├── controllers/
│   └── dev/
│       └── logs_controller.rb
├── views/
│   └── dev/
│       └── logs/
│           └── index.html.erb
config/
└── initializers/
    └── log_inspector.rb
```

## Example Output

### CLI Error Summary
```
$ rails logs:errors[development]

=== ERROR SUMMARY (last 24h) ===

Found 12 errors in 2874 requests

┌─────────────────────────────────────────────────────────────────────┐
│ FATAL: NoMethodError - undefined method 'name' for nil              │
│   app/controllers/photos_controller.rb:23                          │
│   GET /photos/5 - 500                                                │
│   2026-03-29 14:23:01                                               │
├─────────────────────────────────────────────────────────────────────┤
│ ERROR: ActiveRecord::RecordNotFound                                 │
│   app/controllers/dogs_controller.rb:45                            │
│   GET /dogs/999 - 404                                               │
│   2026-03-29 10:15:33                                               │
└─────────────────────────────────────────────────────────────────────┘
```

### Slow Query Report
```
$ rails logs:slow_queries[100]

=== SLOW QUERIES (>100ms) ===

Count  Table      Query                                           Avg    Max
────   ────       ─────                                           ───    ───
  23   patients   SELECT * FROM patients WHERE...                  245ms  890ms
   8   payments   JOIN purchases ON...                              180ms  420ms
   3   photos     SELECT * FROM photos WHERE...                     120ms  150ms
```

### Web Dashboard
```
┌──────────────────────────────────────────────────────────────────┐
│ Log Inspector                                [Search____] [Go]  │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Level ▼] [Path___] [Min ms: 0___] [Since: ___] [Apply] │
├──────────────────────────────────────────────────────────────────┤
│ Time       │ Level  │ Path        │ Duration │ Details           │
│────────────┼────────┼─────────────┼──────────┼───────────────────│
│ 14:23:01   │ FATAL  │ /photos/5   │ 245ms    │ NoMethodError...  │
│ 14:22:45   │ ERROR  │ /payments   │ 1.2s     │ PG::Connection... │
│ 14:20:12   │ WARN   │ /dogs       │ 89ms     │ Slow query...     │
│ 14:15:00   │ INFO   │ /           │ 12ms     │ OK                │
└──────────────────────────────────────────────────────────────────┘
```

### JSON Export
```json
{
  "analyzed_at": "2026-03-29T14:30:00Z",
  "time_range": { "from": "2026-03-28T14:30:00Z", "to": "2026-03-29T14:30:00Z" },
  "summary": {
    "total_requests": 2874,
    "errors": 12,
    "slow_queries": 34,
    "avg_response_time": 45.2
  },
  "errors": [
    {
      "timestamp": "2026-03-29T14:23:01Z",
      "level": "FATAL",
      "type": "NoMethodError",
      "message": "undefined method 'name' for nil",
      "location": "app/controllers/photos_controller.rb:23",
      "request": { "path": "/photos/5", "method": "GET", "status": 500 }
    }
  ],
  "slow_queries": [
    {
      "count": 23,
      "table": "patients",
      "query": "SELECT * FROM patients WHERE...",
      "avg_duration_ms": 245,
      "max_duration_ms": 890
    }
  ]
}
```
