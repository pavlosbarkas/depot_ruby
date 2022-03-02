require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_button "New User"

    fill_in "Name", with: @user.name
    fill_in "Password", with: 'secret'
    fill_in "Password confirmation", with: 'secret'
    click_button "Create User"

    assert_text "User was successfully created"
    click_button "Back"
  end

  test "updating a User" do
    visit users_url
    click_button "Edit", match: :first
    fill_in "Name", with: @user.name
    fill_in "Current password", with: @user.password
    fill_in "New password", with: 'secret'
    fill_in "Confirm new password", with: 'secret'
    click_button "Update User"

    assert_text "User #{@user.name} was successfully updated"
    click_button "Back"
  end

  test "destroying a User" do
    visit users_url
    page.accept_confirm do
      click_button "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end
end
