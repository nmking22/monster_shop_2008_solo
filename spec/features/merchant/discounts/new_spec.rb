require 'rails_helper'

describe 'As a merchant employee' do
  before :each do
    @batarang_emporium = Merchant.create(
      name: "Batman's Batarang Emporium",
      address: '123 Wayne Dr.',
      city: 'Gotham',
      state: 'IL',
      zip: 80210
    )
    @batman = User.create!(
      name: "Batman",
      address: "Some dark cave 11",
      city: "Arkham",
      state: "CO",
      zip: "81301",
      email: 'batmansemail@email.com',
      password: "password",
      role: 1,
      merchant: @batarang_emporium
    )
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@batman)
  end

  describe "When I click the 'Create Discount' button, and fill out the form" do
    it "I am redirected to the merchant discount index, where I see the discount" do
      visit '/'

      within '.topnav' do
        click_link('Create Discount')
      end

      expect(current_path).to eq('/merchant/discounts/new')

      fill_in :name, with: '20+'
      fill_in :percentage, with: 5
      fill_in :threshold, with: 20
      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts')

      expect(page).to have_content("Discount Name: 20+")
      expect(page).to have_content("Percent Off: 5.0%")
      expect(page).to have_content("Minimum Eligible Quantity: 20")
    end
  end

  describe 'When I fill out the discounts new form with a missing name field' do
    it 'I am redirected back to discounts new with a flash message indicating the problem' do
      visit '/merchant/discounts/new'

      fill_in :name, with: ""
      fill_in :percentage, with: 5
      fill_in :threshold, with: 20

      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('All fields must be filled in.')
    end
  end

  describe 'When I fill out the discounts new form with a missing percentage field' do
    it 'I am redirected back to discounts new with a flash message indicating the problem' do
      visit '/merchant/discounts/new'

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: ""
      fill_in :threshold, with: 20

      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('All fields must be filled in.')
    end
  end

  describe 'When I fill out the discounts new form with a missing threshold field' do
    it 'I am redirected back to discounts new with a flash message indicating the problem' do
      visit '/merchant/discounts/new'

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: 5
      fill_in :threshold, with: ""

      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('All fields must be filled in.')
    end
  end
  # invalid percentage - negative/above 100
  #negative items
end
