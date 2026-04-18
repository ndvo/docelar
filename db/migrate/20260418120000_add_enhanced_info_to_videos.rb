class AddEnhancedInfoToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :enhanced_at, :datetime
    add_column :videos, :enhanced_method, :string
  end
end