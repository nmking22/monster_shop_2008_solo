require 'rails_helper'

describe 'Logging out' do
  it 'I can log out as a current user' do
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password")
    # bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    # tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    #
    # user.items << tire
    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Log In'

    expect(current_path).to eq('/profile')
    expect(page).to have_no_content("Log In")

    click_on 'Log Out'

    expect(current_path).to eq("/")
    expect(page).to have_content("You are now logged out.")
    expect(page).to have_content("Cart: 0")
    expect(page).to have_content("Log In")
  end
end
