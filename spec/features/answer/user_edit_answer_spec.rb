require "rails_helper"

feature "Author can edit his answer", %q{
  In order to correct mistakes
  As author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_user) { create(:user) }

  scenario "Unauthenticated user can't edit answer", js: true do
    visit question_path(question)

    within(".answers") do
      expect(page).to have_no_link("Edit")
    end
  end
  describe "Authenticated user", js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario "edit own answer" do
      within ".answers" do
        click_on "Edit Answer"
        fill_in "Body", with: "Edited answer"
        click_on "Update Answer"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "Edited answer"
        expect(page).to_not have_button "Update answer"
      end
    end

    scenario "edit answer with invalid params" do
      within ".answers" do
        click_on "Edit Answer"
        fill_in "Body", with: ""
        click_on "Update Answer"

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "edit answer with attached files" do
      within ".answers" do
        click_on "Edit Answer"
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on "Update Answer"

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
    scenario "delete previous attached file" do
      within ".answers" do
        click_on "Edit Answer"
        attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on "Update Answer"
      end

      within ".answer-files" do
        click_on "Delete"
        expect(page).to_not have_link "spec_helper.rb"
      end
    end

    scenario "add links to own answer" do
      within ".answers" do
        click_on "Edit Answer"
        click_on "Add link"
        fill_in "Link name", with: "ya.ru"
        fill_in "Url", with: "http://ya.ru"
        click_on "Update Answer"

        expect(page).to_not have_link "ya.ru"
      end
    end

  end

  scenario "tries to edit somebody's answer" do
    sign_in another_user
    visit question_path(question)

    within ".answers" do
      expect(page).to have_no_link "Edit Answer"
    end
  end
end
