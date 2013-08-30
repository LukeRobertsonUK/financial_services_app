class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachment_name
      t.references :post

      t.timestamps
    end
    add_index :attachments, :post_id
  end
end
