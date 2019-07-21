json.album do
  json.extract! @album, :title, :tracks_count, :total_duration
  json.artist_name @artist.name
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
json.partial! "shared/comments", comments: @comments, with_posted_in: false
json.comments_pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
