class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new (user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are now registered and logged in!"
      redirect_to '/profile'
    elsif @user.duplicate_email?
      flash[:notice] = "Email already exists, please choose a different email."
      render :new
    else
      flash[:failure] = "You are missing required fields."
      render :new
    end
  end

  def show
    render file: "/public/404" unless current_user
  end






  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end
