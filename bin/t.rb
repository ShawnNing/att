payroll = Payroll.first
payroll_id = payroll.id.to_s
employee = Employee.first
employee_id = employee.id.to_s


#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll"=>{"id"=>"#{payroll_id}"}}})
#p = params.require(:slip).permit(:start_date, :payroll=>[:id])

#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll_id"=>"#{payroll_id}"}})
#p = params.require(:slip).permit(:start_date, :payroll_id)

params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll_id"=>"#{payroll_id}", :employee_id=>"#{employee_id}", :foo=>"dsadas"}})
p = params.require(:slip).permit(:start_date, :payroll_id, :employee_id)

slip = Slip.new(p)
puts "#{slip.payroll.id.to_s} == #{payroll_id}---#{slip.payroll.id.to_s == payroll_id}"
puts "#{slip.employee.id.to_s} == #{employee_id}---#{slip.employee.id.to_s == employee_id}"

#params = ActionController::Parameters.new({"payroll"=>{"id"=>"526aa05c7531320ddc000000", "start_date"=>"2013-10-07", "end_date"=>"2013-10-20", "slips"=>nil}, "start_date"=>"2013-10-07", "id"=>"526aa05c7531320ddc000000", "slip"=>{"start_date"=>"2013-10-07"}})

#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll"=>{"id"=>"526aa05c7531320ddc000000"}}})
