class StoreController < ApplicationController
  def index
    @products = Product.order(:title) #get the products in alphabetical order
  end
end
