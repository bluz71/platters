require "rails_helper"

RSpec.describe "API Auth" do
  it "encodes a payload" do
    user = FactoryBot.create(
      :user, id: 1, email: "fred@example.com", name: "fred", slug: "fred"
    )
    auth_token = ApiAuth.encode(user)
    expect(auth_token.length).to be > 150
    expect(auth_token.split(".").count).to eq 3
  end

  it "decodes a token" do
    user = FactoryBot.create(
      :user, id: 1, email: "fred@example.com", name: "fred", slug: "fred"
    )
    auth_token = ApiAuth.encode(user)
    id_token = ApiAuth.decode(auth_token)
    expect(id_token["user"]).to eq 1
    expect(id_token["email"]).to eq "fred@example.com"
    expect(id_token["name"]).to eq "fred"
    expect(id_token["slug"]).to eq "fred"
    expect(id_token["admin"]).to eq false
  end

  it "encodes meta-data" do
    user = FactoryBot.create(
      :user, id: 1, email: "fred@example.com", name: "fred", slug: "fred"
    )
    auth_token = ApiAuth.encode(user)
    id_token = ApiAuth.decode(auth_token)
    expect(id_token["iss"]).to eq "platters"
    expect(id_token["aud"]).to eq "platters_app"
    expect(Time.at(id_token["exp"]).utc).to \
      be_within(2.seconds).of 30.minutes.from_now
    expect(Time.at(id_token["refreshExp"]).utc).to \
      be_within(2.seconds).of 6.months.from_now
  end

  it "encodes with a specified refresh expiry" do
    user = FactoryBot.create(
      :user, id: 1, email: "fred@example.com", name: "fred", slug: "fred"
    )
    auth_token = ApiAuth.encode(user, 1.week.from_now)
    id_token = ApiAuth.decode(auth_token)
    expect(Time.at(id_token["refreshExp"]).utc).to \
      be_within(2.seconds).of 1.week.from_now
  end
end
