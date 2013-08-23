class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firm_id, :integer
  end
end
