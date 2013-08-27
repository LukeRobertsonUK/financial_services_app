class AddOwnerToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :editor_id, :integer
  end
end

