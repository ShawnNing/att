class Punch
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :employee
  
  field :employee_id, type: String    
  field :action, type: String    
  field :time, type: DateTime
end
