# frozen_string_literal: true

class Comment < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  # SCOPES
  scope :list, -> { includes(:user, :commentable).order(created_at: :desc) }
end
