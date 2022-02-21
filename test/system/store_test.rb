require "application_system_test_case"

class StoreTest < ApplicationSystemTestCase

  test "add_to_cart_button_shows_cart" do
    visit store_index_url
    assert_selector('#cart', visible: false)
    click_on 'Add to Cart', match: :first
    assert_selector('#cart', visible: true)
  end

  test "empty_cart_button_hides_cart" do
    visit store_index_url
    assert_selector('#cart', visible: false)
    click_on 'Add to Cart', match: :first
    assert_selector('#cart', visible: true)
    page.accept_confirm { click_on 'Empty Cart' }
    assert_selector('#cart', visible: false)
  end

  test 'highlighting_feature' do
    visit store_index_url
    assert_no_selector '.line-item-highlight'
    click_on 'Add to Cart', match: :first
    assert_selector '.line-item-highlight'
  end

end