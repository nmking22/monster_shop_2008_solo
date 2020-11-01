require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end
  end

  describe 'As an admin' do
    before :each do
      @cat_shop = Merchant.create(
        name: "Nick's Cat Shop",
        address: '125 Catman St.',
        city: 'Denver',
        state: 'CO',
        zip: 80210
      )
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @user = User.create!(
        name: "Catman",
        address: "Some Straw Hole",
        city: "Treehouse",
        state: "CO",
        zip: "81301",
        email: 'catman4evr@email.com',
        password: "strawman",
        role: 2)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I can see a merchant's dashboard." do
      visit "/merchants"

      click_on "#{@cat_shop.name}"
      expect(current_path).to eq("/merchants/#{@cat_shop.id}")

      expect(page).to have_content(@cat_shop.address)
    end
    describe "When I visit '/admin/merchants' and click on a 'Disable' button" do
      it "I am returned to '/admin/merchants' with that merchant disabled and a flash message" do
        visit '/admin/merchants'

        within "#merchant-#{@cat_shop.id}" do
          click_button 'Disable Merchant'
        end

        expect(current_path).to eq('/merchants')

        within "#merchant-#{@cat_shop.id}" do
          expect(page).to have_content('Disabled')
        end

        expect(page).to have_content("#{@cat_shop.name} has been disabled.")
      end
      it 'Then all items for that merchant are deactivated' do
        pull_toy = @dog_shop.items.create(
          name: "Pull Toy",
          description: "Great pull toy!",
          price: 10,
          image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg",
          inventory: 32
        )
        dog_bone = @dog_shop.items.create(
          name: "Dog Bone",
          description: "They'll love it!",
          price: 21,
          image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg",
          inventory: 21
        )

        visit '/admin/merchants'

        within "#merchant-#{@dog_shop.id}" do
          click_button 'Disable Merchant'
        end

        expect(current_path).to eq('/merchants')
        
        @dog_shop.items.each do |item|
          expect(item.active?).to eq(false)
        end
      end
    end
  end
end
