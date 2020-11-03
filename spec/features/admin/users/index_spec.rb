require 'rails_helper'

describe 'Admin users index page' do
  before(:each) do
    @user_1 = User.create(name: "John Doe", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "funbucket13@gmail.com", password: "test", role: 0)
    @user_2 = User.create(name: "James", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "merchant@merchant.com", password: "test", role: 1)
    @user_3 = User.create(name: "Jimmy Dean", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "admin@admin.com", password: "test", role: 2)

    @user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password",
                          role: 2
                          )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

  end

  it 'Can see all users in the system and a link to the users show page' do
    visit '/'

    click_link("All Users")

    expect(current_path).to eq('/admin/users')

    within "#user-#{@user_1.id}" do
      expect(page).to have_link(@user_1.name)
      expect(page).to have_content(@user_1.created_at)
      expect(page).to have_content(@user_1.role)
    end

    within "#user-#{@user_2.id}" do
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_2.created_at)
      expect(page).to have_content(@user_2.role)
    end

    within "#user-#{@user_3.id}" do
      expect(page).to have_link(@user_3.name)
      expect(page).to have_content(@user_3.created_at)
      expect(page).to have_content(@user_3.role)
    end

    within "#user-#{@user_1.id}" do
      click_link(@user_1.name)
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}")
  end
end
