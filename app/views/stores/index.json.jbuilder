json.array!(@stores) do |store|
  json.extract! store, 
  json.url store_url(store, format: :json)
end
