class AddArtistLinks < ActiveRecord::Migration
  def self.up
    create_table :artist_links do |t|
      t.integer :artist_id
      t.string  :href
      t.boolean :is_active, :default => false
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :artist_links
  end
end
