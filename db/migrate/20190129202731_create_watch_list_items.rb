class CreateWatchListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :watch_list_items do |t|
      t.integer :item_id
      t.integer :user_id
      t.boolean :wants_email, default: false

      t.timestamps
    end
    add_index :watch_list_items, :item_id
    add_index :watch_list_items, :user_id
  end
end
