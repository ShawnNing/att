json.array!(@payrolls) do |payroll|
  json.extract! payroll, 
  json.url payroll_url(payroll, format: :json)
end
