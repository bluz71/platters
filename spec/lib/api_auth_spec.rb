require "rails_helper"

RSpec.describe "API Auth" do
  it "encodes a payload" do
    auth_token = ApiAuth.encode(user: "fred@example.com",
                                name: "fred",
                                admin: false)
    expect(auth_token.length).to be > 150
    expect(auth_token.split(".").count).to eq 3
  end

  it "decodes a token" do
    auth_token = ApiAuth.encode(user: "fred@example.com",
                                name: "fred",
                                admin: false)
    id_token = ApiAuth.decode(auth_token)
    expect(id_token["user"]).to eq "fred@example.com"
    expect(id_token["name"]).to eq "fred"
    expect(id_token["admin"]).to eq false
  end
end
