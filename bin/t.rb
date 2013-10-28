e9 = Employee.where(:num=>999).first
puts e9.name
e8 = Employee.where(:num=>888).first
puts e8.name

Slip.destroy_all
Payroll.destroy_all

params = ActionController::Parameters.new({"payroll"=>{:start_date=>"2013-10-07", :end_date=>"2013-10-20"}})
p = params.require(:payroll).permit(:start_date, :end_date)
Payroll.create(p)
payroll = Payroll.first
payroll_id = payroll.id.to_s
puts payroll.start_date
puts payroll.end_date
puts payroll.slips.length

params = ActionController::Parameters.new({:payroll=>{:start_date=>"2013-10-09", :slips_attributes=>[{:notes=>'notes8', :employee_id=>e8.id.to_s}, {:notes=>'notes9', :employee_id=>e9.id.to_s}]}})
p = params.require(:payroll).permit(:start_date, :slips_attributes=>[:id, :notes, :employee_id])
puts p
payroll.update(p)
payroll = Payroll.first
puts payroll.start_date
puts payroll.end_date
puts payroll.slips.length
puts payroll.slips[0].notes
slip_id = payroll.slips[0].id.to_s

params = ActionController::Parameters.new({:payroll=>{:start_date=>"2013-10-10", :slips_attributes=>[{:id=>slip_id, :notes=>'notes88'}]}})
p = params.require(:payroll).permit(:start_date, :slips_attributes=>[:id, :notes, :employee_id])
puts p
payroll.update(p)
payroll = Payroll.first
puts payroll.start_date
puts payroll.end_date
puts payroll.slips.length
puts payroll.slips[0].notes
slip_id = payroll.slips[0].id.to_s

#puts slip_id
#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll_id"=>"#{payroll_id}"}})
#p = params.require(:slip).permit(:start_date, :payroll_id)

#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll_id"=>"#{payroll_id}", :employee_id=>"#{employee_id}", :foo=>"dsadas"}})
#p = params.require(:slip).permit(:start_date, :payroll_id, :employee_id)

#slip = Slip.new(p)
#puts "#{slip.payroll.id.to_s} == #{payroll_id}---#{slip.payroll.id.to_s == payroll_id}"
#puts "#{slip.employee.id.to_s} == #{employee_id}---#{slip.employee.id.to_s == employee_id}"

#params = ActionController::Parameters.new({"payroll"=>{"id"=>"526aa05c7531320ddc000000", "start_date"=>"2013-10-07", "end_date"=>"2013-10-20", "slips"=>nil}, "start_date"=>"2013-10-07", "id"=>"526aa05c7531320ddc000000", "slip"=>{"start_date"=>"2013-10-07"}})

#params = ActionController::Parameters.new({"slip"=>{"start_date"=>"2013-10-07", "payroll"=>{"id"=>"526aa05c7531320ddc000000"}}})
