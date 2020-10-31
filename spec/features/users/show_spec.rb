require 'rails_helper'

describe 'As a user, when I visit user show' do
  before :each do
    @user = User.create!(
      name: "Batman",
      address: "Some dark cave 11",
      city: "Arkham",
      state: "CO",
      zip: "81301",
      email: 'batmansemail@email.com',
      password: "password"
    )

    @existing_user = User.create!(
      name: "Spiderman",
      address: "A1 Sad Apartment",
      city: "Metropolis",
      state: "NY",
      zip: "81305",
      email: 'spideysenses@email.com',
      password: "oneholestraw"
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'I see all profile data except password and a link to edit profile data' do
    visit "/profile"

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip)
    expect(page).to have_content(@user.email)

    expect(page).to have_link("Edit Profile")
  end

  it "the 'Edit Profile' link yields a prepopulated form that can be submitted" do
    visit '/profile'

    click_on 'Edit Profile'
    expect(current_path).to eq('/profile/edit')

    expect(find_field(:name).value).to eq(@user.name)
    expect(find_field(:zip).value).to eq(@user.zip)
    expect(page).to_not have_field(:password)
    expect(page).to_not have_field(:password_confirmation)

    fill_in :name, with: 'Spiderman'
    fill_in :zip, with: '12345'
    fill_in :email, with: 'spidermanemail@gmail.com'

    click_button 'Update Profile'
    expect(current_path).to eq('/profile')

    expect(page).to have_content('User information has been updated.')
    expect(page).to have_content('Spiderman')
    expect(page).to have_content('12345')
  end

  it "I can click on the 'Edit Password' link and fill out a form to change my password" do
    visit '/profile'

    old_password = @user.password_digest

    click_link 'Edit Password'

    expect(current_path).to eq('/password/edit')

    fill_in :password, with: "twoholestraw"
    fill_in :password_confirmation, with: "twoholestraw"

    click_button 'Update Password'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Your password has been updated.')
    expect(@user.password_digest).not_to eq(old_password)
  end

  it 'When I edit my email address it must be unique.' do
    visit '/profile'

    click_on 'Edit Profile'

    expect(current_path).to eq('/profile/edit')

    fill_in :email, with: @existing_user.email
    click_button 'Update Profile'

    expect(current_path).to eq('/profile/edit')
    expect(page).to have_content('That email address is already in use.')

    fill_in :email, with: '1234@gmail.com'
    click_button 'Update Profile'

    expect(current_path).to eq('/profile')
  end

  it 'I cannot see My Orders link if I have no orders.' do
    visit '/profile'

    expect(page).not_to have_link('My Orders')
  end

  it 'The My Orders link takes me to /profile/orders if I have orders.' do
    order_1 = @user.orders.create!(
      name: 'Rodrigo',
      address: '2 1st St.',
      city: 'South Park',
      state: 'CO',
      zip: '84125'
    )

    order_2 = @user.orders.create!(
      name: 'Ogirdor',
      address: '1 2nd St.',
      city: 'Bloomington',
      state: 'IN',
      zip: '24125'
    )

    visit '/profile'
    expect(page).to have_link('My Orders')
    click_on 'My Orders'
    expect(current_path).to eq('/profile/orders')
  end
end
