
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
  end
end
