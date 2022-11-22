require "test_helper"

class DailyTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @daily_transaction = daily_transactions(:one)
  end

  test "should get index" do
    get daily_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_daily_transaction_url
    assert_response :success
  end

  test "should create daily_transaction" do
    assert_difference("DailyTransaction.count") do
      post daily_transactions_url, params: { daily_transaction: { created_by: @daily_transaction.created_by, currency_id: @daily_transaction.currency_id, description: @daily_transaction.description, posted_by: @daily_transaction.posted_by, posted_date: @daily_transaction.posted_date, status: @daily_transaction.status, trans_date: @daily_transaction.trans_date, trans_id: @daily_transaction.trans_id } }
    end

    assert_redirected_to daily_transaction_url(DailyTransaction.last)
  end

  test "should show daily_transaction" do
    get daily_transaction_url(@daily_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_daily_transaction_url(@daily_transaction)
    assert_response :success
  end

  test "should update daily_transaction" do
    patch daily_transaction_url(@daily_transaction), params: { daily_transaction: { created_by: @daily_transaction.created_by, currency_id: @daily_transaction.currency_id, description: @daily_transaction.description, posted_by: @daily_transaction.posted_by, posted_date: @daily_transaction.posted_date, status: @daily_transaction.status, trans_date: @daily_transaction.trans_date, trans_id: @daily_transaction.trans_id } }
    assert_redirected_to daily_transaction_url(@daily_transaction)
  end

  test "should destroy daily_transaction" do
    assert_difference("DailyTransaction.count", -1) do
      delete daily_transaction_url(@daily_transaction)
    end

    assert_redirected_to daily_transactions_url
  end
end
