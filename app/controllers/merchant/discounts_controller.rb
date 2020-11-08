class Merchant::DiscountsController < Merchant::BaseController
  def index
    user = User.find(current_user.id)
    @merchant = user.merchant
    @discounts = @merchant.discounts
  end

  def new
  end

  def create
    discount = Discount.new(discount_params)
    discount.merchant = current_user.merchant
    discount.save!
    redirect_to '/merchant/discounts'
  end

  private
  def discount_params
    params.permit(:name, :percentage, :threshold)
  end
end
