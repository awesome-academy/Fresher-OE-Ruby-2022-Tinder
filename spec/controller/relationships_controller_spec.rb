require "rails_helper"

RSpec.describe RelationshipsController, type: :controller do
  describe "DELETE #destroy" do
    let!(:users){FactoryBot.create_list(:user, 2)}

    before do
      sign_in users[0]
    end

    let!(:rel1) do
      FactoryBot.create :relationship, follower_id: users[0].id,
    followed_id: users[1].id, status: true
    end
    let!(:rel2) do
      FactoryBot.create :relationship, follower_id: users[1].id,
    followed_id: users[0].id, status: true
    end

    it "update relationship status from true to false" do
      delete :destroy, params: {id: rel1.id}
      rel2.reload
      expect(rel2.status).to be false
    end

    it "redirect to current_user" do
      delete :destroy, params: {id: rel1.id}
      expect(response).to redirect_to users[0]
    end
  end
end
