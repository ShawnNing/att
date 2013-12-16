json.array!(@payroll_reports) do |payroll_report|
  json.extract! payroll_report, 
  json.url payroll_report_url(payroll_report, format: :json)
end
