class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.actived? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".success"
      redirect_to user
    else
      flash[:danger] = t ".danger"
      redirect_to root_url
    end
  end
end
