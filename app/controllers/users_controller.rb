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
      flash[:failure] = "Email already exists, please choose a different email."
      render :new
    elsif params[:password] != params[:password_confirmation]
      flash[:failure] = "Password and Password Confirmation fields did not match."
      render :new
    else
      flash[:failure] = "You are missing required fields."
      render :new
    end
  end

  def show
    render file: "/public/404" unless current_user
  end

  def edit
  end

  def update
    user = User.find_by(email: params[:email])
    if user && user != current_user
      flash[:notice] = 'That email address is already in use.'
      redirect_to '/profile/edit'
    else
      current_user.update(user_params)
      redirect_to '/profile', notice: "User information has been updated."
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end
