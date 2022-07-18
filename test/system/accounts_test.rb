require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one)
  end

  test "visiting the index" do
    visit accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "should create account" do
    visit accounts_url
    click_on "New account"

    fill_in "Account nature", with: @account.account_nature
    fill_in "Account number", with: @account.account_number
    fill_in "Account type", with: @account.account_type
    fill_in "Balance", with: @account.balance
    fill_in "Credit", with: @account.credit
    fill_in "Debit", with: @account.debit
    fill_in "Final account", with: @account.final_account
    fill_in "Name ar", with: @account.name_ar
    fill_in "Name en", with: @account.name_en
    fill_in "Notes", with: @account.notes
    fill_in "Parent account", with: @account.parent_account
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "should update Account" do
    visit account_url(@account)
    click_on "Edit this account", match: :first

    fill_in "Account nature", with: @account.account_nature
    fill_in "Account number", with: @account.account_number
    fill_in "Account type", with: @account.account_type
    fill_in "Balance", with: @account.balance
    fill_in "Credit", with: @account.credit
    fill_in "Debit", with: @account.debit
    fill_in "Final account", with: @account.final_account
    fill_in "Name ar", with: @account.name_ar
    fill_in "Name en", with: @account.name_en
    fill_in "Notes", with: @account.notes
    fill_in "Parent account", with: @account.parent_account
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "should destroy Account" do
    visit account_url(@account)
    click_on "Destroy this account", match: :first

    assert_text "Account was successfully destroyed"
  end
end
