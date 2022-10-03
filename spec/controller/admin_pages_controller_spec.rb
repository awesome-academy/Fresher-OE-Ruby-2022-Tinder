require "rails_helper"

RSpec.describe AdminPagesController, type: :controller do
  let!(:admin){create(:user, admin: true)}
  let(:user1){create(:user, name: "hoang long")}
  let(:user2){create(:user, type_of: "gold")}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(@controller).to receive(:current_ability).and_return(@ability)
  end

  describe "GET #index" do
    describe "search with ransack" do
      before do
        @ability.can :index, :AdminPagesController
        get :index, params: params
      end

      context "by name" do
        let(:params){{name_email_create_at_cont: "long"}}
        it "should return user" do
          expect(assigns(:users)).to eq [admin, user1]
        end
      end

      context "by type of" do
        let(:params){{type_of: "gold"}}
        it "should return gold user" do
          expect(assigns(:users)).to eq [admin, user2]
        end
      end
    end
  end

  describe "PATCH #upgrade" do
    before do
      @ability.can :upgrade, :AdminPagesController
      patch :upgrade, params: {id: input}
    end

    context "switch role user success" do
      let(:input){user1.id}
      it "should update role user" do
        expect(flash[:success]).to be_present
        expect(response).to redirect_to admin_path
      end
    end

    context "switch role user failure" do
      let(:input){-1}
      it do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to admin_path
      end
    end
  end
end
