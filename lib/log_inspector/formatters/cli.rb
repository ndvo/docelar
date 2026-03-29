module LogInspector
  module Formatters
    class Cli
      COLORS = {
        reset: "\e[0m",
        red: "\e[31m",
        yellow: "\e[33m",
        green: "\e[32m",
        blue: "\e[34m",
        bold: "\e[1m",
        dim: "\e[2m"
      }.freeze

      def format_results(results)
        output = []
        output << header
        output << summary(results[:summary])
        output << errors(results[:errors]) if results[:errors].any?
        output << slow_queries(results[:query_stats]) if results[:query_stats].any?
        output << slow_requests(results[:slow_requests]) if results[:slow_requests].any?
        output.join("\n")
      end

      def format_errors(results)
        output = []
        output << "#{COLORS[:bold]}=== ERRORS (#{results[:errors].size}) ===#{COLORS[:reset]}\n\n"

        results[:errors].each do |error|
          output << format_error(error)
        end

        output.join("\n")
      end

      def format_slow_queries(results, threshold: 100)
        output = []
        output << "#{COLORS[:bold]}=== SLOW QUERIES (>#{threshold}ms) ===#{COLORS[:reset]}\n\n"

        stats = results[:query_stats].sort_by { |_, v| -v[:max_duration] }
        output << header_row('Table', 'Count', 'Avg (ms)', 'Max (ms)')
        output << separator_row(4)

        stats.each do |table, data|
          avg = (data[:total_duration] / data[:count]).round(1)
          output << row(table, data[:count], avg, data[:max_duration].round(1))
        end

        output.join("\n")
      end

      private

      def header
        "#{COLORS[:bold]}#{COLORS[:blue]}=== Log Inspector ===#{COLORS[:reset]}\n\n"
      end

      def summary(stats)
        lines = [
          "#{COLORS[:bold]}Summary:#{COLORS[:reset]}",
          "  Total entries: #{stats[:total_entries]}",
          "  Errors: #{colorize_count(stats[:error_count], :red)}",
          "  Slow queries: #{colorize_count(stats[:slow_query_count], :yellow)}",
          "  Slow requests: #{colorize_count(stats[:slow_request_count], :yellow)}",
          "  Avg response: #{stats[:avg_response_time].round(1)}ms",
          "  P95: #{stats[:p95_response_time].round(1)}ms",
          "  P99: #{stats[:p99_response_time].round(1)}ms"
        ]
        lines.join("\n") + "\n\n"
      end

      def errors(error_list)
        lines = ["#{COLORS[:bold]}#{COLORS[:red]}Errors:#{COLORS[:reset]}\n"]

        error_list.each_with_index do |error, i|
          lines << format_error(error, i + 1)
        end

        lines.join("\n") + "\n"
      end

      def format_error(error, num = nil)
        num_str = num ? "#{num}. " : ''
        "#{COLORS[:red]}#{num_str}#{error[:level]}#{COLORS[:reset]} - #{error[:message]}\n" \
        "    #{COLORS[:dim]}#{error[:timestamp]}#{COLORS[:reset]}\n"
      end

      def slow_queries(query_stats)
        return '' if query_stats.empty?

        lines = ["#{COLORS[:bold]}#{COLORS[:yellow]}Top Slow Queries:#{COLORS[:reset]}\n"]

        query_stats.sort_by { |_, v| -v[:max_duration] }.first(5).each do |table, data|
          avg = (data[:total_duration] / data[:count]).round(1)
          lines << "  #{table}: #{data[:count]}x, avg #{avg}ms, max #{data[:max_duration].round}ms"
        end

        lines.join("\n") + "\n\n"
      end

      def slow_requests(request_list)
        lines = ["#{COLORS[:bold]}#{COLORS[:yellow]}Slow Requests:#{COLORS[:reset]}\n"]

        request_list.first(5).each do |req|
          path = req[:path] || 'unknown'
          duration = req[:duration_ms] || 0
          lines << "  #{path} - #{duration.round}ms"
        end

        lines.join("\n") + "\n"
      end

      def colorize_count(count, color)
        return '0' if count.zero?

        "#{COLORS[color]}#{count}#{COLORS[:reset]}"
      end

      def header_row(*cols)
        cols.join('  ').center(60)
      end

      def separator_row(_cols)
        '-' * 60
      end

      def row(*cols)
        cols.join('  ')
      end
    end
  end
end
