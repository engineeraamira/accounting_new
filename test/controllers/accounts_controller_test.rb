require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference("Account.count") do
      post accounts_url, params: { account: { account_nature: @account.account_nature, account_number: @account.account_number, account_type: @account.account_type, balance: @account.balance, credit: @account.credit, debit: @account.debit, final_account: @account.final_account, name_ar: @account.name_ar, name_en: @account.name_en, notes: @account.notes, parent_account: @account.parent_account } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should show account" do
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), params: { account: { account_nature: @account.account_nature, account_number: @account.account_number, account_type: @account.account_type, balance: @account.balance, credit: @account.credit, debit: @account.debit, final_account: @account.final_account, name_ar: @account.name_ar, name_en: @account.name_en, notes: @account.notes, parent_account: @account.parent_account } }
    assert_redirected_to account_url(@account)
  end

  test "should destroy account" do
    assert_difference("Account.count", -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end
end
