require 'rails_helper'

RSpec.describe "Order Show Page"  do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  describe "As a registered user" do
    before :each  do
      @order_1 = @user.orders.create!(
        name: 'Rodrigo',
        address: '2 1st St.',
        city: 'South Park',
        state: 'CO',
        zip: '84125'
      )

      @item_order = ItemOrder.create!(item: @paper, order: @order_1, quantity: 2, price: (@paper.price * 2))

      @order_2 = @user.orders.create!(
        name: 'Ogirdor',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125'
      )
    end

    it "I can access orders show through the link in orders index" do
      visit "/profile/orders"

      within ".order-#{@order_1.id}" do
        click_on @order_1.id
      end

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it "I can see all order info in orders show" do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.total_quantity_of_items)
      expect(page).to have_content(@order_1.grandtotal)

      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content(@paper.price)

      expect(page).to have_content(@item_order.price)
      expect(page).to have_content(@item_order.quantity)
    end
  end

  describe "When I visit an order show page with discounts" do
    before :each do
      @mike.discounts.create!(
        name: "Ten Percent Off",
        percentage: 10,
        threshold: 2
      )
      @mike.discounts.create!(
        name: "Twenty Five Percent Off",
        percentage: 25,
        threshold: 3
      )
      @meg.discounts.create!(
        name: "Fire Sale",
        percentage: 50,
        threshold: 2
      )
      @order_1 = @user.orders.create!(
        name: 'Rodrigo',
        address: '2 1st St.',
        city: 'South Park',
        state: 'CO',
        zip: '84125'
      )
      @order_1.item_orders.create!(
        item: @paper,
        quantity: 3,
        price: (@paper.discounted_price(3))
      )
      @order_1.item_orders.create!(
        item: @pencil,
        quantity: 2,
        price: (@pencil.discounted_price(2))
      )
      @order_1.item_orders.create!(
        item: @tire,
        quantity: 2,
        price: (@tire.discounted_price(2))
      )
    end

    it "Each item's price and subtotal are updated with eligible discounts" do
      visit "/profile/orders/#{@order_1.id}"

      within "#item-#{@paper.id}" do
        expect(page).to have_content("$15.00")
        expect(page).to have_content("$45.00")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_content("$1.80")
        expect(page).to have_content("$3.60")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_content("$50.00")
        expect(page).to have_content("$100.00")
      end
    end

    it "The order grandtotal is updated with eligible discounts" do
      visit "/profile/orders/#{@order_1.id}"

      within '#grandtotal' do
        expect(page).to have_content("$148.60")
      end
    end
  end
end
