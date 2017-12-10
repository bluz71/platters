json.artists do
  json.array! @artists do |artist|
    json.cache! artist do
      json.extract! artist, :id, :name, :description, :slug, :albums_count, :comments_count
    end
  end
end
json.pagination do
  json.extract! @artists, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
