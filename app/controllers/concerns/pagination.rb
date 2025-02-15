module Pagination
  extend ActiveSupport::Concern

  def pagination_params
    params.require(:page)
  end
end
