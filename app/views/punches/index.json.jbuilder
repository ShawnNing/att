json.array!(@punches) do |punch|
  json.extract! punch, :time
end
