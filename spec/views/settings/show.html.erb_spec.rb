require 'rails_helper'

RSpec.describe "settings/show", type: :view do
  before(:each) do
    @setting = assign(:setting, Setting.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/Boolean Value/)
    expect(rendered).to match(/Value1 Ar/)
    expect(rendered).to match(/Value1 En/)
    expect(rendered).to match(/Value2 Ar/)
    expect(rendered).to match(/Value2 En/)
    expect(rendered).to match(/Text1 Ar/)
    expect(rendered).to match(/Text1 En/)
    expect(rendered).to match(/Text2 Ar/)
    expect(rendered).to match(/Text2 En/)
  end
end
