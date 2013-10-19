json.array!(@punches) do |punch|
  json.extract! punch, 
  json.url punch_url(punch, format: :json)
end
