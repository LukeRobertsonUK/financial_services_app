class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :sharing_pref
      t.references :user
      t.boolean :colleague_visible
      t.boolean :non_investor_visible
      t.string :title
      t.text :content
      t.string :post_file

      t.timestamps
    end
    add_index :posts, :user_id
  end
end
