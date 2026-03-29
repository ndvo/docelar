module Dev
  class LogsController < ApplicationController
    def index
      @results = analyze_logs
    end

    def errors
      @errors = analyze_logs[:errors]
      render partial: 'errors'
    end

    def slow_queries
      @slow_queries = analyze_logs[:query_stats].sort_by { |_, v| -v[:max_duration] }
      render partial: 'slow_queries'
    end

    private

    def analyze_logs
      @_results ||= begin
        log_file = Rails.root.join("log/#{Rails.env}.log")
        options = {
          slow_query_threshold: Rails.application.config.log_inspector.slow_query_threshold,
          slow_request_threshold: Rails.application.config.log_inspector.slow_request_threshold
        }
        LogInspector.analyze(log_file: log_file, environment: Rails.env, options: options)
      end
    end
  end
end
