class AddCropToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :crop_x, :integer
    add_column :videos, :crop_y, :integer
    add_column :videos, :crop_width, :integer
    add_column :videos, :crop_height, :integer
    add_column :videos, :cropped_at, :datetime
  end
end