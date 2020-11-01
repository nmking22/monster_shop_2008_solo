class Admin::UsersDashboardController < Admin::BaseController

  def show
    @user = User.find(params[:id])
  end

  def update
    order = Order.find(params[:order_id])
    order.update(status: 'shipped')
    redirect_to admin_path
  end

end
