class Gallery < ActiveRecord::Base
  include Paginatable

  belongs_to :gallery, optional: true
  has_many :photos

  validates :folder_name, uniqueness: true

  def file_names
    Dir.glob("#{fs_path}/*.{png,jpeg,jpg}")
  end

  def url_path
    "#{self.class.gallery_folder}/#{folder_name}"
  end

  def url_thumbs_path
    "#{self.class.thumbs_folder}/#{folder_name}"
  end

  def fs_path
    "#{self.class.path}/#{folder_name}"
  end

  def fs_thumbs_path
    full_path = "#{self.class.thumb_path}/#{folder_name}"
    FileUtils.mkdir_p(full_path) unless File.directory?(full_path)
    full_path
  end

  def self.find_new_galleries(gallery = nil)
    new_galleries = available_folders - Gallery.all.pluck(:name)
    return unless new_galleries.present?

    Gallery.insert_all(new_galleries.map do |name|
      {
        name:,
        folder_name: name,
        gallery_id: gallery&.id
      }
    end)

    new_galleries
  end

  def available_image_files
    Dir.children(fs_path).filter do |folder_name|
      folder_name.match?(/\.(png|jpeg|jpg)/i)
    end
  end

  def self.available_folders(gallery = nil)
    Dir.children(path_for(gallery)).filter do |folder_name|
      folder_name.match?(/^\w+$/)
    end
  end

  def self.path_for(gallery = nil)
    File.join(*[path, gallery].compact)
  end

  def self.path = Rails.root.join(gallery_folder)

  def self.thumb_path = "#{Rails.public_path}/#{thumbs_folder}"

  def self.gallery_folder = 'galleries'

  def self.thumbs_folder = 'galleries_thumbs'
end
