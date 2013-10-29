json.id @payroll.id.to_s
json.extract! @payroll, :start_date, :end_date

json.slips @payroll.slips do |slip|
  json.id slip.id.to_s
  json.notes slip.notes
  json.work_hours slip.work_hours
  
  json.employee do |employee|
    json.id slip.employee.id.to_s
    json.num slip.employee.num
    json.sin slip.employee.sin
    json.name slip.employee.name
  end
  
  json.punches slip.punches
  json.r_work_hours slip.r_work_hours
  json.e_work_hours slip.employee.get_work_hours(slip.payroll.start_date, slip.payroll.end_date)
end



