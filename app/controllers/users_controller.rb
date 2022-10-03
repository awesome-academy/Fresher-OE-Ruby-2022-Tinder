class UsersController < ApplicationController
  before_action :find_user_by_id, :authenticate_user!, except: %i(new create)

  def show; end
end
