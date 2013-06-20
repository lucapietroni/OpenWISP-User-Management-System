class Product < ActiveRecord::Base
	belongs_to :user	
	has_and_belongs_to_many :account_commons, :join_table => 'user_products', :association_foreign_key => :user_id
  
  validates_presence_of :code
  validates_uniqueness_of :code
  def self.search(search)
    search ? (where('code LIKE ? or name LIKE ?', "%#{search}%", "%#{search}%")) : scoped
  end 
end
