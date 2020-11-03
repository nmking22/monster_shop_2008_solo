require 'rails_helper'

describe "As a merchant employee when I visit an order show page" do
  before :each do
    @dog_shop = Merchant.create(
      name: "Brian's Dog Shop",
      address: '125 Doggo St.',
      city: 'Denver',
      state: 'CO',
      zip: 80210
    )
    @bike_shop = Merchant.create(
      name: "Meg's Bike Shop",
      address: '123 Bike Rd.',
      city: 'Denver',
      state: 'CO',
      zip: 80203
    )

    @user = User.create!(
      name: "Batman",
      address: "Some dark cave 11",
      city: "Arkham",
      state: "CO",
      zip: "81301",
      email: 'batmansemail@email.com',
      password: "password",
      role: 1,
      merchant: @dog_shop
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @order_1 = @user.orders.create!(
        name: 'Ogirdor',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125'
      )
    @order_2 = @user.orders.create!(
        name: 'Drew Lock',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125',
        status: 2
      )
    @order_3 = @user.orders.create!(
        name: 'Derek Carr',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125'
      )
    @item_order_1 = ItemOrder.create!(
      item: @pull_toy,
      order: @order_1,
      quantity: 1,
      price: (@pull_toy.price * 1)
    )
    ItemOrder.create!(
      item: @dog_bone,
      order: @order_2,
      quantity: 500,
      price: (@dog_bone.price * 500)
    )
    ItemOrder.create!(
      item: @tire,
      order: @order_1,
      quantity: 200,
      price: (@tire.price * 200)
    )
  end

  it 'Can see only the merchants items' do
    visit "/merchant"
    within "#order-#{@order_1.id}" do
      click_link(@order_1.id)
    end


    expect(current_path).to eq("/merchant/orders/#{@order_1.id}")

    expect(page).to have_content(@order_1.name)
    expect(page).to have_content(@order_1.full_address)

    within "#item-order-#{@item_order_1.id}" do
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content("$10.00")
      expect(page).to have_content(@item_order_1.quantity)
    end

    expect(page).not_to have_content(@tire.name)
  end

  it 'can fulfill part of an order ' do
    visit "/merchant/orders/#{@order_1.id}"
      within "#item-order-#{@item_order_1.id}" do
       click_on "Fulfill Item"
      end
    expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
      within "#item-order-#{@item_order_1.id}" do
       expect(page).to have_content("Fulfilled")
      end
    expect(page).to have_content("#{@item_order_1.item.name} has been fulfilled")
    
    expect(Item.find(@pull_toy.id).inventory).to eq(31)
  end

  xit 'cant fulfill order if item_order quantity > item inventory' do

    item_order_1 = ItemOrder.create!(
      item: @pull_toy,
      order: @order_1,
      quantity: 35,
      price: (@pull_toy.price * 1)
    )
    visit "/merchant/orders/#{@order_1.id}"
      within "#item-order-#{@item_order_1.id}" do
       expect(page).to have_content("Item can not be fulfilled due to lack of inventory.")
      end
    end
end
