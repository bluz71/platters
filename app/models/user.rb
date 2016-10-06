# frozen_string_literal: true

class User < ActiveRecord::Base
  include Clearance::User
end
