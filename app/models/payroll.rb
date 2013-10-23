class Payroll
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :employees
	accepts_nested_attributes_for :employees
  
  field :start_date, type: Date
  field :end_date, type: Date
end
