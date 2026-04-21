namespace :plans do
  desc 'Show overall project status from plan documents'
  task :status do
    puts "\n=== DOCELAR PROJECT STATUS ===\n\n"

    puts "PLAN DOCUMENTS:\n\n"

    # Discover and analyze all plan documents dynamically
    docs_dir = 'docs'
    plan_files = []
    
    if Dir.exist?(docs_dir)
      # Search both in docs/ root and in pillar subdirectories
      plan_patterns = [
        "#{docs_dir}/*-plan*.md",
        "#{docs_dir}/*-photos*.md",
        "#{docs_dir}/*-implementation*.md",
        "#{docs_dir}/**/*-plan.md",
        "#{docs_dir}/**/*-plan*.md"
      ]
      plan_files = plan_patterns.flat_map { |p| Dir.glob(p) }.uniq.sort
    end

    # Analyze each plan document
    plan_summary = []
    plan_files.each do |plan_file|
      content = File.read(plan_file)
      
      # Extract title
      title = content.match(/^#\s+(.+)$/)[1] rescue File.basename(plan_file, '.md')
      
      # Count checkboxes
      completed = content.scan(/- \[x\]/).count
      pending = content.scan(/- \[ \]/).count
      total = completed + pending
      
      # Determine status based on completion
      if total == 0
        # Try to detect status from tables with Status column
        if content.include?('Status') && content.include?('|')
          # Find the table with Status column and count values in that column
          lines = content.split("\n")
          
          header_idx = lines.index { |l| l.include?('Status') && l.include?('|') }
          
          if header_idx
            # Find which column index has Status
            header_parts = lines[header_idx].split('|').map(&:strip)
            status_col_idx = header_parts.index('Status')
            
            done_count = 0
            pending_count = 0
            in_progress_count = 0
            
            (header_idx + 1).upto(lines.length - 1) do |i|
              line = lines[i]
              next if line =~ /\|[-:]+\|/
              
              parts = line.split('|').map(&:strip)
              status_col = parts[status_col_idx] if status_col_idx && parts[status_col_idx]
              
              done_count += 1 if status_col =~ /\bDone\b/i || status_col =~ /\bComplete\b/i || status_col =~ /✅/ || status_col =~ /Present\b/i
              pending_count += 1 if status_col =~ /\bPending\b/i || status_col =~ /\bNot Started\b/i || status_col =~ /\bTo Do\b/i || status_col =~ /⏳/ || status_col =~ /\bMissing\b/i || status_col =~ /\bNo\b/
              in_progress_count += 1 if status_col =~ /\bIn Progress\b/i || status_col =~ /\bOngoing\b/i || status_col =~ /🔄/ || status_col =~ /\bPartial\b/i
            end
            
            task_total = done_count + pending_count + in_progress_count
            
            if task_total > 0
              pct = ((done_count.to_f / task_total) * 100).round
              status = if done_count > 0 && pending_count == 0 && in_progress_count == 0
                'Complete'
              elsif done_count > 0 || in_progress_count > 0
                'In Progress'
              else
                'Not started'
              end
              # Override the checkbox counts with table detection
              completed = done_count
              pending = task_total - done_count
            else
              status = 'No tasks'
              pct = 0
              total = 0
            end
          else
            status = 'No tasks'
            pct = 0
          end
        else
          status = 'No tasks'
          pct = 0
        end
      elsif completed == total
        status = 'Complete'
        pct = 100
      elsif completed > 0
        status = 'In Progress'
        pct = ((completed.to_f / total) * 100).round
      else
        status = 'Not started'
        pct = 0
      end
      
      plan_summary << {
        file: plan_file,
        name: File.basename(plan_file, '.md'),
        title: title,
        completed: completed,
        pending: pending,
        total: total > 0 ? total : (task_total || 0),
        status: status,
        pct: pct
      }
    end

    # Sort by completion percentage (highest first), then by name
    plan_summary.sort_by! { |p| [-p[:pct], p[:name]] }

    # Display plans - one per line with priority
    plan_summary.each do |plan|
      status_icon = case plan[:status]
                  when 'Complete' then '[DONE]'
                  when 'In Progress' then '[...]'
                  else '[...]'
                  end
      
      # Extract priority from plan name (e.g., "01-budget" -> "P1", "health" -> "P4")
      priority = extract_priority(plan[:name])
      
      puts "  #{status_icon} [#{priority}] #{plan[:name].ljust(40)} #{plan[:completed]}/#{plan[:total]} (#{plan[:pct]}%)"
    end

    total_completed = plan_summary.count { |p| p[:status] == 'Complete' }
    total_in_progress = plan_summary.count { |p| p[:status] == 'In Progress' }
    total_not_started = plan_summary.count { |p| p[:status] == 'Not started' }
    total_no_tasks = plan_summary.count { |p| p[:status] == 'No tasks' }
    
    puts "\nSUMMARY:\n"
    puts "  [DONE] Complete:      #{total_completed}"
    puts "  [...] In Progress:  #{total_in_progress}"
    puts "  [---] Not Started: #{total_not_started}"
    puts "  [---] No Tasks:   #{total_no_tasks}"
    puts "  ---------------------"
    puts "  Total: #{plan_summary.count}"

    puts "\nTo view detailed progress of a specific plan, run:"
    puts "  rake plans:show[plan-name]"
    puts "  Example: rake plans:show[medical-appointments-plan]"

    puts "\nRECENT COMMITS:\n\n"
    commits = `git log --oneline -5 2>/dev/null`.strip
    commits.split("\n").each { |c| puts "  #{c}" }

    puts "\n"
  end

  desc 'Show detailed progress for a specific plan'
  task :show, [:plan_name] do |t, args|
    plan_name = args[:plan_name]
    
    unless plan_name
      puts "Usage: rake plans:show[plan-name]"
      puts "Available plans:"
      Dir.glob('docs/*-plan*.md').each do |f|
        puts "  - #{File.basename(f, '.md')}"
      end
      exit 1
    end
    
    plan_file = "docs/#{plan_name}.md"
    unless File.exist?(plan_file)
      puts "Plan not found: #{plan_file}"
      puts "Available plans:"
      Dir.glob('docs/*-plan*.md').each do |f|
        puts "  - #{File.basename(f, '.md')}"
      end
      exit 1
    end
    
    content = File.read(plan_file)
    title = content.match(/^#\s+(.+)$/)[1] rescue plan_name
    
    puts "\n=== #{title.upcase} ===\n\n"
    
    status_match = content.match(/\*\*Status\*\*:\s*(\w+)/i)
    puts "Status: #{status_match ? status_match[1].upcase : 'Not specified'}\n\n"
    
    completed = content.scan(/^- \[x\]/).count
    pending = content.scan(/^- \[ \]/).count
    total = completed + pending
    
    if total > 0
      percentage = ((completed.to_f / total) * 100).round
      puts "Progress: #{completed}/#{total} tasks (#{percentage}%)\n\n"
      
      puts "Completed tasks:"
      content.scan(/^- \[x\] (.+)$/).each do |task|
        puts "  [x] #{task[0].strip}"
      end
      
      puts "\nPending tasks:"
      content.scan(/^- \[ \] (.+)$/).each do |task|
        puts "  [ ] #{task[0].strip}"
      end
    else
      puts "No checkbox tasks found in this plan.\n"
    end
    
    phases = content.scan(/^##\s+Phase\s+(\d+):\s+(.+)$/i)
    if phases.any?
      puts "\nPhases:"
      phases.each do |num, name|
        phase_section = content[/##\s+Phase\s+#{num}:.*?(?=##|\z)/mi]
        next unless phase_section
        
        phase_completed = phase_section.scan(/^- \[x\]/).count
        phase_total = phase_section.scan(/^- \[/).count
        phase_pct = phase_total > 0 ? ((phase_completed.to_f / phase_total) * 100).round : 0
        puts "  Phase #{num}: #{name.strip} - #{phase_completed}/#{phase_total} (#{phase_pct}%)"
      end
    end
    
    puts "\n"
  end

  desc 'Show roadmap progress'
  task :roadmap do
    puts "\n=== ROADMAP PROGRESS ===\n\n"

    if File.exist?('ROADMAP.md')
      content = File.read('ROADMAP.md')

      sections = content.scan(/^### Phase (\d+):\s+(.+)$/)
      
      if sections.any?
        sections.each do |(num, name)|
          phase_title = "### Phase #{num}: #{name}"
          section = content[/#{phase_title}.*?(?=^### Phase|^## |\z)/m]
          next unless section

          completed = section.scan(/-\s*\[x\]/).count
          total = section.scan(/-\s*\[/).count
          pct = total > 0 ? ((completed.to_f / total) * 100).round : 0

          status = if completed == total && total > 0
            '[OK]'
          elsif completed > 0
            '[..]'
          else
            '[-]'
          end

          puts "  #{status} Phase #{num}: #{name.strip} - #{completed}/#{total} (#{pct}%)"
        end
      end

      puts "\nUPCOMING PHASE ITEMS:\n\n"
      planned = content.scan(/^- \[ \] (.+)/).first(5)
      planned.each do |item|
        puts "  [ ] #{item[0].strip}"
      end
    else
      puts '  [--] ROADMAP.md not found'
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
      puts "  [OK] No blockers identified\n\n"
    else
      blockers.each do |blocker|
        puts "  [!] #{blocker[:type]}: #{blocker[:count]}"
        puts "    #{blocker[:details]}\n" if blocker[:details].is_a?(String) && blocker[:details].lines.count <= 5
      end
    end

    puts "TO ADDRESS:\n\n"
    puts "  1. Review TODO/FIXME comments in code"
    puts "  2. Implement pending specs"
    puts "  3. Update documentation for new features\n\n"
  end

  desc 'Generate full status report'
  task report: %i[status roadmap blockers] do
    puts "\n=== FULL REPORT COMPLETE ===\n"
    puts "Generated at: #{Time.now}\n\n"

    puts "RECOMMENDED NEXT STEPS:\n\n"
    puts "  1. [NEW] Accessibility plan: WCAG compliance review"
    puts "  2. [NEW] Family calendar: Unified calendar view"
    puts "  3. [NEW] Front Page: UX research + hero redesign"
    puts "  4. [NEW] Log Inspector: Implement + QA tests"
    puts "  5. [NEW] Deployment: VPS with Kamal 2\n\n"
  end

  private

  def self.extract_priority(plan_name)
    # Extract priority from plan name
    # Pillar plans: 01-budget -> P1, 02-financial -> P2, etc.
    if plan_name.match?(/^(\d+)-/)
      num = $1.to_i
      return "P#{num}" if num <= 9
    end
    
    # Core plans get higher priority
    case plan_name.downcase
    when /accessibility|a11y/
      'P2'
    when /test-coverage|test_coverage/
      'P2'
    when /medical|health/
      'P3'
    when /gallery|photo/
      'P3'
    when /education|family-calendar/
      'P4'
    when /deployment/
      'P5'
    else
      'P4'
    end
  end

  def self.extract_purpose_from_plan(plan_file)
    content = File.read(plan_file)
    first_heading = content.match(/^#\s+(.+)$/)
    if first_heading
      first_heading[1].strip
    else
      File.basename(plan_file, '.md').humanize
    end
  end
end
