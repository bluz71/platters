module Requests
  module ApiHelpers
    def json_response
      JSON.parse(response.body)
    end

    def auth_headers(user)
      auth_token = ApiAuth.encode(user)

      {"Authorization" => "Bearer #{auth_token}",
       "CONTENT_TYPE" => "application/json"}
    end

    def auth_headers_with_refresh_expiry(user)
      auth_token = ApiAuth.encode(user, user.api_token_refresh_expiry)

      {"Authorization" => "Bearer #{auth_token}",
       "CONTENT_TYPE" => "application/json"}
    end
  end
end

RSpec.configure do |config|
  config.include Requests::ApiHelpers, type: :request
end
