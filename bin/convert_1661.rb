require 'date'
Employee.destroy_all
PayrollRecord.destroy_all

def sec_to_hour(sec)
end

def verify(tin, tout)
	if tout-tin!=0 then
		dlt = tout-tin
		possible_dlt = [2, 3, 4, 5, 6, 7,8, 9, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 4.75, 4.25, 10, 3.25, 5.25, 5.75, 6.75, 7.25, 7.75, 8.25, 8.75, 8.8, 9.75]
		if not possible_dlt.include?(dlt) then
			#puts "#{tout-tin}===========#{tin}-->#{tout}"
			puts "#{tout-tin}"
		end
	end
end

def process(rs, sheet, dt)
	puts "------------#{dt}-------"
	(rs[0] .. rs[-1]).each do |r|
		row = sheet.row(r)

		emp = {}
		sin = row[2]
		emp['sin'] = row[2]
		emp['name'] = row[1]
		emp['dept'] = row[3]
		emp['pos'] = row[4]
		emp['punches'] = []
		
		(0 .. 6).each do |k|
			tin = row[8+2*k]
			tout = row[8+2*k+1]
			tin = 0 if tin==nil
			tout = 0 if tout==nil
			tin = tin+12 if tin < 7
			tout = tout+12 if tout<tin
			
			#verify(tin, tout)
			dt_in = dt+k.days+tin.hours
			dt_out = dt+k.days+tout.hours
			
			emp['punches'] << [dt_in, dt_out]
		end
		
#puts emp

		employee = Employee.where(:sin=>sin).first
		if employee==nil then
			employee = Employee.new
			employee.name = emp['name']
			employee.sin = emp['sin']
			
			puts name.downcase
			if $empnos[emp['name'].downcase] != nil then
				employee.num = $empnos[emp['name'].downcase]
			else
				puts "cannot find empno #{$empnos[name]} for #{name}"
				employee.num = "39%03d" % $empno
				$empno = $empno + 1
			end
			
			employee.department = emp['dept']
			employee.position = emp['pos']
			employee.save
		else
			if employee.department != emp['dept'] then
				employee.department = emp['dept']
				employee.save
			end
			if employee.position != emp['pos'] then
				employee.position = emp['pos']
				employee.save
			end
		end

		#puts employee.name
		#puts "-----------"
		#puts sin
		#puts emp['name']
		
		emp['punches'].each do |d|
			if d[1] - d[0] > 0.1 then
				pr = PayrollRecord.new
				rd = rand
				pr.in1 = d[0]+(rand(16)-8).minutes
				pr.out1 = d[1]+(rand(16)-8).minutes
				pr.meal = 0.5
				pr.holiday = 0
				d0_str = d[0].strftime("%-m/%-d/%Y")
				if ['5/19/2014','6/1/2014','7/13/2014'].include?(d0_str) then
					if $emps[emp['sin']]!=nil then
						pr.holiday = $emps[emp['sin']][d[0].to_date] 
						pr.holiday = 0 if pr.holiday==nil
						puts "holiday #{emp['sin']} #{d0_str} #{pr.holiday}"
					end
				end
				
				pr.employee = employee
				pr.date = d[0]
				pr.save
			end
		end
		
	end
end

def read_data
	xlsx = "data/1661.xlsx"

	book = Roo::Excelx.new(xlsx)

	book.each_with_pagename do |name, sheet|	
		p name
		dp = nil
		d1 = nil
		d2 = nil
		if name =~/(.*)\((.*)-(.*)\)/ then
			dp = $1
			d1 = $2
			d2 = $3
		end
		d1 = d1.sub('.', ' ')+", 2014"
		d2 = d2.sub('.', ' ')+", 2014"
		d1 = Date.strptime(d1, "%b %d, %Y")
		d2 = Date.strptime(d2, "%b %d, %Y")
		
		rs = []
		r = 1
		null = 0
		istart = 0
		iend = 0
		biweek = false
		begin
			row = sheet.row(r)
			cell = row[0]
			if cell.class == Float then
				if cell == 1 then
					if rs.length>1 then
						process(rs, sheet, d1)
						d1 = d1+7.days
						biweek = true
						rs = []
					end
				end
				rs << r
			elsif cell==nil then
				null = null + 1
			end
			break if null > 4
			r = r + 1
		end until  r>1000
		process(rs, sheet, d1)
		process(rs, sheet, d1+7.days) if !biweek
	end
end

$emps = {}
$empnos = {}
$empno = 127
def add_employee(name, sin, dt, hour)
	return if sin == nil

	puts name.downcase
	if $empnos[name.downcase] != nil then
		puts $empnos[name.downcase]
	else
		puts "cannot find empno #{$empnos[name]} for #{name}"
	end



	if dt.strftime("%Y-%-m-%-d") == "2014-5-4" then
		dt = Date.parse("2014/5/19")
	end

	if $emps[sin]==nil then
		$emps[sin] = {'name'=>name}
		$emps[sin][dt] = hour
	else
		if $emps[sin]['name'] != name then
			puts "name changed #{sin}"
		end
		
		if $emps[sin][dt] != nil then
			puts "#{dt} existed"
		else
			$emps[sin][dt] = hour
		end
	end
end

def read_holiday
	xlsx = "data/2014Eglinton.xlsx"
	book = Roo::Excelx.new(xlsx)

	
	book.each_with_pagename do |name, sheet|	
		(1 .. 100).each do |r|
			row = sheet.row(r)
			
			name1 = row[1]
			sin1 = row[2]
			dt1 = row[3]
			hour1 = row[4]
			add_employee(name1, sin1, dt1, hour1)
			
			name2 = row[6+1]
			sin2 = row[6+2]
			dt2 = row[6+3]
			hour2 = row[6+4]
			add_employee(name2, sin2, dt2, hour2)

			name3 = row[12+1]
			sin3 = row[12+2]
			dt3 = row[12+3]
			hour3 = row[12+4]
			add_employee(name3, sin3, dt3, hour3)
		end
	end
end

def read_empno
	ls = File.read('data/emp.txt')
	ls.split("\n").each do |l|
		foo, name, empno = l.split('|')
		empno.strip!
		name.strip!
		#first, last = name.split(' ')
		#name = last+' '+first if last!=nil
		$empnos[name.downcase] = empno
	end
	puts $empnos
end

read_empno
read_holiday

#read_data