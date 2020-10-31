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

  describe "relationships" do
    it { should have_many :orders }
  end

  describe "roles" do
    it 'can be created with a default role' do
      user_1 = User.new(name: "Sam",
                        address: "Some dark cave 14",
                        city: "denver",
                        state: "CO",
                        zip: "855301",
                        email: 'batmansemail@email.com',
                        password: "password",
                        role: 0)
      expect(user_1.role).to eq('default_user')
      expect(user_1.default_user?).to be_truthy
    end

    it 'can be created with a merchant role' do
      user_1 = User.new(name: "Robin",
                        address: "Batcave",
                        city: "Gotham",
                        state: "FL",
                        zip: "12345",
                        email: 'robin911@email.com',
                        password: "password",
                        role: 1)
      expect(user_1.role).to eq('merchant_user')
      expect(user_1.merchant_user?).to be_truthy
    end

    it 'can be created with an admin role' do
      user_1 = User.create!(name: "Superman",
                            address: "11 Smallville Ln",
                            city: "Smallville",
                            state: "NE",
                            zip: "56423",
                            email: 'ihatekryptonite@email.com',
                            password: "password",
                            role: 2)
      expect(user_1.role).to eq('admin_user')
      expect(user_1.admin_user?).to be_truthy
    end
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
