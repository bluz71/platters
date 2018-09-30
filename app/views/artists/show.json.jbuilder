json.artist do
  json.extract! @artist, :name, :description, :wikipedia, :website, :website_link, :slug
end
json.albums do
  json.array! @albums do |album|
    json.extract! album, :id, :title, :tracks_count, :comments_count, :total_duration, :slug
    json.cover_url album.cover.small.url
    json.year album.release_date.year
    json.genre album.genre.name
    json.tracks_summary album.tracks_summary
  end
end
json.partial! 'shared/comments', comments: @comments, with_posted_in: false
json.comments_pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
