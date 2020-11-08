class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.float :percentage
      t.integer :threshold
    end
  end
end
