# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it {should belong_to(:user)}

  it { should validate_presence_of :body }

  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}
  let!(:answers) {create_list(:answer, 5, question: question, user: user)}

  it "should set first answer as best" do
    answer = question.answers.first
    answer.set_best
    expect(answer).to be_best
  end

  it "should set second answer to best and first answer to not be best" do
    first_answer = question.answers.first
    second_answer = question.answers.second
    second_answer.set_best
    question.reload

    expect(first_answer).to_not be_best
    expect(second_answer).to be_best
  end
end
