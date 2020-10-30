require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "I can see a list of all of active items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "I can click image to go to item show page" do
      visit '/items'

      within "#item-#{@tire.id}" do
        find(".image-link").click
      end
      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "I see item statistics" do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      #dog_shop items
      pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
      lizard_head = @brian.items.create(name: "Lizard Head", description: "Yummy", price: 500, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
      barbie = @brian.items.create(name: "Barbie", description: "Very Pink", price: 1000, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
      order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      order.item_orders.create(item: tire, price: tire.price, quantity: 2)
      order.item_orders.create(item: pull_toy, price: pull_toy.price, quantity: 5)
      order.item_orders.create(item: dog_bone, price: dog_bone.price, quantity: 7)
      order.item_orders.create(item: lizard_head, price: lizard_head.price, quantity: 8)
      order.item_orders.create(item: barbie, price: barbie.price, quantity: 9)
      order.item_orders.create(item: chain, price: chain.price, quantity: 6)

      visit '/items'

      within ".item-statistics" do
        expect(page).to have_content("Item Statistics")
        expect(page).to have_content("Top Five Bought")
        within ".top-five" do
          expect(page.all('li')[0].text).to eq("Barbie: Quantity Bought: 9")
          expect(page.all('li')[1].text).to eq("Lizard Head: Quantity Bought: 8")
          expect(page.all('li')[2].text).to eq("Dog Bone: Quantity Bought: 7")
          expect(page.all('li')[3].text).to eq("Chain: Quantity Bought: 6")
          expect(page.all('li')[4].text).to eq("Pull Toy: Quantity Bought: 5")
        end

        within ".bottom-five" do
          expect(page.all('li')[0].text).to eq("Gatorskins: Quantity Bought: 2")
          expect(page.all('li')[1].text).to eq("Pull Toy: Quantity Bought: 5")
          expect(page.all('li')[2].text).to eq("Chain: Quantity Bought: 6")
          expect(page.all('li')[3].text).to eq("Dog Bone: Quantity Bought: 7")
          expect(page.all('li')[4].text).to eq("Lizard Head: Quantity Bought: 8")
        end

      end
    end

  end
end
