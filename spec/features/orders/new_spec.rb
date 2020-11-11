require 'rails_helper'

RSpec.describe "New Order Page" do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
  end

  describe "When I check out from my cart" do
    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total: $142")
    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_field(:name)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Order")
    end
  end

# Discounted Items
  describe "When I visit a new order page with discounted items" do
    before :each do
      @mike.discounts.create!(
        name: "Ten Percent Off",
        percentage: 10,
        threshold: 2
      )
      @mike.discounts.create!(
        name: "Twenty Five Percent Off",
        percentage: 25,
        threshold: 3
      )
      @meg.discounts.create!(
        name: "Fire Sale",
        percentage: 50,
        threshold: 1
      )
      @meg.discounts.create!(
        name: "Fuego Sale",
        percentage: 75,
        threshold: 2
      )
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    it "All prices are updated with eligible discounts" do
      visit '/orders/new'

      within "#order-item-#{@tire.id}" do
        within '#price' do
          expect(page).to have_content("$25.00")
        end
      end

      within "#order-item-#{@paper.id}" do
        within '#price' do
          expect(page).to have_content("$15.00")
        end
      end

      within "#order-item-#{@pencil.id}" do
        within '#price' do
          expect(page).to have_content("$1.80")
        end
      end
    end

    it "All subtotals are updated with best eligible discount" do
      visit '/orders/new'

      within "#order-item-#{@tire.id}" do
        within '#subtotal' do
          expect(page).to have_content("$50.00")
        end
      end

      within "#order-item-#{@paper.id}" do
        within '#subtotal' do
          expect(page).to have_content("$45.00")
        end
      end

      within "#order-item-#{@pencil.id}" do
        within '#subtotal' do
          expect(page).to have_content("$3.60")
        end
      end
    end

    it "The discount name and amount are indicated" do
      visit '/orders/new'

      within "#order-item-#{@paper.id}" do
        within '#discount-info' do
          expect(page).to have_content("Twenty Five Percent Off applied!")
          expect(page).to have_content("25.0% off this product!")
        end
      end

      within "#order-item-#{@tire.id}" do
        within '#discount-info' do
          expect(page).to have_content("Fuego Sale applied!")
          expect(page).to have_content("75.0% off this product!")
        end
      end

      within "#order-item-#{@pencil.id}" do
        within '#discount-info' do
          expect(page).to have_content("Ten Percent Off applied!")
          expect(page).to have_content("10.0% off this product!")
        end
      end
    end

    it "'No Eligible Discount' is indicated for non-discounted items" do
      tower = @mike.items.create(name: "Castle", description: "epic and glorious", price: 22, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSKUZDbGra_dHzHxPzD-_8Sk3JjB6u9EpaXqQ&usqp=CAU", inventory: 4)

      visit "/items/#{tower.id}"
      click_on "Add To Cart"

      visit '/orders/new'

      within "#order-item-#{tower.id}" do
        within '#discount-info' do
          expect(page).to have_content("No Eligible Discount")
        end
      end
    end

    it "The total is updated with all discounted prices" do
      visit '/orders/new'

      within '#total' do
        expect(page).to have_content("$98.60")
      end
    end

    describe "When I submit the discounted order" do
      before :each do
        visit '/orders/new'

        fill_in :name, with: "Batman"
        fill_in :address, with: "Some dark cave 11"
        fill_in :city, with: "Arkham"
        fill_in :state, with: "CO"
        fill_in :zip, with: "81301"

        click_button 'Create Order'
      end

      it "I am redirected to order index where the grand total is updated with discounts applied" do
        expect(current_path).to eq('/profile/orders')

        expect(page).to have_content('Order Grandtotal: $98.60')
      end
    end
  end
end
