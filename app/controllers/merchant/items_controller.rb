class Merchant::ItemsController < Merchant::BaseController

  def index
    # binding.pry
    # @merchant = current_user.merchant
    # @items = @merchant.items
    #
    redirect_to '/items'
  end
end
