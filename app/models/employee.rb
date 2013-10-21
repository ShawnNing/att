class Employee
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::Paperclip
  
  belongs_to :store
  belongs_to :payroll
  has_many :punches
  
  field :num, type: String    
  field :barcode, type: String      
  field :name, type: String
  field :name_cn, type: String
  field :gender, type: Boolean
  field :dob, type: Date
  field :soe, type: Date
  field :eoe, type: Date
  
  field :sin, type: String    
  field :dln, type: String    
  field :ohc, type: String      
  
  field :address, type: String    
  field :city, type: String    
  field :provence, type: String      
  field :postal, type: String      
  
  field :home_phone, type: String    
  field :cell_phone, type: String      
  
  field :department, type: String        
  field :position, type: String, default: 'Employee'
  
  field :rate, type: Float

  field :active, type: Boolean, default: 1
  
  field :status, type: String, default: 'out'
  
  field :manager_id, type: Integer, default: 0
  
  field :notes, type: String  
  field :oid, type: Integer
  
  #temporary variable, got to be a better way
  field :work_hours, type: Float
  
  has_mongoid_attached_file :photo
  
  def work_hours
    wh = 0
    if self.punches.length>4 then
    self.punches.each do |punch|
debugger
    end
    end
  end
end
