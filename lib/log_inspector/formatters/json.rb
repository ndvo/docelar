module LogInspector
  module Formatters
    class Json
      def format_results(results)
        JSON.pretty_generate(results)
      end
    end
  end
end
