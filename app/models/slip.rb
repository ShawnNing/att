class Slip
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :employee
  belongs_to :payroll
  has_many :punches
  
  field :start_date, type: Date
  field :end_date, type: Date
end
