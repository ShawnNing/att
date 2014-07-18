`rm /tmp/payroll_*.pdf`
`rm /tmp/odt* -r`
Employee.all.each do |emp|
	puts emp.name
	dt = Date.parse('2014-3-17')
	
	while dt<=Date.parse('2014-6-22')
		start_dt = dt.beginning_of_week
		end_dt = dt.end_of_week
		print_dt = start_dt+20.days+10.hours+rand(60).minutes
		puts "#{start_dt} print at #{print_dt}"
		pdf_file = emp.payroll_report(start_dt, end_dt, print_dt)
		puts "mv #{pdf_file} /tmp/payroll_#{emp.num}_#{start_dt}__#{end_dt}.pdf"
		`mv #{pdf_file} /tmp/payroll_#{emp.num}_#{start_dt}__#{end_dt}.pdf`
	
		dt = dt+7.days
	end
end