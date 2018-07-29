json.artist do
  json.extract! @artist, :name, :description, :wikipedia, :website
end
json.albums do
  json.array! @albums do |album|
    json.extract! album, :id, :title, :tracks_count, :comments_count, :total_duration
    json.cover_url album.cover.small.url
    json.year album.release_date.year
    json.genre album.genre.name
    json.tracks_summary album.tracks_summary
  end
end
json.comments do
  json.array! @comments do |comment|
    json.extract! comment, :id, :body
    json.created_at local_time_ago comment.created_at
    user = comment.user
    json.user_name user.name
    json.user_slug user.slug
    json.gravatar_url gravatar_url(user)
  end
end
json.comments_pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
