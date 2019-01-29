class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :auction_id
      t.integer :user_id
      t.string :name
      t.text :description
      t.integer :value
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :starting_bid
      t.integer :bid_increment
      t.boolean :approved
      t.boolean :declined
      t.string :name_down

      t.timestamps
    end
    add_index :items, :auction_id
    add_index :items, :name_down
    add_index :items, :user_id
  end
end
