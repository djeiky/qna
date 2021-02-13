# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one :award }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { accept_nested_attributes_for :links }

  it "have many atteched files" do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:resource) { create(:question) }
  end
end
