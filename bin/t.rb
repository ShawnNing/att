Employee.all.each do |emp|
	puts emp.name
	dt = Date.parse('2012-12-03')
	while dt<Date.parse('2013-02-03')
		start_dt = dt.beginning_of_week
		end_dt = dt.end_of_week
		pdf_file = emp.payroll_report(start_dt, end_dt)
		`mv #{pdf_file} /tmp/payroll_#{emp.num}_#{start_dt}__#{end_dt}.pdf`
		dt = dt+7.days
	end
end