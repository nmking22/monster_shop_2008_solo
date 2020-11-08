require 'rails_helper'

describe "As a merchant employee, when I click 'All Discounts'" do
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
    @fifty_rangs = Discount.create!(
      name: 'Fifty Rangs',
      percentage: 15,
      threshold: 50,
      merchant: @batarang_emporium
    )
  end

  it 'I am redirected to my discount index page where I see all associated discounts' do
    visit '/'

    click_link('My Discounts')

    expect(current_path).to eq('/merchant/discounts')

    within "#discount-#{@ten_rangs.id}" do
      expect(page).to have_content("Name: #{@ten_rangs.name}")
      expect(page).to have_content("Percent Off: #{@ten_rangs.percentage}%")
      expect(page).to have_content("Minimum Eligible Quantity: #{@ten_rangs.threshold}")
    end

    within "#discount-#{@fifty_rangs.id}" do
      expect(page).to have_content("Discount Name: #{@fifty_rangs.name}")
      expect(page).to have_content("Percent Off: #{@fifty_rangs.percentage}%")
      expect(page).to have_content("Minimum Eligible Quantity: #{@fifty_rangs.threshold}")
    end
  end

  it 'I do not see any discounts of other merchants' do
    propane = Merchant.create(
      name: "Strickland Propane",
      address: '123 Hill Pl.',
      city: 'Arlen',
      state: 'TX',
      zip: 99199
    )
    @five_plus = Discount.create!(
      name: 'Five or More',
      percentage: 5,
      threshold: 5,
      merchant: propane
    )
    @ten_plus = Discount.create!(
      name: 'Ten or More',
      percentage: 15,
      threshold: 10,
      merchant: propane
    )

    visit '/merchant/discounts'

    expect(page).to_not have_content(@five_plus.name)
    expect(page).to_not have_content(@ten_plus.name)
  end
end