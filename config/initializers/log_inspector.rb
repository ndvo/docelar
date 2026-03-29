Rails.application.config.log_inspector = ActiveSupport::OrderedOptions.new.tap do |config|
  config.slow_query_threshold = 100
  config.slow_request_threshold = 500
  config.max_entries = 1000
end
