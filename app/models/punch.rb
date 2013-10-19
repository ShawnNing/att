class Punch
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :employee
  
  field :action, type: String    
  field :time, type: DateTime
end
