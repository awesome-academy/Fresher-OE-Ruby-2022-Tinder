module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    User.first
  end

  def logged_in?
    current_user.present?
  end

  def current_user? user
    user && user == current_user
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
