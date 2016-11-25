# frozen_string_literal: true

class Comment < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  # VALIDATIONS
  validates :body, length: {in: 1..280}

  # SCOPES
  scope :list, -> { includes(:user).order(created_at: :desc) }
end
