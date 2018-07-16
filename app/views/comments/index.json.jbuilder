json.comments do
  json.array! @comments do |comment|
    json.extract! comment, :id, :body
    json.created_at local_time_ago comment.created_at
    user = comment.user
    json.user_name user.name
    json.user_slug user.slug
    json.gravatar_url gravatar_url(user)
    json.name commentable_name(comment)
    json.path commentable_path_for_api(comment)
  end
end
json.pagination do
  json.extract! @comments, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
