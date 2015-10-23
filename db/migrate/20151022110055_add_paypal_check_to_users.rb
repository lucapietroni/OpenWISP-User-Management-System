class AddPaypalCheckToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :paypal, :Boolean
  end

  def self.down
    remove_column :users, :paypal
  end
end
