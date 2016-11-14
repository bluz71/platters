class Comment < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
