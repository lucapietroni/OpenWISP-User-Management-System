class CreateOperatorUsers < ActiveRecord::Migration
  def self.up
    create_table :operator_users do |t|
      t.references :user
      t.references :operator
      t.timestamps
    end
  end

  def self.down
    drop_table :operator_users
  end
end
