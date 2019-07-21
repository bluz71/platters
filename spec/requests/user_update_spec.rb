require "rails_helper"

RSpec.describe "User Update API" do
  it "with valid new name and password" do
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "fred0", "password" => "password0"}}
    put "/api/users/#{user.slug}",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 200
    id_token = ApiAuth.decode(json_response["auth_token"])
    expect(id_token["name"]).to eq "fred0"
    expect(id_token["iss"]).to eq "platters"
    expect(id_token["aud"]).to eq "platters_app"
  end

  it "with too short a new name" do
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "fre", "password" => "password0"}}
    put "/api/users/#{user.slug}",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 406
    expect(json_response["errors"].first).to include "Name is too short"
  end

  it "with too long a new name" do
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "f" * 22, "password" => "password0"}}
    put "/api/users/#{user.slug}",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 406
    expect(json_response["errors"].first).to include "Name is too long"
  end

  it "with name taken" do
    FactoryBot.create(:user,
                      email: "fred1@example.com", password: "password9",
                      name: "fred1")
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "fred1", "password" => "password0"}}
    put "/api/users/#{user.slug}",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 406
    expect(json_response["errors"].first).to include "Name has already been taken"
  end

  it "with too short a new password" do
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "fred0", "password" => "pass"}}
    put "/api/users/#{user.slug}",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 406
    expect(json_response["errors"].first).to include "Password is too short"
  end

  it "with mismatch authenticity" do
    user1 = FactoryBot.create(:user,
                              email: "fred1@example.com", password: "password9",
                              name: "fred1")
    user2 = FactoryBot.create(:user,
                              email: "fred2@example.com", password: "password9",
                              name: "fred2")
    payload = {"user" => {"name" => "fred", "password" => "password0"}}
    put "/api/users/#{user1.slug}",
      params: payload.to_json, headers: auth_headers(user2)
    expect(response.status).to eq 400
  end

  it "with non-existent user" do
    user = FactoryBot.create(:user,
                             email: "fred@example.com", password: "password9",
                             name: "fred")
    payload = {"user" => {"name" => "fred0", "password" => "password0"}}
    put "/api/users/bad-fred",
      params: payload.to_json, headers: auth_headers(user)
    expect(response.status).to eq 404
  end
end
