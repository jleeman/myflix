class AdminsController < ApplicationController
  before_filter :require_admin

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You do not have access."
      redirect_to home_path
    end
  end
end
