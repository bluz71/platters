# frozen_string_literal: true

class User < ActiveRecord::Base
  include Clearance::User

  validates :password, length: {minimum: 9}

  validates :name, presence: true,
                   length: {minimum: 4, maximum: 20},
                   uniqueness: {case_sensitive: false}
end
