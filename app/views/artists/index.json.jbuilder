json.artists do
  json.array! @artists do |artist|
    json.extract! artist, :id, :name, :description, :slug, :albums_count, :comments_count
  end
end
json.most_recent do
  json.albums do
    json.array! Album.including.most_recent.each do |album|
      json.extract! album, :id, :title
      json.artist album.artist.name
      json.artist_slug album.artist.slug
      json.album_slug album.slug
      json.cover_url album.cover.small.url
    end
  end
  json.comments do
    json.array! Comment.most_recent.each do |comment|
      json.extract! comment, :id
      json.created_at local_time_ago comment.created_at
      json.user_name comment.user.name
      json.user_slug comment.user.slug
      json.gravatar_url gravatar_url(comment.user)
      json.name commentable_name(comment)
      json.path commentable_path_for_api(comment)
    end
  end
end
json.pagination do
  json.extract! @artists, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
