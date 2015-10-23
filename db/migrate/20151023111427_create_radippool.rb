class CreateRadippool < ActiveRecord::Migration
  def self.up
    create_table :radippool do |t|
      t.string :pool_name
      t.string :framedipaddress
      t.string :nasipaddress
      t.string :calledstationid
      t.string :callingstationid
      t.datetime :expiry_time
      t.string :username
      t.string :pool_key
    end
  end

  def self.down
    drop_table :radippool
  end
end

