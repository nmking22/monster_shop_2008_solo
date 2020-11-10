require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(
          name: "Mike's Print Shop",
          address: '123 Paper Rd.',
          city: 'Denver',
          state: 'CO',
          zip: 80203)
        @meg = Merchant.create(
          name: "Meg's Bike Shop",
          address: '123 Bike Rd.',
          city: 'Denver',
          state: 'CO',
          zip: 80203)
        @tire = @meg.items.create(
          name: "Gatorskins",
          description: "They'll never pop!",
          price: 100,
          image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
          inventory: 12)
        @paper = @mike.items.create(
          name: "Lined Paper",
          description: "Great for writing on!",
          price: 20,
          image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
          inventory: 25)
        @pencil = @mike.items.create(
          name: "Yellow Pencil",
          description: "You can write on paper with it!",
          price: 2,
          image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg",
          inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      xit 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      xit 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end
    end
  end
  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      xit "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      xit "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end

    end
  end

  describe "When an item in my cart exceeds a discount threshold" do
    before :each do
      @mike = Merchant.create(
        name: "Mike's Print Shop",
        address: '123 Paper Rd.',
        city: 'Denver',
        state: 'CO',
        zip: 80203)
      @two_for_two = Discount.create!(
        name: 'Two for Two',
        percentage: 2,
        threshold: 2,
        merchant: @mike)
      @three_for_three = Discount.create!(
        name: 'Three for Three',
        percentage: 3,
        threshold: 3,
        merchant: @mike)
      @four_for_four = Discount.create!(
        name: 'Four for Four',
        percentage: 4,
        threshold: 4,
        merchant: @mike)
      @meg = Merchant.create(
        name: "Meg's Bike Shop",
        address: '123 Bike Rd.',
        city: 'Denver',
        state: 'CO',
        zip: 80203)
      @tire = @meg.items.create(
        name: "Gatorskins",
        description: "They'll never pop!",
        price: 100,
        image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
        inventory: 12)
      @paper = @mike.items.create(
        name: "Lined Paper",
        description: "Great for writing on!",
        price: 50,
        image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
        inventory: 25)
      @pencil = @mike.items.create(
        name: "Yellow Pencil",
        description: "You can write on paper with it!",
        price: 100,
        image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg",
        inventory: 100)
      @batman = User.create!(
        name: "Batman",
        address: "Some dark cave 11",
        city: "Arkham",
        state: "CO",
        zip: "81301",
        email: 'batmansemail@email.com',
        password: "password",
        role: 0
      )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@batman)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    it "The item's discounted price is displayed with a message indicating the discount" do
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      within "#cart-item-#{@paper.id}" do
        within '#price' do
          expect(page).to have_content("$49.00")
          expect(page).to have_content("#{@two_for_two.name} discount applied!\n#{@two_for_two.percentage}% savings!")
        end
      end
    end

    it "Other items in the cart are not discounted" do
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      within "#cart-item-#{@tire.id}" do
        within '#price' do
          expect(page).to have_content("$100.00")
        end
      end

      within "#cart-item-#{@pencil.id}" do
        within '#price' do
          expect(page).to have_content("$100.00")
        end
      end
    end

    it "If the discount threshold is only met across more than one item, no discount is applied" do
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        within '#price' do
          expect(page).to have_content("$50.00")
        end
      end

      within "#cart-item-#{@tire.id}" do
        within '#price' do
          expect(page).to have_content("$100.00")
        end
      end

      within "#cart-item-#{@pencil.id}" do
        within '#price' do
          expect(page).to have_content("$100.00")
        end
      end
    end

    it "The item's price is discounted with the largest eligible discount applied" do
      visit '/cart'

      2.times do
        within "#cart-item-#{@paper.id}" do
          click_button "+"
        end
      end

      within "#cart-item-#{@paper.id}" do
        within '#price' do
          expect(page).to have_content("$48.50")
          expect(page).to have_content("#{@three_for_three.name} discount applied!\n#{@three_for_three.percentage}% savings!")
        end
      end

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      within "#cart-item-#{@paper.id}" do
        within '#price' do
          expect(page).to have_content("$48.00")
          expect(page).to have_content("#{@four_for_four.name} discount applied!\n#{@four_for_four.percentage}% savings!")
        end
      end
    end

    it "The subtotal is modified with all discounts accounted for" do
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        within '#subtotal' do
          expect(page).to have_content("$50.00")
        end
      end

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      within "#cart-item-#{@paper.id}" do
        within '#subtotal' do
          expect(page).to have_content("$98.00")
        end
      end

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      within "#cart-item-#{@paper.id}" do
        within '#subtotal' do
          expect(page).to have_content("$145.50")
        end
      end
    end

    it "The total is modified with all discounts accounted for" do
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end

      2.times do
        within "#cart-item-#{@pencil.id}" do
          click_button "+"
        end
      end

      3.times do
        within "#cart-item-#{@tire.id}" do
          click_button "+"
        end
      end

      expect(page).to have_content("Total: $789.00")
    end
  end
end
