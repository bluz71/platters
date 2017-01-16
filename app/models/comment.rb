# frozen_string_literal: true

require "obscenity/active_model"

class Comment < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :commentable, polymorphic: true, counter_cache: true, touch: true
  belongs_to :user

  # VALIDATIONS
  validates :body, length: {in: 1..280}, obscenity: {sanitize: true}

  # SCOPES
  scope :list, -> { includes(:user).order(created_at: :desc) }
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current) }

  scope :most_recent, -> do
    includes(:user, :commentable).order(created_at: :desc).limit(10)
  end

  def album?
    commentable_type == "Album" ? true : false
  end
end
