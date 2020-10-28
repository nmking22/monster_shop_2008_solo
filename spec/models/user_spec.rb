require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
  end

  describe 'instance methods' do
    it '#duplicate_email?' do
      user_1 = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password")
      user_2 = User.new(name: "Sam",
                            address: "Some dark cave 14",
                            city: "denver",
                            state: "CO",
                            zip: "855301",
                            email: 'batmansemail@email.com',
                            password: "password")

      expect(user_2.duplicate_email?).to eq(true)
    end
   end
  end
