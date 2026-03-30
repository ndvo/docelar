class Photo < ActiveRecord::Base
  belongs_to :gallery

  has_many :tagged_photos
  has_many :tags, through: :tagged_photos

  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_fill: [200, 200], preprocessed: true
    attachable.variant :grid, resize_to_limit: [400, 400], preprocessed: true
    attachable.variant :medium, resize_to_limit: [800, 800]
    attachable.variant :full, resize_to_limit: [1920, 1920]
  end

  def fs_path = Rails.root.join('galleries', gallery.folder_name, original_path)

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
    'galleries_thumbs'
  end

  def next = Photo.where(gallery:).where("id > #{id}").order(id: :asc).first

  def previous = Photo.where(gallery:).where("id < #{id}").order(id: :desc).first

  def medium_path
    "galleries_medium/#{gallery.folder_name}/#{original_path}"
  end

  def fs_medium_path
    "#{Rails.public_path}/#{medium_path}"
  end

  def ensure_medium_variant
    return if File.exist?(fs_medium_path)

    src = fs_path
    return unless File.exist?(src)

    dst_dir = File.dirname(fs_medium_path)
    FileUtils.mkdir_p(dst_dir)

    system("convert -resize 1200x1200\\> -quality 85 '#{src}' '#{fs_medium_path}'")
  end

  def medium_url
    ensure_medium_variant if !File.exist?(fs_medium_path)
    "/#{medium_path}"
  end

  def thumb_url
    "/#{url_thumb_path}"
  end

  def grid_url
    "/galleries_medium/#{gallery.folder_name}/#{original_path}"
  end

  def ensure_grid_variant
    ensure_medium_variant
  end
end
