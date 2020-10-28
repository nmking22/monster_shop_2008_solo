class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_default_user?, :current_merchant_user?, :current_admin_user?

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_default_user?
    current_user && current_user.default_user?
  end

  def current_merchant_user?
    current_user && current_user.merchant_user?
  end

  def current_admin_user?
    current_user && current_user.admin_user?
  end
end
