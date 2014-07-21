require 'time'
require 'date'
dt = Date.parse('2014-06-01')
t1 = Time.parse("Jan 1, 2014 3:23PM")

emp = Employee.where(sin: '503-875-270').first
puts emp.payroll_records.where(date: dt) 