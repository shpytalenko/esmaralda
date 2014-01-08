class AddArtistVideos < ActiveRecord::Migration
  def self.up
    create_table :artist_videos do |t|
      t.integer :artist_id
      t.string  :permalink
      t.string  :name
      t.string  :source_link
      t.string  :source_id
      t.string  :source_type
      t.text    :description
      t.boolean :is_active, :default => false
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :artist_videos
  end
end
