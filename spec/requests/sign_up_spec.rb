require "rails_helper"

RSpec.describe "Sign Up API" do
  it "with valid user details will send a confirmation email", :perform_enqueued do
    payload = {"user" => {"email" => "fred@example.com",
                          "password" => "password9",
                          "name" => "fred",
                          "application_host" => "http://localhost:4000"}}
    post "/api/users",
      params: payload.to_json, headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 200
    email = find_email!("fred@example.com")
    expect(email.subject).to eq "Platters App email confirmation"
  end

  it "will not create account when email is already in use" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    payload = {"user" => {"email" => user.email,
                          "password" => "password9",
                          "name" => "fred2",
                          "application_host" => "http://localhost:4000"}}
    post "/api/users",
      params: payload.to_json, headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 406
  end

  it "will not create account when name is already in use" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    payload = {"user" => {"email" => "fred2@example.com",
                          "password" => "password9",
                          "name" => user.name,
                          "application_host" => "http://localhost:4000"}}
    post "/api/users",
      params: payload.to_json, headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 406
  end

  it "will not create account when name is not valid" do
    payload = {"user" => {"email" => "fred@example.com",
                          "password" => "password9",
                          "name" => "fre",
                          "application_host" => "http://localhost:4000"}}
    post "/api/users",
      params: payload.to_json, headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 406
  end

  it "will not create account with blank password" do
    payload = {"user" => {"email" => "fred@example.com",
                          "password" => "",
                          "name" => "fred",
                          "application_host" => "http://localhost:4000"}}
    post "/api/users",
      params: payload.to_json, headers: {"CONTENT_TYPE" => "application/json"}
    expect(response.status).to eq 406
  end

  it "will confirm an account with a valid token" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    user.email_confirmation_token = Clearance::Token.new
    user.save
    get "/api/confirm_email/#{user.name}/#{user.email_confirmation_token}"
    expect(response.status).to eq 200
  end

  it "will not confirm an account with an invalid token" do
    user = FactoryBot.create(
      :user, email: "fred@example.com", password: "password9", name: "fred"
    )
    user.email_confirmation_token = Clearance::Token.new
    user.save
    get "/api/confirm_email/#{user.name}/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    expect(response.status).to eq 406
  end
end
