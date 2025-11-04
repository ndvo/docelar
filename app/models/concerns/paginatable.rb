# FROZEN_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :page, (lambda do |page, per_page = 50|
      offset = [(page - 1) * per_page, 0].max
      limit(per_page).offset(offset)
    end)
  end
end
