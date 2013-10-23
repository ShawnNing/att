json.array!(@payrolls) do |payroll|
  json.id payroll.id.to_s
  json.extract! payroll, :start_date, :end_date
  #json.url payroll_url(payroll, format: :json)
end
