require 'rails_helper'

describe 'As a merchant employee, when I visit a discount show page' do
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

  it "The link to 'Edit Discount' takes me to that discount's edit view" do
    visit "/merchant/discounts/#{@ten_rangs.id}"

    click_link "Edit Discount"

    expect(current_path).to eq("/merchant/discounts/#{@ten_rangs.id}/edit")
  end
end
