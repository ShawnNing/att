#Employee.destroy_all
#PayrollRecord.destroy_all

def sec_to_hour(sec)
end

xlsx = "data/1661.xlsx"

book = Roo::Excelx.new(xlsx)

emps = {}
book.each_with_pagename do |name, sheet|
  puts "-----------"
  puts name
  #puts sheet	
end
