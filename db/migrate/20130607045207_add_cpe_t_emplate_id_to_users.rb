class AddCpeTEmplateIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cpe_template_id, :integer
  end

  def self.down
    remove_column :users, :cpe_template_id
  end
end
