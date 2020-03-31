require "rails_helper"

RSpec.describe "User Delete API" do
  it "deletes an account successfully" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    delete "/api/users/#{user.slug}", headers: auth_headers(user)
    expect(response.status).to eq 200
  end

  it "with mismatched authenticity" do
    user1 = FactoryBot.create(
      :user, email: "fred1@example.com", password: "password9", name: "fred1"
    )
    user2 = FactoryBot.create(:user,
      email: "fred2@example.com", password: "password9",
      name: "fred2")
    delete "/api/users/#{user1.slug}", headers: auth_headers(user2)
    expect(response.status).to eq 400
  end

  it "with non-existent user" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    delete "/api/users/bad-fred", headers: auth_headers(user)
    expect(response.status).to eq 404
  end
end
