require "rails_helper"

feature "Author can edit his question", %q{
  In order to edit question
  As author of question
  I want to see edit question page
} do
  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:another_user) {create(:user)}
  given!(:another_question) {create(:question, user: another_user)}

  scenario "Author can edit his question" do
    sign_in user
    visit question_path(question)
    click_on "Edit"

    fill_in "Title", with: "New Question Title"
    fill_in "Body", with: "New Question Body"
    click_on "Update Question"

    expect(page).to_not have_content question.title
    expect(page).to have_content "New Question Title"
    expect(page).to have_content "New Question Body"

  end

  scenario "Authenticated user can't edit somebody's question" do
    sign_in user
    visit edit_question_path(another_question)
    click_on "Update Question"

    expect(page).to have_no_link "Edit"
    expect(page).to have_content "You are not author of this question."
    expect(current_path).to eq question_path(another_question)
  end

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to have_no_link "Edit"

  end

end
