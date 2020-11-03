require 'rails_helper'

describe 'When I visit my items page as a merchant employee' do
  before :each do
    @dog_shop = Merchant.create(
      name: "Brian's Dog Shop",
      address: '125 Doggo St.',
      city: 'Denver',
      state: 'CO',
      zip: 80210
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
  end

  it 'I can edit items if all details are good and present' do
    visit '/merchant/items'

    within "#item-#{@pull_toy.id}" do
      click_on 'Edit Item'
    end

    expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
    expect(page).to have_field(:name, with: @pull_toy.name)
    expect(page).to have_field(:inventory, with: @pull_toy.inventory)

    fill_in :price, with: 20
    fill_in :image, with: ""
    click_button 'Update Item'
    expect(current_path).to eq('/merchant/items')

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content(20)
      expect(page).to have_content('Active')
      expect(page).to have_css("img[src*='https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png']")
    end

    expect(page).to have_content("The #{@pull_toy.name} has been updated.")
  end

  it 'I cannot edit items if details are bad or missing' do
  end
end
