module Requests
  module ApiHelpers
    def json_response
      JSON.parse(response.body)
    end

    def auth_headers(user)
      auth_token = ApiAuth.encode(user: user.id,
                                  name: user.name,
                                  admin: user.admin?)

      {headers: {"Authorization" => "Bearer #{auth_token}"}}
    end
  end
end

RSpec.configure do |config|
  config.include Requests::ApiHelpers, type: :request
end
