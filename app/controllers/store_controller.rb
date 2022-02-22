class StoreController < ApplicationController

  # every user must be able to access the store, so we skip authorization
  skip_before_action :authorize

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
