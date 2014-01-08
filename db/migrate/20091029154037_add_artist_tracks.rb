class AddArtistTracks < ActiveRecord::Migration
  def self.up
    create_table :artist_tracks do |t|
      t.integer :album_id
      t.string  :permalink
      t.string  :name
      t.string  :version
      t.string  :featuring
      t.text    :lyrics
      t.text    :description
      t.boolean :is_active, :default => false
      t.integer :position
      
      t.string   :track_file_name
      t.string   :track_content_type
      t.integer  :track_file_size
      t.datetime :track_updated_at
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :artist_tracks
  end
end
