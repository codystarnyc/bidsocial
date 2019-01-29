class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fName, :string
    add_column :users, :lName, :string
    add_column :users, :username, :string
  end
end
