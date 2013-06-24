class AddHasCreditsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :has_credits, :boolean, :default => false
  end

  def self.down
    remove_column :users, :has_credits
  end
end
