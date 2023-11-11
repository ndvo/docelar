class Photo < ActiveRecord::Base
  def self.find_pictures(folder)
  end

  def generate_thumbnail
    image = MiniMagick::Image.open(original_image_path)
    image.path #=> "/var/folders/k7/6zx6dx6x7ys3rv3srh0nyfj00000gn/T/magick20140921-75881-1yho3zc.jpg"
    image.resize '100x100'
    image.format 'png'
    image.write thumbnail_image_path
  end

  def thumbnail_image_path
    file = original_path
    thumbnail_basename = "#{File.basename(file, File.extname(file))}_thumb#{File.extname(file)}"
    File.join(File.dirname(file), )
  end

  def thumbnail_size
    '100x100'
  end
end
