class CreateAdminMessages < ActiveRecord::Migration
  def change
    create_table :admin_messages do |t|
      t.integer :subject_id
      t.string :subject_class
      t.boolean :seen_by_admin
      t.boolean :addressed_by_admin

      t.timestamps
    end
  end
end
