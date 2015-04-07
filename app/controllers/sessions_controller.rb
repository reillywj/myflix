class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are signed in, enjoy!"
      redirect_to home_path
    else
      flash[:danger] = "Invalid credentials."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully signed out. Have a nice day!"
    redirect_to root_path
  end
end