class Store
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :employees
  
  field :name, type: String  
  field :full_name, type: String    
  field :address, type: String      
  field :phone, type: String        
  field :fax, type: String          
  field :num, type: Integer
  field :oid, type: Integer
end
