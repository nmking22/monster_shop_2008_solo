
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
      click_link('Cart: 0')
      expect(current_path).to eq('/cart')

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "I can see a home page indicator on all pages" do
      visit '/'

      within 'nav' do
        expect(page).to have_content("Home")
      end
      click_link('Home')
      expect(current_path).to eq('/')

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Home")
      end
    end

    it "I can see a login page indicator on all pages" do
      visit '/'

      within 'nav' do
        expect(page).to have_content("Log In")
      end
      # click_link('Log In')
      # expect(current_path).to eq('/sessions/new')

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Log In")
      end
    end

    it "I can see a register page indicator on all pages" do
      visit '/'

      within 'nav' do
        expect(page).to have_content("Register")
      end
      click_link('Register')
      expect(current_path).to eq('/register')

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Register")
      end
    end

    it "I can't visit /admin, /merchant, or /profile" do
      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe 'As a default user' do
    it 'I can see all links plus profile and logout but no login or register' do
      user_1 = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password",
                            role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      visit '/'

      within 'nav' do
        expect(page).to have_content("Home")
        expect(page).to have_content("Cart: 0")
        expect(page).to have_content("All Merchants")
        expect(page).to have_content("All Items")
        expect(page).to have_content("Profile")
        expect(page).to have_content("Log Out")
        expect(page).to have_content('Logged in as Batman')
        expect(page).not_to have_content("Log In")
        expect(page).to have_no_content("Register")
        expect(page).to have_no_content("Merchant Dashboard")
      end
    end
  end

  describe 'As a merchant' do
    it 'I can see all links plus merchant' do
      user_1 = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password",
                            role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      visit '/'

      within 'nav' do
        expect(page).to have_content("Home")
        expect(page).to have_content("Cart: 0")
        expect(page).to have_content("All Merchants")
        expect(page).to have_content("All Items")
        expect(page).to have_content("Profile")
        expect(page).to have_content("Log Out")
        expect(page).not_to have_content("Log In")
        expect(page).to have_no_content("Register")
        expect(page).to have_content('Logged in as Batman')
        expect(page).to have_content('Merchant Dashboard')
      end
    end
  end

  describe 'As an admin' do
    it 'I can see all links plus admin dash, all users, no cart' do
      user_1 = User.create!(name: "Superman",
                            address: "11 Smallville Ln",
                            city: "Smallville",
                            state: "NE",
                            zip: "56423",
                            email: 'ihatekryptonite@email.com',
                            password: "password",
                            role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      visit '/'

      within 'nav' do
        expect(page).to have_content('Home')
        expect(page).to have_content('All Merchants')
        expect(page).to have_content('All Items')
        expect(page).to have_content('Profile')
        expect(page).to have_content('Log Out')
        expect(page).to have_content('Logged in as Superman')
        expect(page).to have_content('Admin Dashboard')
        expect(page).to have_content('All Users')
        expect(page).not_to have_content('Log In')
        expect(page).to have_no_content('Register')
        expect(page).to have_no_content('Cart: 0')
      end
    end
  end
end
