class PasswordController < ApplicationController
  def edit
  end

  def update
    current_user.update(password_params)
    redirect_to '/profile', notice: 'Your password has been updated.'
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
