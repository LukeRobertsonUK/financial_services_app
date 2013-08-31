class CreatePostViewings < ActiveRecord::Migration
  def change
    create_table :post_viewings do |t|
      t.references :user
      t.references :post

      t.timestamps
    end
    add_index :post_viewings, :user_id
    add_index :post_viewings, :post_id
  end
end
