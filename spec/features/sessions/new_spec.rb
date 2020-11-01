require 'rails_helper'

RSpec.describe 'Logging In' do
  it 'can log in as default user with valid credentials' do
    user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password")

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Log In'

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_content("Welcome, #{user.name}")
    expect(page).to have_link('Log Out')
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end

  it 'can log in as merchant user with valid credentials' do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 1,
                        merchant: bike_shop)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Log In'

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_content("Welcome, #{user.name}")
    expect(page).to have_link('Log Out')
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end

  it 'can log in as admin user with valid credentials' do
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 2)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Log In'

    expect(current_path).to eq('/admin')
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_content("Welcome, #{user.name}")
    expect(page).to have_link('Log Out')
    expect(page).to_not have_link('Log In')
    expect(page).to_not have_link('Register')
  end

  it 'can not log in with invalid credentials and redirects to login page' do
    visit '/login'

    fill_in :email, with: "abc123@gmail.com"
    fill_in :password, with: "abc123"
    click_button 'Log In'

    expect(current_path).to eq('/login')
    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  it 'redirects before creation if already logged in as default user' do
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/profile')
    expect(page).to have_content("You are already logged in.")
  end

  it 'redirects before creation if already logged in as merchant user' do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 1,
                        merchant: bike_shop)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("You are already logged in.")
  end

  it 'redirects before creation if already logged in as admin user' do
    user = User.create!(name: "Batman",
                        address: "Some dark cave 11",
                        city: "Arkham",
                        state: "CO",
                        zip: "81301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/admin')
    expect(page).to have_content("You are already logged in.")
  end
end
