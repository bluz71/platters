require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "when valid"
  it "is invalid with blank comment"
  it "is invalid with comment greater than 280 characters"

  describe "#list" do
    it "when applied to an artist returns associated comments newest to oldest"
    it "when applied to an album returns associated comments newest to oldest"
  end

  describe "#today" do
    it "returns comments only comments posted today"
  end
end
