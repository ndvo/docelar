namespace :plans do
  desc 'Show overall project status from plan documents'
  task :status do
    puts "\n=== DOCELAR PROJECT STATUS ===\n\n"

    puts "📋 PLAN DOCUMENTS:\n\n"

    documents = {
      'README.md' => { purpose: 'Landing page & overview', update: 'Monthly' },
      'ROADMAP.md' => { purpose: 'Vision, phases, features', update: 'Weekly' },
      'FEATURES.md' => { purpose: 'Feature status tracking', update: 'Weekly' },
      'docs/deployment-plan.md' => { purpose: 'Kamal deployment strategy', update: 'Per deploy' },
      'docs/google-photos-integration.md' => { purpose: 'Google Photos integration', update: 'Per sprint' },
      'docs/google-photos-ux.md' => { purpose: 'Photos UX design', update: 'Per sprint' },
      'docs/log-inspector-plan.md' => { purpose: 'Log inspection tool', update: 'Per development' },
      'docs/frontpage-plan.md' => { purpose: 'Homepage improvement', update: 'Ongoing' }
    }

    documents.each do |doc, info|
      exists = File.exist?(doc)
      status = exists ? '✅' : '❌'
      puts "  #{status} #{doc.ljust(35)} - #{info[:purpose]} (#{info[:update]})"
    end

    puts "\n📊 FEATURE STATUS (from FEATURES.md):\n\n"

    if File.exist?('FEATURES.md')
      content = File.read('FEATURES.md')

      existing = content.scan(/^- \[x\]/).count
      planned = content.scan(/^- \[ \]/).count

      puts "  Completed: #{existing} features"
      puts "  Planned:   #{planned} features"

      puts "\n  By Module:"
      modules = {
        'Finance' => ['Monthly reports', 'Budget limits', 'Recurring detection'],
        'Health' => ['Health dashboard', 'Vaccination reminders', 'Export records'],
        'Organization' => ['Calendar view', 'Recurring tasks', 'Task priorities'],
        'Media' => ['Google Photos sync', 'Video support', 'Photo editing']
      }

      modules.each do |mod, next_steps|
        mod_section = content[/### #{mod} Module.*?(?=###|\z)/m]
        next unless mod_section

        done = mod_section.scan(/^- \[x\]/).count
        total = mod_section.scan(/^- \[/).count
        puts "    #{mod}: #{done}/#{total} ✅"
        puts "      📌 Next: #{next_steps.take(2).join(', ')}" if done == total && next_steps.any?
      end
    else
      puts '  ❌ FEATURES.md not found'
    end

    puts "\n🔧 ACTIVE WORK:\n\n"
    active = {
      'Gallery Lightbox' => { status: 'Working', next: 'Add prev/next navigation' },
      'Log Inspector' => { status: 'Built', next: 'Add QA tests for error detection' },
      'Google Photos' => { status: 'Planning', next: 'Setup OAuth + Picker API' },
      'Front Page' => { status: 'Planned', next: 'UX research + redesign hero' }
    }

    active.each do |item, info|
      puts "  🔄 #{item}"
      puts "     Status: #{info[:status]} | Next: #{info[:next]}"
    end

    puts "\n🚀 RECENT COMMITS:\n\n"
    commits = `git log --oneline -5 2>/dev/null`.strip
    commits.split("\n").each { |c| puts "  #{c}" }

    puts "\n"
  end

  desc 'Show roadmap progress'
  task :roadmap do
    puts "\n=== ROADMAP PROGRESS ===\n\n"

    if File.exist?('ROADMAP.md')
      content = File.read('ROADMAP.md')

      phases = {
        'Phase 1: Foundation' => { status: '✅', next: nil },
        'Phase 2: User Experience' => { status: '🔄', next: 'Homepage redesign, forms UX' },
        'Phase 3: Insights' => { status: '📋', next: 'Reports, budgets, analytics' },
        'Phase 4: Family' => { status: '📋', next: 'Multi-user, shared access' }
      }

      phases.each do |phase, info|
        section = content[/### #{phase}.*?(?=###|\z)/m]
        next unless section

        completed = section.scan(/^\s*-\s*\[x\]/).count
        total = section.scan(/^\s*-\s*\[/).count
        puts "  #{info[:status]} #{phase.split(':').last.strip}: #{completed}/#{total} items"
        puts "     📌 Next: #{info[:next]}" if info[:next]
      end

      puts "\n📋 UPCOMING PHASE ITEMS:\n\n"
      planned = content.scan(/^- \[ \] (.+)/).flatten
      planned.first(5).each do |item|
        puts "  ⬜ #{item.strip}"
      end
    else
      puts '  ❌ ROADMAP.md not found'
    end

    puts "\n"
  end

  desc 'Show current blockers'
  task :blockers do
    puts "\n=== BLOCKERS & RISKS ===\n\n"

    blockers = []

    todos = `grep -r "TODO\|FIXME\|HACK\|XXX" app/ --include="*.rb" --include="*.erb" 2>/dev/null | head -10`.strip
    blockers << { type: 'TODO/FIXME', count: todos.split("\n").count, details: todos } if todos.present?

    pending = `bundle exec rspec --dry-run 2>/dev/null | grep pending`.strip
    if pending.present?
      m = pending.match(/(\d+) examples.*(\d+) pending/)
      blockers << { type: 'Pending Specs', count: m[2].to_i, details: 'Specs need implementation' } if m
    end

    if blockers.empty?
      puts "  ✅ No blockers identified\n\n"
    else
      blockers.each do |blocker|
        puts "  ⚠️  #{blocker[:type]}: #{blocker[:count]}"
        puts "    #{blocker[:details]}\n" if blocker[:details].is_a?(String) && blocker[:details].lines.count <= 5
      end
    end

    puts "📝 TO ADDRESS:\n\n"
    puts '  1. Review TODO/FIXME comments in code'
    puts '  2. Implement pending specs'
    puts "  3. Update documentation for new features\n\n"
  end

  desc 'Generate full status report'
  task report: %i[status roadmap blockers] do
    puts "\n=== FULL REPORT COMPLETE ===\n"
    puts "Generated at: #{Time.now}\n\n"

    puts "📌 RECOMMENDED NEXT STEPS:\n\n"
    puts '  1. 🔧 Gallery: Add prev/next to lightbox'
    puts '  2. 📷 Google Photos: Setup OAuth + Picker integration'
    puts '  3. 🏠 Front Page: UX research + hero redesign'
    puts '  4. 🧪 Log Inspector: Add QA tests for error detection'
    puts '  5. 📊 Phase 2 UX: Complete forms + mobile optimization\n\n'
  end
end
