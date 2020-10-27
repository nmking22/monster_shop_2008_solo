require 'rails_helper'
RSpec.describe 'User' do
  it "as a visitor I can register" do
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
  end
end
