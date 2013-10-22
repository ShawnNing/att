def import_stores
  Store.destroy_all
  stores = JSON.parse(File.read("db/stores.json"))
  stores.each do |store|
    puts "--------------"
    n_store = Store.new
		store = store['store']
    store.each do |k, v|
      next if k=='created_at' || k == 'updated_at'
      k = "num" if k == "store_number"
      k = "oid" if k == "id"
      puts "#{k}=>#{v}"
      n_store.send "#{k}=", v
    end
    n_store.save
  end
end

def import_employees
  Employee.destroy_all
  employees = JSON.parse(File.read("db/employees.json"))
  employees.each do |employee|
    puts "--------------"
    n_employee = Employee.new
		employee = employee['employee']
    employee.each do |k, v|
      next if k=='created_at' || k == 'updated_at' || k == 'active2' || k == 'in1' || k == 'out1' || k == 'in2' || k == 'out2'
      k = "num" if k == "empno"
      k = "oid" if k == "id"
      k = "status" if k == "state"
      
      puts "#{k}=>#{v}"      
      if k == 'store_id' then
        store = Store.where(:oid => v).first
        n_employee.store = store
      else
        n_employee.send "#{k}=", v
      end
    end
    n_employee.save
  end
end

def import_punches
  Punch.destroy_all
  punches = JSON.parse(File.read("db/punches.json"))
  punches.each do |punch|
    puts "--------------"
    n_punch = Punch.new
		punch = punch['punch']
    punch.each do |k, v|
      next if k=='created_at' || k == 'updated_at' || k == 'notes'
      puts "#{k}=>#{v}"      
      if k == 'employee_id' then
        employee = Employee.where(:oid => v).first
        n_punch.employee = employee
      else
        n_punch.send "#{k}=", v
      end
    end
    n_punch.save
  end
end

import_stores
import_employees
import_punches
