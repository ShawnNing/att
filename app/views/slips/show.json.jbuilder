json.id @slip.id.to_s
json.notes @slip.notes
json.employee do
  json.id @slip.employee.id.to_s
  json.num @slip.employee.num
  json.sin @slip.employee.sin
  json.name @slip.employee.name
  json.work_hours @slip.employee.get_work_hours(@slip.payroll.start_date, @slip.payroll.end_date)
end
