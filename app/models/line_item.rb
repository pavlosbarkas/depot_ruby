class LineItem < ApplicationRecord
  belongs_to :order, optional: true # optional: true gives the ability for line_items
                                    # to be created before added to an order.
                                    # if we didn't set optional:true we would get error
                                    # when a line_item was created without being part of an order
  belongs_to :product
  belongs_to :cart, optional: true

  def total_price
    product.price * quantity
  end

end
