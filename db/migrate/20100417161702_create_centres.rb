class CreateCentres < ActiveRecord::Migration
  def self.up
    create_table :centres do |t|
      t.string :code
      t.string :url
      
      t.string :denomination
      t.string :generic_denomination
      
      t.string :country
      t.string :region
      t.string :province
      t.string :town
      t.string :locality
      t.string :county
      t.string :address
      t.string :postal_code
      
      t.string :ownership
      t.boolean :concerted
      t.string :centre_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :centres
  end
end
