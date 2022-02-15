class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title) #get the products in alphabetical order

    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end

  end
end
