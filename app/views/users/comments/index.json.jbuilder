json.comments do
  json.array! @comments do |comment|
    json.extract! comment, :id
    json.created_at local_time_ago comment.created_at
    json.user_name comment.user.name
    json.user_slug comment.user.slug
    json.gravatar_url gravatar_url(comment.user)
    json.name commentable_name(comment)
    json.path commentable_path_for_api(comment)
  end
end
