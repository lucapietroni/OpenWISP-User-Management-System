class AddTaxCodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tax_code, :string
    add_column :users, :vat_number, :string
    add_column :users, :iban, :string
  end

  def self.down
    remove_column :users, :iban
    remove_column :users, :vat_number
    remove_column :users, :tax_code
  end
end
