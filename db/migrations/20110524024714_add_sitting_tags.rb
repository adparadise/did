class AddSittingTags < ActiveRecord::Migration
  def self.up
    add_column :sittings, :tag_labels, :string
  end

  def self.down
    remove_column :sittings, :tag_labels
  end
end
