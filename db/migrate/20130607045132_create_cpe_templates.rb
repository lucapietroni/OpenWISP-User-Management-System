class CreateCpeTemplates < ActiveRecord::Migration
  def self.up
    create_table :cpe_templates do |t|
      t.string :name
      t.text :template
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :cpe_templates
  end
end
