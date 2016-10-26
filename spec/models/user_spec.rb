require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { FactoryGirl.build_stubbed(:user) }

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
      FactoryGirl.create(:user, name: "foobar")
      user.name = "foobar"
      expect(user).not_to be_valid
    end

    it "is invalid when not unique case insensitively" do
      FactoryGirl.create(:user, name: "foobar")
      user.name = "FoobaR"
      expect(user).not_to be_valid
    end
  end
end
