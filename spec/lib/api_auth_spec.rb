require "rails_helper"

RSpec.describe "API Auth" do
  it "encodes a payload" do
    user = FactoryBot.create(:user,
                             id: 1,
                             email: "fred@example.com",
                             name: "fred",
                             slug: "fred")
    auth_token = ApiAuth.encode(user)
    expect(auth_token.length).to be > 150
    expect(auth_token.split(".").count).to eq 3
  end

  it "decodes a token" do
    user = FactoryBot.create(:user,
                             id: 1,
                             email: "fred@example.com",
                             name: "fred",
                             slug: "fred")
    auth_token = ApiAuth.encode(user)
    id_token = ApiAuth.decode(auth_token)
    expect(id_token["user"]).to eq 1
    expect(id_token["email"]).to eq "fred@example.com"
    expect(id_token["name"]).to eq "fred"
    expect(id_token["slug"]).to eq "fred"
    expect(id_token["admin"]).to eq false
  end
end
