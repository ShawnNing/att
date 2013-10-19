#this should run under the old system
File.open("/tmp/stores.json", "w") do |f|
  f.puts Store.all.to_json
end
File.open("/tmp/employees.json", "w") do |f|
  f.puts Employee.all.to_json
end
File.open("/tmp/punchs.json", "w") do |f|
  f.puts Punch.all.to_json
end
