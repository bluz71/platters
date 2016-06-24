require 'rails_helper'

RSpec.describe Track, type: :model do
  context "#title" do
    it "when valid"
    it "is invalid when blank"
  end

  context "#number" do
    it "when valid"
    it "is invalid when less than zero"
    it "is invalid when greater than 150"
  end

  context "#duration_display" do
    it "converts duration from seconds into a displayable form"
  end
end
