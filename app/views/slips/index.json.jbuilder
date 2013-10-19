json.array!(@slips) do |slip|
  json.extract! slip, 
  json.url slip_url(slip, format: :json)
end
