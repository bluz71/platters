require "rails_helper"

RSpec.describe "Token Refresh API" do
  it "with valid token" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    get "/api/tokens/new", headers: auth_headers(user)
    expect(response.status).to eq 200
    id_token = ApiAuth.decode(json_response["auth_token"])
    expect(id_token["name"]).to eq "fred"
  end

  it "when token is not provided" do
    get "/api/tokens/new"
    expect(response.status).to eq 400
  end

  it "when refresh expiries do not match" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    headers = auth_headers(user)
    user.blank_refresh_expiry
    get "/api/tokens/new", headers: headers
    expect(response.status).to eq 401
  end

  it "when token has not been updated for long time" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    headers = auth_headers(user)
    travel_to 11.days.from_now do
      get "/api/tokens/new", headers: headers
      expect(response.status).to eq 401
    end
  end

  it "when token refresh period has expired" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    user.api_token_refresh_expiry = 1.second.from_now
    user.save(validate: false)
    get "/api/tokens/new", headers: auth_headers_with_refresh_expiry(user)
    expect(response.status).to eq 401
  end
end
