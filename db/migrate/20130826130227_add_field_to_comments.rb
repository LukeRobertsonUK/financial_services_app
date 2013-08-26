class AddFieldToComments < ActiveRecord::Migration
  def change
    add_column :comments, :aasm_state, :string
    add_column :comments, :votes_at_manual_reset, :integer

  end
end
