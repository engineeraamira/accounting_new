require "application_system_test_case"

class DailyTransactionsTest < ApplicationSystemTestCase
  setup do
    @daily_transaction = daily_transactions(:one)
  end

  test "visiting the index" do
    visit daily_transactions_url
    assert_selector "h1", text: "Daily transactions"
  end

  test "should create daily transaction" do
    visit daily_transactions_url
    click_on "New daily transaction"

    fill_in "Created by", with: @daily_transaction.created_by
    fill_in "Currency", with: @daily_transaction.currency_id
    fill_in "Description", with: @daily_transaction.description
    fill_in "Posted by", with: @daily_transaction.posted_by
    fill_in "Posted date", with: @daily_transaction.posted_date
    fill_in "Status", with: @daily_transaction.status
    fill_in "Trans date", with: @daily_transaction.trans_date
    fill_in "Trans", with: @daily_transaction.trans_id
    click_on "Create Daily transaction"

    assert_text "Daily transaction was successfully created"
    click_on "Back"
  end

  test "should update Daily transaction" do
    visit daily_transaction_url(@daily_transaction)
    click_on "Edit this daily transaction", match: :first

    fill_in "Created by", with: @daily_transaction.created_by
    fill_in "Currency", with: @daily_transaction.currency_id
    fill_in "Description", with: @daily_transaction.description
    fill_in "Posted by", with: @daily_transaction.posted_by
    fill_in "Posted date", with: @daily_transaction.posted_date
    fill_in "Status", with: @daily_transaction.status
    fill_in "Trans date", with: @daily_transaction.trans_date
    fill_in "Trans", with: @daily_transaction.trans_id
    click_on "Update Daily transaction"

    assert_text "Daily transaction was successfully updated"
    click_on "Back"
  end

  test "should destroy Daily transaction" do
    visit daily_transaction_url(@daily_transaction)
    click_on "Destroy this daily transaction", match: :first

    assert_text "Daily transaction was successfully destroyed"
  end
end
