require 'rails_helper'

RSpec.describe Track, type: :model do
  describe "#title" do
    let(:track) { FactoryBot.build_stubbed(:track, title: "Track") }

    it "when valid" do
      expect(track).to be_valid
    end

    it "is invalid when blank" do
      track.title = ""
      expect(track).not_to be_valid
    end
  end

  describe "#number" do
    let(:track) { FactoryBot.build_stubbed(:track, number: 5) }

    it "when valid" do
      expect(track).to be_valid
    end

    it "is invalid when less than zero" do
      track.number = -5
      expect(track).not_to be_valid
    end

    it "is invalid when greater than 150" do
      track.number = 151
      expect(track).not_to be_valid
    end

    it "is invalid when not an integer" do
      track.number = "Not a number"
      expect(track).not_to be_valid
    end

    it "is invalid when nil" do
      track.number = nil
      expect(track).not_to be_valid
    end
  end

  describe "#duration_display" do
    let(:track) { FactoryBot.build_stubbed(:track, duration: 122) }

    it "converts duration from seconds into a displayable form" do
      expect(track.duration_display).to eq "2:02"
    end
  end
end
