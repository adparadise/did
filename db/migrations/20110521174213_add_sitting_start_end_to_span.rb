class AddSittingStartEndToSpan < ActiveRecord::Migration
  def self.up
    add_column :spans, :sitting_start, :boolean
    add_column :spans, :sitting_end, :boolean
    add_column :sittings, :end_span_id, :integer
  end

  def self.down
    remove_column :sittings, :end_span_id
    remove_column :spans, :sitting_end
    remove_column :spans, :sitting_start
  end
end
