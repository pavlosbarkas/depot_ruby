class AddOrderToLineItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :line_items, :order, null: true, foreign_key: true#add null true so that we can have null cart_id
    change_column :line_items, :cart_id, :integer, null: true #change the cart_id column. now able to be null
  end
end
