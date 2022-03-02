require 'application_system_test_case'

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper # to use perform_enqueued_jobs()

  setup do
    @order = orders(:one)
  end

  test 'visiting the index' do
    visit orders_url
    assert_selector 'h1', text: 'Orders'
  end

  test 'destroying a Order' do
    visit orders_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Order was successfully destroyed'
  end

  test 'check_routing_number' do
    # emptying these will help us with the testing later on in order to check the order submitted
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_button 'Add to Cart', match: :first
    click_button 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_routing_number'
    select 'Check', from: 'Pay type'
    assert_selector '#order_routing_number'

    fill_in 'Routing #', with: '123456'
    fill_in 'Account #', with: '987654'

    # if we click_button without perform_enqueued_jobs the test will fail
    # because it will move on and the email won't have been sent
    perform_enqueued_jobs do
      click_button 'Place Order'
    end

    # get the order we just created
    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    # check the properties of the order
    assert_equal 'Dave Thomas', order.name
    assert_equal '123 Main Street', order.address
    assert_equal 'dave@example.com', order.email
    assert_equal 'Check', order.pay_type
    assert_equal 1, order.line_items.size

    # check if the email was sent
    # due to config in development mode the mail goes to ActionMailer::Base.deliveries array
    # and it isn't sent to some real address
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dave@example.com'], mail.to
    assert_equal 'Pavlos Barkas <depot@info.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject

  end

  test 'check_credit_card_number' do

    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_credit_card_number'
    select 'Credit Card', from: 'Pay type'
    assert_selector '#order_credit_card_number'

  end

  test 'check_po_number' do

    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_po_number'
    select 'Purchase Order', from: 'Pay type'
    assert_selector '#order_po_number'

  end

end
