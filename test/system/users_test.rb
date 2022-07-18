require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    fill_in "City", with: @user.city_id
    fill_in "Country", with: @user.country_id
    check "Deleted" if @user.deleted
    fill_in "Email", with: @user.email
    fill_in "Failed attempts", with: @user.failed_attempts
    fill_in "Locale", with: @user.locale
    check "Locked" if @user.locked
    fill_in "Login attempts", with: @user.login_attempts
    fill_in "Phone", with: @user.phone
    check "Status" if @user.status
    fill_in "Unlock token", with: @user.unlock_token
    fill_in "User group", with: @user.user_group_id
    fill_in "User name", with: @user.user_name
    check "Verified" if @user.verified
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "City", with: @user.city_id
    fill_in "Country", with: @user.country_id
    check "Deleted" if @user.deleted
    fill_in "Email", with: @user.email
    fill_in "Failed attempts", with: @user.failed_attempts
    fill_in "Locale", with: @user.locale
    check "Locked" if @user.locked
    fill_in "Login attempts", with: @user.login_attempts
    fill_in "Phone", with: @user.phone
    check "Status" if @user.status
    fill_in "Unlock token", with: @user.unlock_token
    fill_in "User group", with: @user.user_group_id
    fill_in "User name", with: @user.user_name
    check "Verified" if @user.verified
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit user_url(@user)
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
