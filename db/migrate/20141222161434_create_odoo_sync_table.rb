class CreateOdooSyncTable < ActiveRecord::Migration
  def self.up
   create_table :user_openwisp_odoo, {:id => false} do |t|
      t.references :uid_openwisp
      t.references :uid_odoo
      t.timestamps
      end
  end

  def self.down
 	 drop_table :user_openwisp_odoo
  end
end
