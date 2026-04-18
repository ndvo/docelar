class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :file_path
      t.string :external_url
      t.boolean :is_external, default: false
      
      t.integer :duration_seconds
      t.string :thumbnail_path
      t.string :video_format
      t.string :resolution
      t.integer :file_size
      
      t.string :imdb_id
      t.string :tmdb_id
      t.integer :release_year
      t.string :genre
      t.text :plot_summary
      t.string :poster_url
      
      t.references :video_category, foreign_key: true
      t.references :user, foreign_key: true
      
      t.integer :playback_position, default: 0
      t.boolean :watched, default: false
      t.datetime :watched_at
      
      t.timestamps
    end

    create_table :video_categories do |t|
      t.string :name
      t.string :color
      t.references :parent, foreign_key: { to_table: :video_categories }
      t.integer :position, default: 0
      t.timestamps
    end

    create_table :video_tags do |t|
      t.string :name
      t.string :color
      t.timestamps
    end

    create_table :video_taggings do |t|
      t.references :video, foreign_key: true
      t.references :tag, foreign_key: { to_table: :video_tags }
    end

    create_table :video_playlists do |t|
      t.string :name
      t.text :description
      t.boolean :is_shared, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end

    create_table :video_playlist_items do |t|
      t.references :playlist, foreign_key: { to_table: :video_playlists }
      t.references :video, foreign_key: true
      t.integer :position, default: 0
    end

    create_table :video_comments do |t|
      t.text :content
      t.integer :timestamp_seconds
      t.boolean :is_spoiler, default: false
      t.references :video, foreign_key: true
      t.references :user, foreign_key: true
      t.references :parent, foreign_key: { to_table: :video_comments }
      t.timestamps
    end

    create_table :video_notes do |t|
      t.text :content
      t.integer :timestamp_seconds
      t.references :video, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end