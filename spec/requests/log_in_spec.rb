require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Log In API" do
  let(:user) do
    FactoryBot.create(:user, email: "user@example.com",
                      password: "password9", name: "fred")
  end

  it "with valid email and password" do
    payload = {"auth_user" => {"email" => user.email, "password" => "password9"}}
    post "/api/log_in",
         params: payload.to_json,
         headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 200
    id_token = ApiAuth.decode(json_response["auth_token"])
    expect(id_token["name"]).to eq "fred"
    expect(id_token["iss"]).to eq "platters"
    expect(id_token["aud"]).to eq "platters_app"
  end

  it "with valid mixed-case email and password" do
    payload = {"auth_user" => {"email" => user.email.upcase, "password" => "password9"}}
    post "/api/log_in",
         params: payload.to_json,
         headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 200
    id_token = ApiAuth.decode(json_response["auth_token"])
    expect(id_token["name"]).to eq "fred"
  end
end
