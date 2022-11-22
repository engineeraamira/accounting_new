require "test_helper"

class DailyTransactionDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @daily_transaction_detail = daily_transaction_details(:one)
  end

  test "should get index" do
    get daily_transaction_details_url
    assert_response :success
  end

  test "should get new" do
    get new_daily_transaction_detail_url
    assert_response :success
  end

  test "should create daily_transaction_detail" do
    assert_difference("DailyTransactionDetail.count") do
      post daily_transaction_details_url, params: { daily_transaction_detail: { account_id: @daily_transaction_detail.account_id, cost_center_id: @daily_transaction_detail.cost_center_id, credit: @daily_transaction_detail.credit, currency_id: @daily_transaction_detail.currency_id, daily_transaction_id: @daily_transaction_detail.daily_transaction_id, debit: @daily_transaction_detail.debit, description: @daily_transaction_detail.description, item_date: @daily_transaction_detail.item_date } }
    end

    assert_redirected_to daily_transaction_detail_url(DailyTransactionDetail.last)
  end

  test "should show daily_transaction_detail" do
    get daily_transaction_detail_url(@daily_transaction_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_daily_transaction_detail_url(@daily_transaction_detail)
    assert_response :success
  end

  test "should update daily_transaction_detail" do
    patch daily_transaction_detail_url(@daily_transaction_detail), params: { daily_transaction_detail: { account_id: @daily_transaction_detail.account_id, cost_center_id: @daily_transaction_detail.cost_center_id, credit: @daily_transaction_detail.credit, currency_id: @daily_transaction_detail.currency_id, daily_transaction_id: @daily_transaction_detail.daily_transaction_id, debit: @daily_transaction_detail.debit, description: @daily_transaction_detail.description, item_date: @daily_transaction_detail.item_date } }
    assert_redirected_to daily_transaction_detail_url(@daily_transaction_detail)
  end

  test "should destroy daily_transaction_detail" do
    assert_difference("DailyTransactionDetail.count", -1) do
      delete daily_transaction_detail_url(@daily_transaction_detail)
    end

    assert_redirected_to daily_transaction_details_url
  end
end
