# frozen_string_literal: true

require 'jwt'

class ApiAuth
  def self.encode(payload)
    # Default options to be encoded in the token.
    payload.merge!(exp: 7.days.from_now.to_i, iss: "platters", aud: "platters_app")

    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base,
               true, algorithm: "HS256").first
  end

  # Validates the payload for expiration and claims.
  def self.valid_payload?(payload)
    if Time.at(payload["exp"]).utc < Time.current.utc ||
       payload["iss"] != "platters" ||
       payload["aud"] != "platters_app"
      false
    else
      true
    end
  end
end
