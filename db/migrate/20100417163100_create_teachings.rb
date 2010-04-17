class CreateTeachings < ActiveRecord::Migration
  def self.up
    create_table :teachings do |t|
      t.integer :centre_id
      
      t.string  :level
      t.string  :area
      t.string  :teaching
      t.string  :mode
      t.boolean :concerted
      
      t.timestamps
    end
  end

  def self.down
    drop_table :teachings
  end
end
