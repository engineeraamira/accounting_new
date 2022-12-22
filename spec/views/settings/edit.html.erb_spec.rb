require 'rails_helper'

RSpec.describe "settings/edit", type: :view do
  before(:each) do
    @setting = assign(:setting, Setting.create!(
      key: "MyString",
      description: "MyString",
      value: "MyString",
      boolean_value: "MyString",
      value1_ar: "MyString",
      value1_en: "MyString",
      value2_ar: "MyString",
      value2_en: "MyString",
      text1_ar: "MyString",
      text1_en: "MyString",
      text2_ar: "MyString",
      text2_en: "MyString"
    ))
  end

  it "renders the edit setting form" do
    render

    assert_select "form[action=?][method=?]", setting_path(@setting), "post" do

      assert_select "input[name=?]", "setting[key]"

      assert_select "input[name=?]", "setting[description]"

      assert_select "input[name=?]", "setting[value]"

      assert_select "input[name=?]", "setting[boolean_value]"

      assert_select "input[name=?]", "setting[value1_ar]"

      assert_select "input[name=?]", "setting[value1_en]"

      assert_select "input[name=?]", "setting[value2_ar]"

      assert_select "input[name=?]", "setting[value2_en]"

      assert_select "input[name=?]", "setting[text1_ar]"

      assert_select "input[name=?]", "setting[text1_en]"

      assert_select "input[name=?]", "setting[text2_ar]"

      assert_select "input[name=?]", "setting[text2_en]"
    end
  end
end
