json.genres do
  json.array! @genres do |genre|
    json.extract! genre, :id, :name
  end
end
