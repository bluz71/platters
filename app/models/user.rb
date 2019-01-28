# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  # ASSOCIATIONS
  has_many :comments, dependent: :destroy

  # FRIENDLY ID
  extend FriendlyId
  friendly_id :name, use: :slugged

  # VALIDATIONS
  validates :password, length: {minimum: 9}

  VALID_NAME_RE = /\A[\w-]+\z/.freeze
  validates :name, presence: true,
                   length: {minimum: 4, maximum: 20},
                   uniqueness: {case_sensitive: false},
                   format: { with: VALID_NAME_RE }

  after_save :update_comment_timestamps

  def confirm_email
    self.email_confirmed_at = Time.current
    self.email_confirmation_token = nil
    save(validate: false) # Note, we don't want the password validation to run.
  end

private

  def update_comment_timestamps
    # Update all associated comment records using one SQL UPDATE statement.
    # Using 'update_all' is far more efficient than the following:
    #   comments.each(&:touch)
    comments.update_all(updated_at: Time.current)
  end
end
