#json.extract! @employee, :created_at, :updated_at, :name, :num
json.id @employee.id.to_s
json.name @employee.name