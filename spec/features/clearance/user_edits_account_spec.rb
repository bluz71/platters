require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "User edits account" do
  scenario "with valid change name"
  scenario "with valid change password"
  scenario "is invalid when name is not unique"
  scenario "with invalid name"
  scenario "with blank password"
  scenario "with short password"
end
