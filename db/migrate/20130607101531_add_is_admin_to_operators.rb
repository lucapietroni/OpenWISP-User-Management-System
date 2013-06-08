class AddIsAdminToOperators < ActiveRecord::Migration
  def self.up
    add_column :operators, :is_admin, :boolean, :default => false
  end

  def self.down
    remove_column :operators, :is_admin
  end
end
