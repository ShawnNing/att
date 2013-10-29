class Slip
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :employee
  belongs_to :payroll
  accepts_nested_attributes_for :payroll
  
  field :work_hours, type: Float, default: 0
	field :notes, type: String
  field :punches, type: Array  

  def r_work_hours
    return 0 if self.employee == nil or self.payroll == nil
    wh = 0
		last_checkin = nil
    
		self.punches.each do |punch|
			if punch['action'] == 'checkin' then
				last_checkin = punch['time'].to_i
			elsif punch['action'] == 'checkout' then
				wh = wh + (punch['time'].to_i - last_checkin)
			end
		end
		return wh/3600.0
  end

  after_create do
    if self.employee != nil and self.payroll != nil then
      self.employee.punches.and({:time.gt => self.payroll.start_date}, {:time.lt => self.payroll.end_date}).each do |punch|
        self.punches = [] if self.punches == nil
        self.punches.push({:time=>punch.time.to_i, :action=>punch.action})
      end
      self.save
      self.reload
    end
  end
end
