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
	field :total, type: Float, default: 0
	
	def cal_total1
		t = 0
		if in1== nil  or out1 == nil then
			t = 0
		elsif in2 == nil  or out2 == nil then
			t = (out1 - in1)/3600.0
			t = t - meal + holiday
		else
			t = ((out1 - in1)+(out2 - in2))/3600.0
			t = t - meal + holiday
		end
		t = (t*4+0.5).to_i/4.0
		return t.round(2)
	end

	def cal_total2
		t = 0
		if in1== nil  or out1 == nil then
			t = 0
		elsif in2 == nil  or out2 == nil then
			t = (out1 - in1)/3600.0
			t = t - meal + holiday
		else
			t = ((out1 - in1)+(out2 - in2))/3600.0
			t = t - meal + holiday
		end
		return t.round(2)
	end


end
