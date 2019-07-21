json.partial! "shared/comments", comments: @comments, with_posted_in: true
json.pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
