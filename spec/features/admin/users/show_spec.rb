require 'rails_helper'

describe 'Admin User Profile Page' do
  it 'Can see all users information, but no edit links' do
    user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password",
                          role: 2
                          )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    user_1 = User.create(name: "John Doe", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "funbucket13@gmail.com", password: "test", role: 0)

    visit "/admin/users/#{user_1.id}"

    expect(page).to have_content(user_1.name)
    expect(page).to have_content(user_1.address)
    expect(page).to have_content(user_1.city)
    expect(page).to have_content(user_1.state)
    expect(page).to have_content(user_1.zip)
    expect(page).to have_content(user_1.email)

    expect(page).not_to have_link("Edit Profile")
    expect(page).not_to have_link("Edit Password")
  end
end
