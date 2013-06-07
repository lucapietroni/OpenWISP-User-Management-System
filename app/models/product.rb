class Product < ActiveRecord::Base
	belongs_to :user
  
  validates_presence_of :code
  validates_uniqueness_of :code
  def self.search(search)
    search ? (where('code LIKE ? or name LIKE ?', "%#{search}%", "%#{search}%")) : scoped
  end 
end
