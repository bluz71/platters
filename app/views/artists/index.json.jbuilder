json.artists do
  json.array! @artists do |artist|
    json.extract! artist, :id, :name, :description, :slug, :albums_count, :comments_count
  end
end
json.most_recent do
  json.array! Album.including.most_recent.each do |album|
    json.extract! album, :id, :title
    json.artist album.artist.name
    json.cover_url album.cover.small.url
  end
end
json.pagination do
  json.extract! @artists, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
