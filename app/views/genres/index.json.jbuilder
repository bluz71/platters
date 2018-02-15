json.genres do
  json.array! @genres do |genre|
    json.cache! genre do
      json.extract! genre, :id, :name
    end
  end
end
