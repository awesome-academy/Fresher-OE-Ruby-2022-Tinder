class MatchPagesController < ApplicationController
  include MatchPagesHelper

  after_action :random_user, only: %i(create)
  before_action :get_users, :random_user, :logged_in_user
  before_action :find_user, only: %i(create)

  def create
    binding.pry
    current_user.like @user

    respond_to do |format|
      format.js{flash.now[:success] = t ".success_message"}
    end
  end

  private

  def get_users
    @users = User.all
  end

  def random_user
    @list_random_users = @users.sample(10)
  end
end
