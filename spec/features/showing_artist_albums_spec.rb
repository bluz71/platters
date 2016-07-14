require "rails_helper"

RSpec.feature "Showing artist albums" do
  scenario "lists artist albums in reverse chronological order by default"
  scenario "lists artist albums newest to oldest when 'newest' is selected"
  scenario "lists artist albums oldest to newest when 'oldest' is selected"
  scenario "lists artist albums longest to shortest when 'longest' is selected"
  scenario "lists artist albums alphabetically when 'name' is selected"
end
