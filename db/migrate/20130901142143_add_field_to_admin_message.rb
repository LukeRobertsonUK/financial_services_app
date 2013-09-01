class AddFieldToAdminMessage < ActiveRecord::Migration
  def change
    add_column :admin_messages, :content, :string


  end
end
