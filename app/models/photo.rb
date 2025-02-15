class Photo < ActiveRecord::Base
  belongs_to :gallery

  def fs_path = File.join(gallery.class.path, gallery.folder_name, file_name)

  def rotate_left
    system "mogrify -rotate -90 \"#{fs_path}\""
  end

  def rotate_right
    system "mogrify -rotate 90 \"#{fs_path}\""
  end
end
