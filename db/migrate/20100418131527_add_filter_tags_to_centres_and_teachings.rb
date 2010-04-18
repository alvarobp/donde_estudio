class AddFilterTagsToCentresAndTeachings < ActiveRecord::Migration
  def self.up
    add_column :centres, :filter_tags, :text
    add_column :teachings, :filter_tags, :text
  end

  def self.down
    remove_column :centres, :filter_tags
    remove_column :centres, :filter_tags
  end
end
