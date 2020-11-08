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
end
