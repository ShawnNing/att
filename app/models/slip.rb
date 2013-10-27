class Slip
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :employee
  belongs_to :payroll
  accepts_nested_attributes_for :payroll
  
  has_many :punches
	
	field :notes, type: String
end
