class ShippedJob < ApplicationJob
  queue_as :default

  def perform(order)
    order.shipped() # this will be executed in the background
  end

end