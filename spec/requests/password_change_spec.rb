require "rails_helper"

RSpec.describe "Password Change API" do
  it "with valid payload" do
    user = FactoryBot.create(:user, email: "fred@example.com",
                             password: "password9", name: "fred")
    user.forgot_password!
    payload = {"password_change" => {"password" => "password10",
                                     "token" => user.confirmation_token}}
    put "/api/users/passwords/#{user.slug}/password",
        params: payload.to_json,
        headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 200
    id_token = ApiAuth.decode(json_response["auth_token"])
    expect(id_token["name"]).to eq "fred"
    expect(id_token["iss"]).to eq "platters"
    expect(id_token["aud"]).to eq "platters_app"
  end

  it "with invalid change token" do
    user = FactoryBot.create(:user, email: "fred@example.com",
                             password: "password9", name: "fred")
    user.forgot_password!
    payload = {"password_change" => {"password" => "password10",
                                     "token" => "bad-token"}}
    put "/api/users/passwords/#{user.slug}/password",
        params: payload.to_json,
        headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 400
  end

  it "with invalid new password" do
    user = FactoryBot.create(:user, email: "fred@example.com",
                             password: "password9", name: "fred")
    user.forgot_password!
    payload = {"password_change" => {"password" => "password",
                                     "token" => user.confirmation_token}}
    put "/api/users/passwords/#{user.slug}/password",
        params: payload.to_json,
        headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 406
  end
end
