class Gallery < ActiveRecord::Base
  def list_files
    entries = Dir.children(fs_path)
    entries.map { |i| "#{casamento_folder}/#{@gallery}/#{i}" }
  end

  def generate_thumbnails
  end

  def url_path
    "galleries/#{folder_name}"
  end

  def fs_path
    "#{self.class.path}/#{folder_name}"
  end

  def self.find_new_galleries(gallery)
    in_folder_galleries = Dir.children(path_for(gallery))

    new_galleries = in_folder_galleries - Gallery.all.pluck(:name)

    Gallery.insert_all(new_galleries.map { |name| { name: name } }) if new_galleries.present?
  end

  def self.path_for(gallery)
    File.join(*[path, gallery].compact)
  end

  def self.path
    "#{Rails.public_path}/galleries"
  end
end
