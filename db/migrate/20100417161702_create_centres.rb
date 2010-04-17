class CreateCentres < ActiveRecord::Migration
  def self.up
    create_table :centres do |t|
      t.string :code
      t.string :url
      
      t.string :denomination
      t.string :generic_denomination
      t.string :province_subdivision
      t.string :country
      t.string :region        # Autonomía
      t.string :province      # Provincia
      t.string :town          # Municipio
      t.string :locality      # Localidad
      t.string :county        # Comarca
      t.string :address
      t.string :postal_code
      
      t.string :ownership     # Público || Privado || Concertado
      t.boolean :concerted, :default => false
      t.string :centre_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :centres
  end
end
