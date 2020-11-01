require 'rails_helper'

describe "As a merchant employee, when I visit '/merchant'" do
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
  end

  it 'I see the name and full address of the merchant I work for' do
    visit '/merchant'

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@dog_shop.full_address)
  end

  it 'I see a link to view my own items which redirects me to /merchant/items.' do
    visit '/merchant'

    expect(page).to have_link('View My Items')

    click_link 'View My Items'

    expect(current_path).to eq('/merchant/items')
  end
end
