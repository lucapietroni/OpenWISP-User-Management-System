class AddProductIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :product_id, :integer
  end

  def self.down
    remove_column :users, :product_id
  end
end
