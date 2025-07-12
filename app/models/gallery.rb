class Gallery < ActiveRecord::Base
  include Paginatable

  belongs_to :gallery, optional: true

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
    in_folder_galleries = Dir.children(path_for(gallery))

    new_galleries = in_folder_galleries - Gallery.all.pluck(:name)

    Gallery.insert_all(new_galleries.map do |name|
      {
        name:,
        folder_name: name,
        gallery_id: gallery&.id
      }
    end) if new_galleries.present?

    new_galleries
  end

  def self.path_for(gallery = nil)
    File.join(*[path, gallery].compact)
  end

  def self.path
    "#{Rails.public_path}/#{gallery_folder}"
  end

  def self.thumb_path
    "#{Rails.public_path}/#{thumbs_folder}"
  end

  def self.gallery_folder
    "galleries"
  end

  def self.thumbs_folder
    "galleries_thumbs"
  end
end
