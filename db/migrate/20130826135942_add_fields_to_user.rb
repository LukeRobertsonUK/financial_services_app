class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :aasm_state, :string
    add_column :users, :votes_at_manual_reset, :integer
  end
end
