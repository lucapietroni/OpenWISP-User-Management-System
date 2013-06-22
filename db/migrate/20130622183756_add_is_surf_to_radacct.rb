class AddIsSurfToRadacct < ActiveRecord::Migration
  def self.up
    add_column :radacct, :is_surf, :boolean, :default => true
  end

  def self.down
    remove_column :radacct, :is_surf
  end
end
