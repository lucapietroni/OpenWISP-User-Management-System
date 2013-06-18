class ChangeTypeInUsers < ActiveRecord::Migration
  def self.up
   change_column :users, :inst_indirizzo, :string
   change_column :users, :pg_indirizzo, :string
  end

  def self.down
   change_column :users, :inst_indirizzo, :text
   change_column :users, :pg_indirizzo, :text
  end  
end
