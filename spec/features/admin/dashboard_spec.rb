require 'rails_helper'

RSpec.describe 'Admin dashboard' do
  describe 'When I visit an admin dashboard page' do
    before(:each) do
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
                            password: "password",
                            role: 2)

      @order_1 = @user.orders.create!(
        name: 'Rodrigo',
        address: '2 1st St.',
        city: 'South Park',
        state: 'CO',
        zip: '84125',
        status: 'cancelled'
      )

      @item_order = ItemOrder.create!(item: @paper, order: @order_1, quantity: 2, price: (@paper.price * 2))

      @order_2 = @user.orders.create!(
        name: 'Ogirdor',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125'
      )

      @order_3 = @user.orders.create!(
        name: 'Obill',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125',
        status: 'packaged'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'can see all orders info sorted by order status' do

      visit '/admin'

      expect(@order_3.name).to appear_before(@order_2.name)
      expect(@order_2.name).to appear_before(@order_1.name)
        within ".order-#{@order_1.id}" do
          expect(page).to have_content(@order_1.id)
          expect(page).to have_content(@order_1.created_at)
          expect(page).to have_content(@order_1.updated_at)
          click_on "#{@order_1.user.name}"
        end
      expect(current_path).to eq("/admin/users/#{@user.id}")
    end
  end
end
