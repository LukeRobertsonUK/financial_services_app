class AddFieldToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :city, :string
  end
end
