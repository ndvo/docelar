# frozen_string_literal: true

module PaginationHelper
  def paginate(collection_or_options, options = {})
    if collection_or_options.is_a?(Hash)
      options = collection_or_options
      collection = nil
    else
      collection = collection_or_options
    end

    current_page = options[:current_page]
    total_pages = options[:total_pages]
    total_count = options[:total_count]
    per_page = options[:per_page]
    page_param = options[:page_param] || :page
    max_pages = options[:max_pages_shown] || 7
    base_url = options[:base_url] || request.path
    query_params = options[:query_params] || request.query_parameters.except(page_param)

    return if total_pages.to_i <= 1

    render partial: 'shared/pagination', locals: {
      current_page: current_page.to_i,
      total_pages: total_pages.to_i,
      total_count: total_count.to_i,
      per_page: per_page.to_i,
      page_param: page_param,
      max_pages: max_pages,
      base_url: base_url,
      query_params: query_params
    }
  end

  def build_pagination_url(base_url, params)
    query = params.to_query
    query.blank? ? base_url : "#{base_url}?#{query}"
  end
end
