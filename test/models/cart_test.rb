require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def setup
    @cart = Cart.create
    @book_one = products(:one)
    @book_two = products(:ruby)
  end

  test "add unique products" do
    @cart.add_product(@book_one).save!
    @cart.add_product(@book_two).save!
    assert_equal 2, @cart.line_items.size
  end

  test "add duplicate products" do
    @cart.add_product(@book_one).save!
    @cart.add_product(@book_one).save!
    assert_equal 1, @cart.line_items.size
  end

end
