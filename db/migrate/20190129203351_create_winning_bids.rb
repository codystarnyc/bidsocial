class CreateWinningBids < ActiveRecord::Migration[5.2]
  def change
    create_table :winning_bids do |t|
      t.integer :bid_id
      t.integer :item_id
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
