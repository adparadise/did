class CreateTagTable < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :label
    end
    add_index :tags, [:label], :unique => true
  end

  def self.down
    remove_index :tags, :label
    drop_table :tags
  end
end
