# frozen_string_literal: true

require "jwt"

class ApiAuth
  def self.encode(user, refresh_expiry = user.refresh_expiry)
    # User values to be encoded in the token.
    payload = {user: user.id,
               email: user.email,
               name: user.name,
               slug: user.slug,
               admin: user.admin?,}
    # JWT meta-data to be encoded in the token.
    payload.merge!(exp: 30.minutes.from_now.to_i,
                   refreshExp: refresh_expiry.to_i,
                   iss: "platters",
                   aud: "platters_app")
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def self.decode(token, verify = true)
    JWT.decode(token, Rails.application.secrets.secret_key_base, verify,
               algorithm: "HS256").first
  end

  # Validates the payload for expiration and claims.
  def self.valid_payload?(payload, verify_expiry = true)
    if payload["iss"] != "platters" ||
        payload["aud"] != "platters_app" ||
        (verify_expiry && Time.at(payload["exp"]).utc < Time.current.utc)
      false
    else
      true
    end
  end
end
