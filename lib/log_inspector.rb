require 'log_inspector/analyzer'
require 'log_inspector/formatters/cli'
require 'log_inspector/formatters/json'

module LogInspector
  VERSION = '1.0.0'

  def self.analyze(log_file:, environment: 'development', options: {})
    parser = Parser.new
    analyzer = Analyzer.new(options)

    File.foreach(log_file) do |line|
      entry = parser.parse(line)
      analyzer.add(entry) if entry
    end

    analyzer.results
  end

  class Parser
    REQUEST_REGEX = %r{Started (?<method>\w+) "(?<path>/[^"]+)"}
    COMPLETED_REGEX = /Completed (?<status>\d+) .*in (?<duration>\d+(?:\.\d+)?)ms/
    SQL_REGEX = /\[(?<level>\w+)\] (?<operation>\w+) \((?<duration>\d+\.?\d*)ms\) (?<sql>.*)/
    ERROR_REGEX = /\[(?<level>ERROR|FATAL|WARN)\] (?<message>.*)/
    EXCEPTION_REGEX = /(?<error_type>\w+Error): (?<message>.*)/
    TIMESTAMP_REGEX = /\d{4}-\d{2}-\d{2}T(\d{2}:\d{2}:\d{2})/

    def parse(line)
      entry = { raw: line, timestamp: extract_timestamp(line) }

      case line
      when REQUEST_REGEX
        entry.merge!(parse_request(line))
      when COMPLETED_REGEX
        entry.merge!(parse_completed(line))
      when SQL_REGEX
        entry.merge!(parse_sql(line))
      when ERROR_REGEX
        entry.merge!(parse_error(line))
      end

      entry[:type] = categorize(entry)
      entry
    rescue StandardError
      nil
    end

    private

    def extract_timestamp(line)
      line.match(TIMESTAMP_REGEX)&.[](1) || '00:00:00'
    end

    def parse_request(line)
      match = line.match(REQUEST_REGEX)
      { type: :request, method: match[:method], path: match[:path] }
    end

    def parse_completed(line)
      match = line.match(COMPLETED_REGEX)
      { type: :response, status: match[:status].to_i, duration_ms: match[:duration].to_f }
    end

    def parse_sql(line)
      match = line.match(SQL_REGEX)
      return {} unless match

      { type: :sql, operation: match[:operation], duration_ms: match[:duration].to_f, sql: match[:sql] }
    end

    def parse_error(line)
      match = line.match(ERROR_REGEX)
      return {} unless match

      { type: :error, level: match[:level], message: match[:message] }
    end

    def categorize(entry)
      return :error if entry[:type] == :error || (entry[:status]&.to_i&.>= 500)
      return :slow_request if entry[:duration_ms].to_f > 500
      return :slow_query if entry[:type] == :sql && entry[:duration_ms].to_f > 100

      entry[:type] || :unknown
    end
  end
end
