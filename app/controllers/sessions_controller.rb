class SessionsController < ApplicationController
  def new
    if current_user
      flash[:success] = "You are already logged in."
      redirect_user
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.name}"
      redirect_user
    else
      flash[:failure] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart] = nil
    flash[:notice] = "You are now logged out."
    redirect_to "/"
  end

  def redirect_user
    if current_default_user?
      redirect_to '/profile'
    elsif current_merchant_user?
      redirect_to '/merchant'
    else
      redirect_to '/admin'
    end
  end
end
