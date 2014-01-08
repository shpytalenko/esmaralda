class AddArtistAlbums < ActiveRecord::Migration
  def self.up
    create_table :artist_albums do |t|
      t.integer :artist_id
      t.string  :permalink
      t.string  :name
      t.string  :version
      t.string  :label_name
      t.string  :copyright
      t.string  :production_year
      t.text    :description
      t.boolean :is_active, :default => false
      t.integer :position
      
      t.string   :cover_file_name
      t.string   :cover_content_type
      t.integer  :cover_file_size
      t.datetime :cover_updated_at
      t.timestamps
      t.integer  :tracks_count, :default => 0
    end
  end
  
  def self.down
    drop_table :artist_albums
  end
end
