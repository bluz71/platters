json.artists @artists, :id, :name, :description, :albums_count, :comments_count
json.pagination do
  json.current_page @artists.current_page
  json.next_page @artists.next_page
  json.prev_page @artists.prev_page
  json.total_pages @artists.total_pages
  json.total_count @artists.total_count
end
