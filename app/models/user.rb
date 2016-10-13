# frozen_string_literal: true

class User < ActiveRecord::Base
  include Clearance::User

  # FRIENDLY ID
  extend FriendlyId
  friendly_id :name, use: :slugged

  # VALIDATIONS
  validates :password, length: {minimum: 9}

  VALID_NAME_RE = /\A[\w-]+\z/
  validates :name, presence: true,
                   length: {minimum: 4, maximum: 20},
                   uniqueness: {case_sensitive: false},
                   format: { with: VALID_NAME_RE }
end
