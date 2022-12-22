require 'rails_helper'

RSpec.describe "settings/index", type: :view do
  before(:each) do
    assign(:settings, [
      Setting.create!(
        key: "Key",
        description: "Description",
        value: "Value",
        boolean_value: "Boolean Value",
        value1_ar: "Value1 Ar",
        value1_en: "Value1 En",
        value2_ar: "Value2 Ar",
        value2_en: "Value2 En",
        text1_ar: "Text1 Ar",
        text1_en: "Text1 En",
        text2_ar: "Text2 Ar",
        text2_en: "Text2 En"
      ),
      Setting.create!(
        key: "Key",
        description: "Description",
        value: "Value",
        boolean_value: "Boolean Value",
        value1_ar: "Value1 Ar",
        value1_en: "Value1 En",
        value2_ar: "Value2 Ar",
        value2_en: "Value2 En",
        text1_ar: "Text1 Ar",
        text1_en: "Text1 En",
        text2_ar: "Text2 Ar",
        text2_en: "Text2 En"
      )
    ])
  end

  it "renders a list of settings" do
    render
    assert_select "tr>td", text: "Key".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: "Value".to_s, count: 2
    assert_select "tr>td", text: "Boolean Value".to_s, count: 2
    assert_select "tr>td", text: "Value1 Ar".to_s, count: 2
    assert_select "tr>td", text: "Value1 En".to_s, count: 2
    assert_select "tr>td", text: "Value2 Ar".to_s, count: 2
    assert_select "tr>td", text: "Value2 En".to_s, count: 2
    assert_select "tr>td", text: "Text1 Ar".to_s, count: 2
    assert_select "tr>td", text: "Text1 En".to_s, count: 2
    assert_select "tr>td", text: "Text2 Ar".to_s, count: 2
    assert_select "tr>td", text: "Text2 En".to_s, count: 2
  end
end
