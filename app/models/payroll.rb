class Payroll
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :employees
  
  field :start_date, type: Date
  field :end_date, type: Date
end
