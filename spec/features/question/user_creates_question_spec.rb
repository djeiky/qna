require "rails_helper"

feature "User create questions", %q{
  In order to get answers
  I'd like to create question
} do

  describe "Authenticated user" do
    given(:user) { create(:user) }

    background do
      sign_in user

      visit root_path
      click_on "Create question"
    end
    scenario "creates question" do
      fill_in "Title", with: "Question title"
      fill_in "Body", with: "Question body"
      click_on "Create"

      expect(page).to have_content "Your question successfully created."
      expect(page).to have_content "Question title"
      expect(page).to have_content "Question body"
    end

    scenario "creates question with invalid params" do
      click_on "Create Question"

      expect(page).to have_content "Title can't be blank"
    end

    scenario "creates question with attached files" do
      fill_in "Title", with: "Question title"
      fill_in "Body", with: "Question body"
      attach_file "Files", %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on "Create"

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "creates question with award" do
      fill_in "Title", with: "Question title"
      fill_in "Body", with: "Question body"
      fill_in 'Award title', with: "Award for best answer"
      attach_file "Award image", "#{Rails.root}/spec/support/files/award.jpeg"
      click_on "Create"

      expect(page).to have_content "Award for best answer"
      expect(page).to have_css("img[src*='award.jpeg']")
    end

    scenario "multiply sessions, question appears on another user's session", js: true do

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in user
        visit new_question_path

        fill_in "Title", with: "Question title"
        fill_in "Body", with: "Question body"
        click_on "Create"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Question title"
      end
    end
  end

  scenario "Unauthenticated user" do
    visit root_path
    click_on "Create question"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
