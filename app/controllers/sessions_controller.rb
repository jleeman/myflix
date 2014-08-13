class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.full_name}! You have successfully logged in."
        redirect_to home_path
      else
        flash[:danger] = "Your account has been deactivated, please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = 'There is something wrong with your email/password.'
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You have logged out.'
    redirect_to root_path
  end
end
