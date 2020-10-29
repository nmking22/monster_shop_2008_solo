require 'rails_helper'

describe 'As a user, when I visit user show' do
  it 'I see all profile data except password and a link to edit profile data' do
    user = User.create!(
      name: "Batman",
      address: "Some dark cave 11",
      city: "Arkham",
      state: "CO",
      zip: "81301",
      email: 'batmansemail@email.com',
      password: "password"
    )
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)

    expect(page).to have_link("Edit Profile")
  end
end
