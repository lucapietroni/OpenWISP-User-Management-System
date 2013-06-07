class OperatorUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :operator
end