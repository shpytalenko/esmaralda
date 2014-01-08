class AddArtistPhotos < ActiveRecord::Migration
  def self.up
    create_table :artist_photos do |t|
      t.integer  :artist_id
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_updated_at
      t.integer  :position
    end
  end
  
  def self.down
    drop_table :artist_photos
  end
end
