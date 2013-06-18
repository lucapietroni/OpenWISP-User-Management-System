class AddOtherDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :pg_ragione_sociale, :string
    add_column :users, :pg_partita_iva, :string
    add_column :users, :pg_indirizzo, :string
    add_column :users, :pg_cap, :string
    add_column :users, :pf_cf, :string
    add_column :users, :pf_luogo_di_nascita, :string
    add_column :users, :inst_indirizzo, :string
    add_column :users, :inst_cap, :string
    add_column :users, :inst_cpe_modello, :string
    add_column :users, :inst_cpe_username, :string
    add_column :users, :inst_cpe_password, :string
    add_column :users, :inst_cpe_mac, :string
    add_column :users, :gen_note, :text
  end

  def self.down
    remove_column :users, :pg_ragione_sociale
    remove_column :users, :pg_partita_iva
    remove_column :users, :pg_indirizzo
    remove_column :users, :pg_cap
    remove_column :users, :pf_cf
    remove_column :users, :pf_luogo_di_nascita
    remove_column :users, :inst_indirizzo
    remove_column :users, :inst_cap
    remove_column :users, :inst_cpe_modello
    remove_column :users, :inst_cpe_username
    remove_column :users, :inst_cpe_password
    remove_column :users, :inst_cpe_mac
    remove_column :users, :gen_note    
  end
end
