class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
			t.string :name
			t.string :caption
			t.string :value
			t.boolean :is_active, :default => false
			t.integer :position
    end

		add_index :settings, :name
  end

  def self.down
    drop_table :settings
  end
end
