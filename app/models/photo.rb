class Photo < ActiveRecord::Base
  belongs_to :gallery

  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100], preprocessed: true
    attachable.variant :full, resize_to_limit: [1280, 1280]
  end

  def fs_path = Rails.root.join('app', 'assets', Gallery.path, gallery.folder_name, file_name)

  def rotate_left
    system "mogrify -rotate -90 \"#{fs_path}\""
  end

  def rotate_right
    system "mogrify -rotate 90 \"#{fs_path}\""
  end

  validates :gallery, presence: true
  validates :original_path, uniqueness: true

  def url_path
    "#{Gallery.gallery_folder}/#{gallery.folder_name}/#{original_path}"
  end

  def url_thumb_path
    "#{Gallery.thumbs_folder}/#{gallery.folder_name}/#{original_path}"
  end

  def self.thumbs_folder
    "galleries_thumbs"
  end

  def next = Photo.where("id > #{id}").order(id: :asc).first

  def previous = Photo.where("id < #{id - 1}").order(id: :desc).first
end
