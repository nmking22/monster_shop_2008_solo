require 'rails_helper'

describe 'As a Merchant Employee, when I visit a discount edit page' do
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

    @ten_rangs = Discount.create!(
      name: 'Ten Rangs',
      percentage: 5,
      threshold: 10,
      merchant: @batarang_emporium
    )
  end
  describe 'And I fill out the form and submit' do
    it "I am redirected to that discount's show page and can see the changes" do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Eleven Rangs"
      fill_in :percentage, with: 6.5
      fill_in :threshold, with: 11
      click_button "Update Discount"

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}")

      expect(page).to have_content("Eleven Rangs")
      expect(page).to have_content("Percent Off: 6.5%")
      expect(page).to have_content("Minimum Eligible Quantity: 11")
    end
  end

  it 'The form fields are pre-filled with current attributes' do
    visit "/merchant/discounts/#{@ten_rangs.id}"

    expect(page).to have_content(@ten_rangs.name)
    expect(page).to have_content(@ten_rangs.percentage)
    expect(page).to have_content(@ten_rangs.threshold)
  end

  describe 'When I fill out the discounts edit form with a missing name field' do
    it 'I am redirected back to discounts edit with a flash message indicating the problem' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: ""
      fill_in :percentage, with: 5
      fill_in :threshold, with: 20

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('All fields must be filled in.')
    end
  end

  describe 'When I fill out the discounts edit form with a missing percentage field' do
    it 'I am redirected back to discounts edit with a flash message indicating the problem' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: ""
      fill_in :threshold, with: 20

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('Discount percentage must be filled with an integer or float between 0 and 100.')
    end
  end

  describe 'When I fill out the discounts edit form with a missing threshold field' do
    it 'I am redirected back to discounts edit with a flash message indicating the problem' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: 5.5
      fill_in :threshold, with: ""

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('Minimum Items for Activation must be filled with an integer zero or greater.')
    end
  end

  describe "When I fill in the discounts edit form with a negative percentage" do
    it 'I am redirected to discounts edit with an error indicating an invalid percentage' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: -5
      fill_in :threshold, with: 20

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('Discount percentage must be filled with an integer or float between 0 and 100.')
    end
  end

  describe "When I fill in the discounts edit form with a percentage over 100" do
    it 'I am redirected to discounts edit with an error indicating an invalid percentage' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: 100.1
      fill_in :threshold, with: 20

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('Discount percentage must be filled with an integer or float between 0 and 100.')
    end
  end

  describe "When I fill in the discounts edit form with a negative threshold input" do
    it 'I am redirected to discounts edit with an invalid threshold message' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: 20
      fill_in :threshold, with: -23

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
      expect(page).to have_content('Minimum Items for Activation must be filled with an integer zero or greater.')
    end
  end

  describe "When I fill in the discounts edit form with a float threshold input" do
    it 'I am redirected to that discounts show with threshold rounded down' do
      visit "/merchant/discounts/#{@ten_rangs.id}/edit"

      fill_in :name, with: "Nick!"
      fill_in :percentage, with: 20
      fill_in :threshold, with: 20.92

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}")

      expect(page).to have_content('Minimum Eligible Quantity: 20')
    end
  end
end
