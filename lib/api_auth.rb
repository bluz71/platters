# frozen_string_literal: true

require 'jwt'

class ApiAuth
  def self.encode(payload)
    payload.merge!(default_options)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base,
               true, algorithm: "HS256").first
  end

  # Validates the payload for expiration and claims.
  def self.valid_payload?(payload)
    if expired?(payload) || payload["iss"] != meta[:iss] || payload["aud"] != meta[:aud]
      false
    else
      true
    end
  end

  # Default options to be encoded in the token.
  def self.default_options
    {exp: 7.days.from_now.to_i, iss: "platters", aud: "platters_app"}
  end

  # Validates if the token is expired by exp parameter
  def self.expired?(payload)
    Time.current.at(payload["exp"]) < Time.current
  end
end
