class AddTotalSurfTimeToRadacct < ActiveRecord::Migration
  def self.up
    add_column :radacct, :TotalSurfingTime, :integer, :default => 0
  end

  def self.down
    remove_column :radacct, :TotalSurfingTime
  end
end
