require 'rails_helper'

RSpec.describe 'admin merchant' do
  describe 'When I visit merchant index page' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, enabled?: false)

      @user = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password",
                            role: 2
                            )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    end
    it 'can see all merchants and a disable or enable button' do

      visit '/admin/merchants'
      within "#merchant-#{@mike.id}" do
        expect(page).to have_content(@mike.name)
        expect(page).to have_content(@mike.city)
        expect(page).to have_content(@mike.state)
        expect(page).to have_content("Enabled")
        click_on "Disable"
      end
      within "#merchant-#{@mike.id}" do
        expect(page).to have_content("Disabled")
      end
      within "#merchant-#{@meg.id}" do
        expect(page).to have_content("Disabled")
        click_on "Enable"
      end
      within "#merchant-#{@meg.id}" do
        expect(page).to have_content("Enabled")
      end
    end
  end


end
