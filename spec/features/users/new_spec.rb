require 'rails_helper'

RSpec.describe 'User' do
  it "as a visitor I can register and see info on my show page" do
    visit '/'
    click_on 'Register'
    expect(current_path).to eq("/register")

      fill_in :name, with: "Ricky Bobby"
      fill_in :address, with: "Victory Lane 1"
      fill_in :city, with: "Dallas"
      fill_in :state,  with: "Texas"
      fill_in :zip, with: "11111"
      fill_in :email, with: "shakenbake@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Create Account"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now registered and logged in!")
      expect(page).to have_content("Ricky Bobby")
      expect(page).to have_content("Victory Lane 1")
      expect(page).to have_content("Dallas")
      expect(page).to have_content("Texas")
      expect(page).to have_content("11111")
      expect(page).to have_content("shakenbake@gmail.com")
  end

  it 'shows a flash message if there are missing details' do
    visit '/'
    click_on 'Register'
    expect(current_path).to eq("/register")
      fill_in :name, with: ""
      fill_in :address, with: "Victory Lane 1"
      fill_in :city, with: "Dallas"
      fill_in :state,  with: "Texas"
      fill_in :zip, with: "11111"
      fill_in :email, with: "shakenbake@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
    click_on "Create Account"
    expect(current_path).to eq("/register")
    expect(page).to have_content("You are missing required fields.")
  end

  it 'shows a flash message if email exists and fields are populated' do
    user_1 = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password")
    visit '/'
    click_on 'Register'
    expect(current_path).to eq("/register")
      fill_in :name, with: "Ricky Bobby"
      fill_in :address, with: "Victory Lane 1"
      fill_in :city, with: "Dallas"
      fill_in :state,  with: "Texas"
      fill_in :zip, with: "11111"
      fill_in :email, with: 'batmansemail@email.com'
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
    click_on "Create Account"

      expect(current_path).to eq("/register")
      expect(page).to have_field(:name, with: "Ricky Bobby")
      expect(page).to have_field(:address, with: "Victory Lane 1")
      expect(page).to have_field(:city, with: "Dallas")
      expect(page).to have_field(:state, with: "Texas")
      expect(page).to have_field(:zip, with: "11111")

    expect(page).to have_content("Email already exists, please choose a different email.")
  end

  it 'shows a flash message if all fields except password_confirmation are filled correctly' do
    visit '/register'

    fill_in :name, with: "Ricky Bobby"
    fill_in :address, with: "Victory Lane 1"
    fill_in :city, with: "Dallas"
    fill_in :state,  with: "Texas"
    fill_in :zip, with: "11111"
    fill_in :email, with: "shakenbake@gmail.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password123"

    click_on "Create Account"

    expect(current_path).to eq("/register")
    expect(page).to have_content("Password and Password Confirmation fields did not match.")

  end
end
