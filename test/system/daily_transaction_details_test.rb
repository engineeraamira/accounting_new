require "application_system_test_case"

class DailyTransactionDetailsTest < ApplicationSystemTestCase
  setup do
    @daily_transaction_detail = daily_transaction_details(:one)
  end

  test "visiting the index" do
    visit daily_transaction_details_url
    assert_selector "h1", text: "Daily transaction details"
  end

  test "should create daily transaction detail" do
    visit daily_transaction_details_url
    click_on "New daily transaction detail"

    fill_in "Account", with: @daily_transaction_detail.account_id
    fill_in "Cost center", with: @daily_transaction_detail.cost_center_id
    fill_in "Credit", with: @daily_transaction_detail.credit
    fill_in "Currency", with: @daily_transaction_detail.currency_id
    fill_in "Daily transaction", with: @daily_transaction_detail.daily_transaction_id
    fill_in "Debit", with: @daily_transaction_detail.debit
    fill_in "Description", with: @daily_transaction_detail.description
    fill_in "Item date", with: @daily_transaction_detail.item_date
    click_on "Create Daily transaction detail"

    assert_text "Daily transaction detail was successfully created"
    click_on "Back"
  end

  test "should update Daily transaction detail" do
    visit daily_transaction_detail_url(@daily_transaction_detail)
    click_on "Edit this daily transaction detail", match: :first

    fill_in "Account", with: @daily_transaction_detail.account_id
    fill_in "Cost center", with: @daily_transaction_detail.cost_center_id
    fill_in "Credit", with: @daily_transaction_detail.credit
    fill_in "Currency", with: @daily_transaction_detail.currency_id
    fill_in "Daily transaction", with: @daily_transaction_detail.daily_transaction_id
    fill_in "Debit", with: @daily_transaction_detail.debit
    fill_in "Description", with: @daily_transaction_detail.description
    fill_in "Item date", with: @daily_transaction_detail.item_date
    click_on "Update Daily transaction detail"

    assert_text "Daily transaction detail was successfully updated"
    click_on "Back"
  end

  test "should destroy Daily transaction detail" do
    visit daily_transaction_detail_url(@daily_transaction_detail)
    click_on "Destroy this daily transaction detail", match: :first

    assert_text "Daily transaction detail was successfully destroyed"
  end
end
