class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.integer :item_id
      t.integer :user_id
      t.integer :amount

      t.timestamps
    end
    add_index :bids, :item_id
    add_index :bids, :user_id
  end
end
