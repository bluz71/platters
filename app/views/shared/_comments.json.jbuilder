json.comments do
  json.array! comments do |comment|
    json.extract! comment, :id, :body
    json.created_at local_time_ago comment.created_at
    user = comment.user
    json.user_name user.name
    json.user_slug user.slug
    json.gravatar_url gravatar_url(user)
    json.delete_path destroy_path(comment)
    if with_posted_in
      json.for comment.commentable_type
      json.artist comment.album? ? comment.commentable.artist.name : comment.commentable.name
      json.name commentable_name(comment)
      json.path commentable_path_for_api(comment)
    end
  end
end
