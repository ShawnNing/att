start_tm = Time.parse('2014/03/17 0:00:00 UTC')
end_tm = Time.parse('2014/07/7 0:00:00 UTC')
tm0 = start_tm
while(tm0<end_tm)
  (9 .. 22).each do |h|
    tm = tm0+h.hours
    puts "-----------------"
    puts tm
    Employee.all.each do |emp|
      if emp.in?(tm) then
        puts "#{emp.department}\t\t#{emp.name}"
      end
    end
  end
  tm0 = tm0+1.days
end