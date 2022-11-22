require "application_system_test_case"

class CostCentersTest < ApplicationSystemTestCase
  setup do
    @cost_center = cost_centers(:one)
  end

  test "visiting the index" do
    visit cost_centers_url
    assert_selector "h1", text: "Cost centers"
  end

  test "should create cost center" do
    visit cost_centers_url
    click_on "New cost center"

    fill_in "Created by", with: @cost_center.created_by
    check "Deleted" if @cost_center.deleted
    fill_in "Deleted by", with: @cost_center.deleted_by
    fill_in "Deleted date", with: @cost_center.deleted_date
    fill_in "Name ar", with: @cost_center.name_ar
    fill_in "Name en", with: @cost_center.name_en
    fill_in "Parent", with: @cost_center.parent
    check "Status" if @cost_center.status
    click_on "Create Cost center"

    assert_text "Cost center was successfully created"
    click_on "Back"
  end

  test "should update Cost center" do
    visit cost_center_url(@cost_center)
    click_on "Edit this cost center", match: :first

    fill_in "Created by", with: @cost_center.created_by
    check "Deleted" if @cost_center.deleted
    fill_in "Deleted by", with: @cost_center.deleted_by
    fill_in "Deleted date", with: @cost_center.deleted_date
    fill_in "Name ar", with: @cost_center.name_ar
    fill_in "Name en", with: @cost_center.name_en
    fill_in "Parent", with: @cost_center.parent
    check "Status" if @cost_center.status
    click_on "Update Cost center"

    assert_text "Cost center was successfully updated"
    click_on "Back"
  end

  test "should destroy Cost center" do
    visit cost_center_url(@cost_center)
    click_on "Destroy this cost center", match: :first

    assert_text "Cost center was successfully destroyed"
  end
end
