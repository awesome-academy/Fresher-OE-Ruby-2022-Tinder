class Admin::AdminPagesController < ApplicationController
  Pagy::DEFAULT[:items] = Settings.digits.size_of_admin_page
  authorize_resource class: :AdminPagesController

  def index
    @search = User.includes([:country])
                  .ransack(params[:q])
    @pagy, @users = pagy @search.result
  end

  def upgrade
    user = User.find_by id: params[:id]
    if user
      user.switch_role
      flash[:success] = t ".sc_mes"
      redirect_back(fallback_location: admin_root_path)
    else
      flash[:danger] = t ".f_mes"
      redirect_to admin_root_path
    end
  end

  def import
    if params[:file]
      begin
        User.import_file(params[:file])
        flash[:success] = t "sc_mes"
      rescue StandardError => e
        flash[:warning] = e.message
      end
    else
      flash[:warning] = t "f_mes"
    end
    redirect_to admin_root_path
  end

  def export
    @users_excel = User.all
    respond_to do |format|
      format.html
      format.xlsx
    end
  end
end
