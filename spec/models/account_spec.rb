require 'rails_helper'

RSpec.describe Account, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  # subject { Account.new(name_ar: "الأصول", name_en: "Assets")}  it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end
  # it "is not valid without a first_name" do
  #   subject.first_name=nil
  #   expect(subject).to_not be_valid
  # end
  # it "is not valid without a last_name" do
  #   subject.last_name=nil
  #   expect(subject).to_not be_valid
  # end
  # it "is not valid without a phone number"    
  # it "is not valid if the phone number is not 10 chars"   
  #it "is not valid if the name ar is not all digits"

  describe "Associations" do
    it { should belong_to(:account).without_validating_presence }
    it { should have_many(:daily_transaction_details) }
  end

  subject {
    described_class.new(name_ar: "Anything",
                        name_en: "Lorem ipsum",
                        created_at: DateTime.now,
                        updated_at: DateTime.now + 1.week,
                        parent_account: nil
                      )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name_ar" do
    subject.name_ar = nil
    expect(subject).to_not be_valid
  end

end
