class AddIsCompanyToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :is_company, :boolean, :default => false
  	add_column :users, :pg_comune, :string
  end

  def self.down
  	remove_column :users, :is_company
  	remove_column :users, :pg_comune
  end
end
