require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  shared_examples "basic user" do
    it{expect(ability).to be_able_to([:read, :update], users[0])}
    it{expect(ability).to be_able_to(:create, Relationship.new)}
    it{expect(ability).to be_able_to([:read, :create], Message.new(user_send_id: users[0].id))}
    it{expect(ability).to be_able_to(:read, msg1)}
  end

  describe "user" do
    let(:users){FactoryBot.create_list(:user, 2, type_of: type)}
    subject(:ability){Ability.new(users[0])}

    let(:rel1){FactoryBot.create :relationship, follower_id: users[0].id, followed_id: users[1].id}
    let(:rel2){FactoryBot.create :relationship, follower_id: users[1].id, followed_id: users[0].id}

    let(:msg1){FactoryBot.create :message, user_send_id: users[1].id, user_receive_id: users[0].id}

    context "type basic" do
      let!(:type){"basic"}
      it_behaves_like "basic user"
    end

    describe "type gold" do
      let!(:type){"gold"}
      it_behaves_like "basic user"
      it{expect(ability).to be_able_to(:update, rel1)}
    end
  end

  describe "admin" do
    let!(:admin){FactoryBot.create :user, type_of: "gold", admin: true}
    subject(:ability){Ability.new(admin)}
    it{expect(ability).to be_able_to(:manage, :AdminPagesController)}
    it{expect(ability).to be_able_to(:destroy, User)}
  end
end
