class UsersOrdersController <ApplicationController
  def index
    @user = current_user
    @orders = current_user.orders
  end
end
