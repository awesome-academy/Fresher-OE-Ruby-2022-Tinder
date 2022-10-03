require "rails_helper"
RSpec.describe UsersController, type: :controller do
  let(:user){FactoryBot.create :user}
  describe "GET #show" do
    before do
      sign_in user
    end
    context "when user logged" do
      before do
        get :show, params: params
      end

      context "when found" do
        let(:params){{id: user.id}}
        it do
          expect(response).to render_template :show
        end
      end

      context "when not found" do
        let(:params){{id: -1}}
        it do
          expect(response).to render_template("shared/_not_found")
        end
      end
    end
  end
end
