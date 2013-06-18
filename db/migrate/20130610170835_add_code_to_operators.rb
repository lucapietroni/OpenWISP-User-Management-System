class AddCodeToOperators < ActiveRecord::Migration
  def self.up
    add_column :operators, :code, :string
  end

  def self.down
    remove_column :operators, :code
  end
end
