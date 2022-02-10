class StoreController < ApplicationController
  def index
    @products = Product.order(:title) #get the products in alphabetical order
    @count = session_counter
  end

  private
    def session_counter
      #Add a counter in the session counting how many times the user has accessed the
      #index action of the store_controller 
      if session[:counter].nil?
        session[:counter] = 0
      end
      session[:counter] += 1
    end
end
