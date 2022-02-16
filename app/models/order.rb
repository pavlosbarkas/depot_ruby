class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  # dependent: :destroy specifies that when an order is destroyed
  # all its line items will also be destroyed

=begin
i turned this into a string in the orders table
  enum pay_type: {
    "Check"          => 0,
    "Credit card"    => 1,
    "Purchase order" => 2
  }
validates :pay_type, inclusion: pay_types.keys
=end

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: ['Check', 'Credit Card', 'Purchase Order']

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

end
