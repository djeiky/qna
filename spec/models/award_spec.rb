require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:recipient).class_name('User').optional }

  it { should validate_presence_of :title }

  it "have atteched file" do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
