class Payroll
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :slips
  accepts_nested_attributes_for :slips
  
  field :start_date, type: Date
  field :end_date, type: Date
  
end
