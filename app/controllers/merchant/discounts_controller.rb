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
    if !discount.save
      redirect_to '/merchant/discounts/new', notice: 'All fields must be filled in.'
    elsif discount.invalid_percentage?
      redirect_to '/merchant/discounts/new', notice: 'Discount percentage must be an integer or float between 0 and 100.'
    else
      redirect_to '/merchant/discounts'
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update!(discount_params)
    redirect_to "/merchant/discounts/#{discount.id}"
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:name, :percentage, :threshold)
  end
end
