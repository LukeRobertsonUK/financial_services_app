class AddFieldToPosts < ActiveRecord::Migration
  def change

    add_column :posts, :aasm_state, :string
    add_column :posts, :votes_at_manual_reset, :integer


  end
end
