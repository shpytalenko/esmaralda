class AddEvents < ActiveRecord::Migration
  def self.up
    create_table :artist_events do |t|
      t.integer :artist_id
      t.string  :permalink
      t.string  :name
      t.date    :date
      t.string  :location_city
      t.string  :location_address
      t.string  :venue_name
      t.string  :show_time
      t.text    :description
      t.string  :tickets_purchase
      t.string  :promotion
      t.boolean :is_active, :default => false
      t.integer :position

      t.timestamps
    end
  end
  
  def self.down
    drop_table :artist_events
  end
end
