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

    click_button 'Submit'
    expect(current_path).to eq('/profile')

    expect(page).to have_content('User information has been updated.')
    expect(page).to have_content('Spiderman')
    expect(page).to have_content('12345')
  end
end
