class PayrollRecord
  include Mongoid::Document

  belongs_to :employee

	field :date, type: Date

	field :in1, type: Time
	field :out1, type: Time
	
	field :in2, type: Time
	field :out2, type: Time

	field :overtime, type: Float, default: 0
	field :meal, type: Float, default: 0
	field :sick, type: Float, default: 0
	field :other, type: Float, default: 0
	field :holiday, type: Float, default: 0
	
	def total
		return 0 if in1== nil  or out1 == nil 
		return ((out1 - in1)/3600.0).round(2) if in2 == nil  or out2 == nil
		return (((out1 - in1)+(out2 - in2))/3600.0).round(2) 
	end
end
