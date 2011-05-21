class CreateSittingTable < ActiveRecord::Migration
  def self.up
    create_table :sittings do |t|
      t.timestamp :start_time
      t.timestamp :end_time
    end
    add_column :spans, :sitting_id, :integer
  end

  def self.down
    remove_column :spans, :sitting_id
    drop_table :sittings
  end
end
