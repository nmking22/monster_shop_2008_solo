require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :threshold }
    it { should validate_presence_of :merchant_id }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :item_orders }
  end

  describe 'instance_methods' do
    it '#invalid_percentage?' do
      batarang_emporium = Merchant.create(
        name: "Batman's Batarang Emporium",
        address: '123 Wayne Dr.',
        city: 'Gotham',
        state: 'IL',
        zip: 80210
      )
      ten_rangs = Discount.new(
        name: 'Ten Rangs',
        percentage: -5,
        threshold: 10,
        merchant: @batarang_emporium
      )
      hero_discount = Discount.new(
        name: 'Hero Discount',
        percentage: 101,
        threshold: 20,
        merchant: @batarang_emporium
      )
      the_riddler = Discount.new(
        name: 'The Riddler',
        percentage: nil,
        threshold: 20,
        merchant: @batarang_emporium
      )

      expect(ten_rangs.invalid_percentage?).to eq(true)
      expect(hero_discount.invalid_percentage?).to eq(true)
      expect(the_riddler.invalid_percentage?).to eq(true)
    end

    it '#invalid_threshold?' do
      batarang_emporium = Merchant.create(
        name: "Batman's Batarang Emporium",
        address: '123 Wayne Dr.',
        city: 'Gotham',
        state: 'IL',
        zip: 80210
      )
      ten_rangs = Discount.new(
        name: 'Ten Rangs',
        percentage: 20,
        threshold: -10,
        merchant: @batarang_emporium
      )
      hero_discount = Discount.new(
        name: 'Hero Discount',
        percentage: 15,
        threshold: nil,
        merchant: @batarang_emporium
      )

      expect(ten_rangs.invalid_threshold?).to eq(true)
      expect(hero_discount.invalid_threshold?).to eq(true)
    end
  end
end
