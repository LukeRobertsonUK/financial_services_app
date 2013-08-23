class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.string :website
      t.text :corporate_disclaimer
      t.string :building
      t.string :street_address
      t.string :postcode
      t.string :country
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
