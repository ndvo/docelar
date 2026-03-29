namespace :logs do
  desc 'Analyze Rails logs for errors, slow queries, and performance issues'
  task :analyze, [:environment] => :environment do |_t, args|
    environment = args[:environment] || Rails.env
    log_file = Rails.root.join("log/#{environment}.log")

    unless File.exist?(log_file)
      puts "Log file not found: #{log_file}"
      exit 1
    end

    results = LogInspector.analyze(log_file: log_file, environment: environment)
    formatter = LogInspector::Formatters::Cli.new
    puts formatter.format_results(results)
  end

  desc 'Show only errors from Rails logs'
  task :errors, [:environment] => :environment do |_t, args|
    environment = args[:environment] || Rails.env
    log_file = Rails.root.join("log/#{environment}.log")

    unless File.exist?(log_file)
      puts "Log file not found: #{log_file}"
      exit 1
    end

    results = LogInspector.analyze(log_file: log_file, environment: environment)
    formatter = LogInspector::Formatters::Cli.new
    puts formatter.format_errors(results)
  end

  desc 'Show slow queries from Rails logs'
  task :slow_queries, %i[environment threshold] => :environment do |_t, args|
    environment = args[:environment] || Rails.env
    threshold = args[:threshold]&.to_i || 100
    log_file = Rails.root.join("log/#{environment}.log")

    unless File.exist?(log_file)
      puts "Log file not found: #{log_file}"
      exit 1
    end

    results = LogInspector.analyze(log_file: log_file, environment: environment,
                                   options: { slow_query_threshold: threshold })
    formatter = LogInspector::Formatters::Cli.new
    puts formatter.format_slow_queries(results, threshold: threshold)
  end

  desc 'Export logs as JSON'
  task :export, %i[environment output_file] => :environment do |_t, args|
    environment = args[:environment] || Rails.env
    output_file = args[:output_file] || 'log_analysis.json'
    log_file = Rails.root.join("log/#{environment}.log")

    unless File.exist?(log_file)
      puts "Log file not found: #{log_file}"
      exit 1
    end

    results = LogInspector.analyze(log_file: log_file, environment: environment)
    formatter = LogInspector::Formatters::Json.new

    File.write(output_file, formatter.format_results(results))
    puts "Exported to #{output_file}"
  end
end
