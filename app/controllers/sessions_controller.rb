class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.name}"
      if current_default_user?
        redirect_to '/profile'
      elsif current_merchant_user?
        redirect_to '/merchant'
      else
        redirect_to '/admin'
      end
    else
      flash[:failure] = "Sorry, your credentials are bad."
      render :new
    end
  end
end
