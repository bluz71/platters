require "rails_helper"

RSpec.describe "Password Reset API" do
  before { ActionMailer::Base.deliveries.clear }

  it "with valid email" do
    user = FactoryBot.create(:user, email: "fred@example.com",
                             password: "password9", name: "fred")
    payload = {"password_reset" => {"email_address" => user.email,
                                    "application_host" => "http://localhost:4000"}}
    post "/api/passwords",
         params: payload.to_json,
         headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 200
    email = find_email!("fred@example.com")
    expect(email.subject).to eq "Platters App change password"
  end

  it "with non-user account" do
    payload = {"password_reset" => {"email_address" => "user3@example.com",
                                    "application_host" => "http://localhost:4000"}}
    post "/api/passwords",
         params: payload.to_json,
         headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 404
  end
end
