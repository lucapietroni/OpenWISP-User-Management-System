class CpeTemplate < ActiveRecord::Base
	belongs_to :user
  
  validates_presence_of :name
    
  def self.search(search)
    search ? (where('name LIKE ?', "%#{search}%")) : scoped
  end	
end
