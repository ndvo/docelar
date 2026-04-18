class AddAudioEnhancementToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :enhance_audio, :boolean, default: false
    add_column :videos, :enhance_audio_status, :integer, default: 0
  end
end
