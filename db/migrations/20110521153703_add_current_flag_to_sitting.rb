class AddCurrentFlagToSitting < ActiveRecord::Migration
  def self.up
    add_column :sittings, :current, :boolean
    add_index :sittings, [:current]
  end

  def self.down
    remove_index :sittings, [:current]
    remove_column :sittings, :current
  end
end
