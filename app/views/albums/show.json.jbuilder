json.album do
  json.title @album.title
  json.artist_name @artist.name
  json.track_count @tracks_count
  json.total_duration @album.total_duration
  json.genre @album.genre.name
  json.year @album.release_date.year
  json.cover_url @album.cover.url
end
json.tracks do
  json.array! @tracks.order(:number) do |track|
    json.extract! track, :id, :title, :number
    json.duration track.duration_display
  end
end
json.comments do
  json.array! @comments do |comment|
    json.extract! comment, :id
    json.created_at local_time_ago comment.created_at
    user = comment.user
    json.user_name user.name
    json.user_slug user.slug
    json.gravatar_url gravatar_url(user)
    json.name commentable_name(comment)
    json.path commentable_path_for_api(comment)
  end
end
json.comments_pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
