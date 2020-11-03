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

  it 'I can add a new item' do
    visit '/merchant/items'

    click_on "Add A New Item"
    expect(current_path).to eq('/merchant/items/new')

    fill_in 'Name', with: "Tennis Ball"
    fill_in :description, with: "Just your average run of the mill tasty tennis ball."
    fill_in :price, with: 10
    fill_in :inventory, with: 50

    click_button "Create Item"
    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('Your new item has been saved!')
    expect(page).to have_content('Tennis Ball')
    expect(page).not_to have_content('Inactive')
    expect(page).to have_css("img[src*='https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png']")
    save_and_open_page
  end
end
