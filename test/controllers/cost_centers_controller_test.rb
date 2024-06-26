require "test_helper"

class CostCentersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cost_center = cost_centers(:one)
  end

  test "should get index" do
    get cost_centers_url
    assert_response :success
  end

  test "should get new" do
    get new_cost_center_url
    assert_response :success
  end

  test "should create cost_center" do
    assert_difference("CostCenter.count") do
      post cost_centers_url, params: { cost_center: { created_by: @cost_center.created_by, deleted: @cost_center.deleted, deleted_by: @cost_center.deleted_by, deleted_date: @cost_center.deleted_date, name_ar: @cost_center.name_ar, name_en: @cost_center.name_en, parent: @cost_center.parent, status: @cost_center.status } }
    end

    assert_redirected_to cost_center_url(CostCenter.last)
  end

  test "should show cost_center" do
    get cost_center_url(@cost_center)
    assert_response :success
  end

  test "should get edit" do
    get edit_cost_center_url(@cost_center)
    assert_response :success
  end

  test "should update cost_center" do
    patch cost_center_url(@cost_center), params: { cost_center: { created_by: @cost_center.created_by, deleted: @cost_center.deleted, deleted_by: @cost_center.deleted_by, deleted_date: @cost_center.deleted_date, name_ar: @cost_center.name_ar, name_en: @cost_center.name_en, parent: @cost_center.parent, status: @cost_center.status } }
    assert_redirected_to cost_center_url(@cost_center)
  end

  test "should destroy cost_center" do
    assert_difference("CostCenter.count", -1) do
      delete cost_center_url(@cost_center)
    end

    assert_redirected_to cost_centers_url
  end
end
