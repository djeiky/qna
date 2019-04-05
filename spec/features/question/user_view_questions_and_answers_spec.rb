require "rails_helper"

feature "User can view questions and answers to it", %q{
  In order to question with answers
  I want to see question's page
} do

  given(:question) {create(:question)}
  given(:answers) {create_list(:answer, 5, question: question)}

  scenario "User view question's page" do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each {|answer| expect(page).to have_content answer.body}
  end
end

