module LogInspector
  class Analyzer
    attr_reader :options, :entries, :errors, :slow_queries, :slow_requests, :request_stats

    def initialize(options = {})
      @options = default_options.merge(options)
      @entries = []
      @errors = []
      @slow_queries = []
      @slow_requests = []
      @query_stats = Hash.new { |h, k| h[k] = { count: 0, total_duration: 0, max_duration: 0, queries: [] } }
      @request_stats = { count: 0, total_duration: 0, durations: [] }
    end

    def add(entry)
      @entries << entry
      analyze_entry(entry)
    end

    def results
      {
        summary: build_summary,
        errors: @errors,
        slow_queries: @slow_queries,
        slow_requests: @slow_requests,
        query_stats: @query_stats,
        entries: @entries.last(100)
      }
    end

    private

    def default_options
      {
        slow_query_threshold: 100,
        slow_request_threshold: 500,
        max_entries: 1000
      }
    end

    def analyze_entry(entry)
      case entry[:type]
      when :error
        @errors << entry
      when :slow_query
        @slow_queries << entry
        track_query(entry)
      when :slow_request
        @slow_requests << entry
        track_request(entry)
      when :response
        track_request(entry)
      when :sql
        track_query(entry) if entry[:duration_ms].to_f > options[:slow_query_threshold]
      end
    end

    def track_query(entry)
      table = extract_table_name(entry[:sql])
      stats = @query_stats[table]
      stats[:count] += 1
      stats[:total_duration] += entry[:duration_ms].to_f
      stats[:max_duration] = [stats[:max_duration], entry[:duration_ms].to_f].max
      stats[:queries] << entry[:sql] unless stats[:queries].include?(entry[:sql])
    end

    def track_request(entry)
      @request_stats[:count] += 1
      return unless entry[:duration_ms]

      @request_stats[:total_duration] += entry[:duration_ms].to_f
      @request_stats[:durations] << entry[:duration_ms].to_f
    end

    def extract_table_name(sql)
      return 'unknown' unless sql

      match = sql.match(/FROM\s+"?(\w+)"?|INSERT INTO\s+"?(\w+)"?|UPDATE\s+"?(\w+)"?/i)
      (match[1] || match[2] || match[3] || 'unknown').downcase
    end

    def build_summary
      {
        total_entries: @entries.size,
        error_count: @errors.size,
        slow_query_count: @slow_queries.size,
        slow_request_count: @slow_requests.size,
        avg_response_time: @request_stats[:count].positive? ? @request_stats[:total_duration] / @request_stats[:count] : 0,
        p95_response_time: calculate_percentile(95),
        p99_response_time: calculate_percentile(99)
      }
    end

    def calculate_percentile(percentile)
      return 0 if @request_stats[:durations].empty?

      sorted = @request_stats[:durations].sort
      index = (sorted.size * percentile / 100.0).floor
      sorted[index] || sorted.last
    end
  end
end
