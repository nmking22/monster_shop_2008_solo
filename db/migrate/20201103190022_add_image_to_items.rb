class AddImageToItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:items, :image, 'https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png')
  end
end
