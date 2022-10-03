class MatchPagesController < ApplicationController
  include MatchPagesHelper

  before_action :authenticate_user!
  before_action :find_user_by_id, only: %i(create)

  def index
    check_no_params = %i(gender_choice age_choice place_choice).all? do |key|
      params[key].nil?
    end
    if check_no_params
      get_users
    else
      filter params[:gender_choice], params[:age_choice], params[:place_choice]
    end
  end

  def create
    current_user.like @user
    if check_relationship
      show_notice
    else
      flash[:info] = t(".like")
      redirect_to match_path(page: params[:page])
    end
  end

  def next
    flash[:info] = t(".dont_like")
    redirect_to match_path(page: params[:page])
  end

  def filter gender, age, place
    age_range = age.nil? ? Settings.age.range : age.split("-", 2)
    @pagy,
    @users = pagy(User.by_gender(gender)
                      .by_age(age_range[1].to_i, age_range[0].to_i)
                      .by_place(place)
                      .exclude_id(current_user),
                  items: Settings.digits.size_of_match_page)
  end

  private

  def show_notice
    flash[:info] = t(".like")
    flash[:success] = t(".matched")
    redirect_to match_path(page: params[:page])
  end

  def check_relationship
    @connected = current_user.like_each_other? @user, current_user
  end

  def get_users
    @pagy, @users = pagy(User.all.exclude_id(current_user),
                         items: Settings.digits.size_of_match_page)
  end
end
