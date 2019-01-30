class CreateAuctions < ActiveRecord::Migration[5.2]
  def change
    create_table :auctions do |t|
      t.integer :charity_id
      t.string :name
      t.datetime :start
      t.datetime :finish
      t.string :time_zone_id

      t.timestamps null: false
    end
    add_index :auctions, :charity_id
  end
end
