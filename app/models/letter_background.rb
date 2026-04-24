class LetterBackground < ApplicationRecord
  belongs_to :user
  belongs_to :photo, optional: true
  has_one_attached :image

  enum :source_type, {
    uploaded: 0,
    gallery: 1
  }, prefix: true

  validates :name, presence: true
  validates :source_type, presence: true

  scope :active, -> { where(active: true) }
  scope :for_user, ->(user) { where(user: user) }

  def filters
    filter_stack&.dig("filters") || []
  end

  def filters=(value)
    self.filter_stack = { filters: value, redo_stack: redo_stack }
  end

  def redo_stack
    filter_stack&.dig("redo_stack") || []
  end

  def redo_stack=(value)
    self.filter_stack = { filters: filters, redo_stack: value }
  end

  def add_filter(type, params = {})
    stack = filter_stack || { "filters" => [], "redo_stack" => [] }
    self.filter_stack = {
      "filters" => stack["filters"] + [{ "id" => SecureRandom.uuid, "type" => type, "params" => params, "applied_at" => Time.current.iso8601 }],
      "redo_stack" => []
    }
  end

  def remove_filter(filter_id)
    stack = filter_stack || { "filters" => [], "redo_stack" => [] }
    new_filters = stack["filters"].reject { |f| f["id"] == filter_id }
    self.filter_stack = { "filters" => new_filters, "redo_stack" => stack["redo_stack"] }
  end

  def undo_filter
    return false unless can_undo?

    stack = filter_stack || { "filters" => [], "redo_stack" => [] }
    removed = stack["filters"].pop
    self.filter_stack = {
      "filters" => stack["filters"],
      "redo_stack" => stack["redo_stack"] + [removed]
    }
    true
  end

  def redo_filter
    return false unless can_redo?

    stack = filter_stack || { "filters" => [], "redo_stack" => [] }
    redone = stack["redo_stack"].pop
    self.filter_stack = {
      "filters" => stack["filters"] + [redone],
      "redo_stack" => stack["redo_stack"]
    }
    true
  end

  def reset_filters
    self.filter_stack = { "filters" => [], "redo_stack" => [] }
  end

  def can_undo?
    filters.any?
  end

  def can_redo?
    redo_stack.any?
  end

  def image_url
    if photo.present? && photo.file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(photo.file, only_path: true)
    elsif image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    end
  end
end