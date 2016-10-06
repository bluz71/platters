# frozen_string_literal: true

class User < ActiveRecord::Base
  include Clearance::User

  validates :password, length: {minimum: 9}
end
