require 'rails_helper'

describe "As a merchant when I visit my items index page" do
  before (:each) do
    @dog_shop = Merchant.create(
      name: "Brian's Dog Shop",
      address: '125 Doggo St.',
      city: 'Denver',
      state: 'CO',
      zip: 80210
    )
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

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
  end

  it "I see all of my items and their info" do
    visit '/merchant/items'

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_content(@pull_toy.price)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(@pull_toy.inventory)

      click_link("Deactivate Item")
    end

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("The item is no longer for sale")

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content("Inactive")
      @pull_toy = Item.find(@pull_toy.id)
      expect(@pull_toy.active?).to eq(false)
      expect(page).to_not have_link("Deactivate Item")
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_content(@dog_bone.name)
      expect(page).to have_content(@dog_bone.description)
      expect(page).to have_content(@dog_bone.price)
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content("Inactive")
      expect(page).to have_content(@dog_bone.inventory)

      expect(page).to_not have_link("Deactivate Item")
    end
  end
end
