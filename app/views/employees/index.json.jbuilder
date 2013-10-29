json.array!(@employees) do |employee|
  json.id employee.id.to_s
  json.extract! employee, :num, :name, :sin
  
  json.r_work_hours employee.get_work_hours(@start_date, @end_date)
  #json.url employee_url(employee, format: :json)
end
