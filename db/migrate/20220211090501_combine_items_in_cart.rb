class CombineItemsInCart < ActiveRecord::Migration[6.0]
  # we made this so that the previous carts can be in the right format too
  # and all the future carts are as we want too
  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single item
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  # in every migration we define a down method which is what happens if we rollback the migration
  # in this case we return to showing the cart with each product added in a separate line
  # without counting quantities
  def down
    # split items with quantity>1 into multiple lines
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
        )
      end
      # remove original item
      line_item.destroy
    end
  end

end
