require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.build_stubbed(:user) }

  describe "#password" do
    it "when valid" do
      expect(user).to be_valid
    end

    it "is invalid when less than 9 characters" do
      user.password = "foo"
      expect(user).not_to be_valid
    end

    it "is valid with a long new password" do
      user.password = "qqqwwweee1"
      expect(user).to be_valid
    end
  end

  describe "#name" do
    it "is valid when changed to a new name made up of chars/digits/hypens" do
      user.name = "foobar"
      expect(user).to be_valid
    end

    it "is invalid when name contains a non char/digit/hypen" do
      user.name = "foobar@"
      expect(user).not_to be_valid
    end

    it "is invalid when too short" do
      user.name = "foo"
      expect(user).not_to be_valid
    end

    it "is invalid when too long" do
      user.name = "qqqwwweeerrrtttyyyuuu"
      expect(user).not_to be_valid
    end

    it "is invalid when not unique" do
      FactoryBot.create(:user, name: "foobar")
      user.name = "foobar"
      expect(user).not_to be_valid
    end

    it "is invalid when not unique case insensitively" do
      FactoryBot.create(:user, name: "foobar")
      user.name = "FoobaR"
      expect(user).not_to be_valid
    end
  end

  describe "#refresh_expiry" do
    it "is blank by default" do
      expect(user.api_token_refresh_expiry).to be_blank
    end

    it "when called with unset expiry will set a refresh expiry of 6 months" do
      user = FactoryBot.create(:user)
      user.refresh_expiry
      expect(user.api_token_refresh_expiry).to \
        be_within(2.seconds).of 6.months.from_now
    end

    it "when called with expired refresh will set a new refresh expiry" do
      user = FactoryBot.create(:user)
      user.api_token_refresh_expiry = 1.hour.ago
      user.save(validate: false)
      user.refresh_expiry
      expect(user.api_token_refresh_expiry).to \
        be_within(2.seconds).of 6.months.from_now
    end
  end

  describe "#blank_refresh_expiry" do
    it "resets refresh expiry" do
      user = FactoryBot.create(:user)
      user.refresh_expiry
      user.blank_refresh_expiry
      expect(user.api_token_refresh_expiry).to be_blank
    end
  end
end
