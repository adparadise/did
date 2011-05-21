class CreateWorkTables < ActiveRecord::Migration
  def self.up
    create_table :spans do |t|
      t.timestamp :start_time
      t.timestamp :end_time
    end

    create_table :spans_tags, :id => false do |t|
      t.integer :span_id
      t.integer :tag_id
    end
    add_index :spans_tags, :tag_id
  end

  def self.down
    remove_index :spans_tags, :tag_id
    drop_table :spans_tags
    drop_table :spans
  end
end
