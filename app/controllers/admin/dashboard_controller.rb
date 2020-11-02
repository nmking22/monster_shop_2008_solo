class Admin::DashboardController < Admin::BaseController
  def show
  end

  def index
    @orders = Order.order(:status)
  end
end
