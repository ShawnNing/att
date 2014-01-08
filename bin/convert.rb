#Employee.destroy_all
#PayrollRecord.destroy_all

def sec_to_hour(sec)
end

xlsx = "/home/sning/Downloads/Denishs Schedule (1).xlsx"

book = Roo::Excelx.new(xlsx)

emps = {}
book.each_with_pagename do |name, sheet|	
	(3 .. 4).each do |i|
		row = sheet.row(i)
		sin = row[1]
		if emps[sin] == nil then
			emps[sin] = {}
			
			emp = emps[sin]
			emp['name'] = row[0]
			emp['punches'] = []
		end
		
		emp = emps[sin]
		(1 .. 7).each do |k|
			emp['punches'] << [row[2*k], row[2*k+1]]
		end
	end
end
emps.each do |sin, emp|
	employee = Employee.where(:sin=>sin).first
	puts employee.name
	puts "-----------"
	puts sin
	puts emp['name']
	dt = Date.new(2012, 12, 03)
	emp['punches'].each do |d|
		pr = PayrollRecord.new
		pr.employee = employee
		pr.date = dt
			
		if d[0] != nil and d[1]!=nil then
			d0 = dt + d[0].seconds
			d1 = dt + d[1].seconds
			puts "#{dt}:#{d0.strftime("%H-%M")}--#{d1.strftime("%H-%M")}"
			pr.in1 = d0
			pr.out1 = d1
		end
		pr.save
		dt = dt+1.day
	end
end