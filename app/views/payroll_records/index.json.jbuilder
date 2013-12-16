json.array!(@payroll_records) do |payroll_record|
  json.extract! payroll_record, 
  json.url payroll_record_url(payroll_record, format: :json)
end
