require "rails_helper"
include ApplicationHelper
RSpec.describe User, type: :model do
  describe "Associations" do
    it do
      is_expected.to have_many(:messages).with_foreign_key(:user_send_id).dependent(:destroy)
      is_expected.to have_many(:active_relationships).with_foreign_key(:follower_id).dependent(:destroy)
      is_expected.to have_many(:passive_relationships).with_foreign_key(:followed_id).dependent(:destroy)
    end
  end

  describe "Validations" do
    subject{FactoryBot.build(:user)}
    let(:email){"user@email.com"}
    let(:phone){"0905123123"}

    context "when field name" do
      it "name is valid" do
        is_expected.to validate_presence_of(:name)
      end

      it "name is invalid" do
        expect(FactoryBot.build(:user, name: nil)).not_to be_valid
      end
    end

    context "when field email" do
      it "email is valid" do
        is_expected.to allow_value(email).for(:email)
      end

      it "email is invalid" do
        expect(FactoryBot.build(:user, email: nil)).not_to be_valid
      end
    end

    context "when field date_of_birth" do
      it "date of birth is valid" do
        is_expected.to validate_presence_of(:date_of_birth)
      end

      it "date_of_birth is invalid" do
        expect(FactoryBot.build(:user, date_of_birth: nil)).not_to be_valid
      end
    end

    context "when field gender" do
      it "gender is valid" do
        is_expected.to validate_presence_of(:gender)
      end

      it "gender is invalid" do
        expect(FactoryBot.build(:user, gender: nil)).not_to be_valid
      end
    end

    context "when field phone" do
      it "phone is valid" do
        is_expected.to allow_value(phone).for(:phone)
      end

      it "phone is invalid" do
        expect(FactoryBot.build(:user, phone: "010")).not_to be_valid
      end
    end

    context "when field description" do
      it "description is valid" do
        is_expected.to validate_length_of(:description).is_at_most(Settings.des.max)
      end
    end
  end

  describe "Scope" do
    let(:country_one){FactoryBot.create :country, id: 1}
    let(:country_two){FactoryBot.create :country, id: 2}
    let!(:user_one) do
      FactoryBot.create :user, name: "user1", date_of_birth: "1998-01-20", gender: 0,
    country_id: country_one.id, type_of: 0, admin: true
    end
    let!(:user_two) do
      FactoryBot.create :user, name: "user2", date_of_birth: "1970-01-20", gender: 1,
    country_id: country_two.id, type_of: 1, admin: false
    end

    context "find by gender with value" do
      it "input of gender has value" do
        expect(User.by_gender(user_one.gender)).to eq([user_one])
      end
    end

    context "find by gender with non-value" do
      it "input of gender hasn't value" do
        expect(User.by_gender(nil)).to eq([user_one, user_two])
      end
    end

    context "find by age" do
      it "input of age has value" do
        expect(User.by_age(49, 20)).to eq([user_one])
      end
    end

    context "find by place" do
      it "input of place has value" do
        expect(User.by_place(country_one.id)).to eq([user_one])
      end
    end

    context "find by place with non-value" do
      it "input of place hasn't value" do
        expect(User.by_place(nil)).to eq([user_one, user_two])
      end
    end

    context "find by actived with non-value" do
      it "input of actived hasn't value" do
        expect(User.all).to eq([user_one, user_two])
      end
    end
  end

  describe "Public instance methods" do
    let(:user){FactoryBot.create :user}
    let(:other_user){FactoryBot.create :user}

    describe "#like" do
      it "user like other user" do
        expect(user.like(other_user)).to eq([other_user])
      end
    end

    describe "#like_each_other?" do
      context "when incorrect like each other" do
        it do
          expect(user.like_each_other?(other_user, user)).to be nil
        end
      end

      context "when correct like each other" do
        before "check like each other" do
          other_user.following << user
          user.following << other_user
        end

        it "was liked" do
          expect(user.like_each_other?(other_user, user)).to eq(2)
        end
      end
    end

    describe "#unfollow" do
      it "user unlike other user" do
        user.like other_user
        expect(user.unfollow(other_user)).to eq([other_user])
      end
    end
  end
end
